"""
AirSense — predictive air-quality Cloud Function (Firebase, Python).

Trigger: a new reading written by the ESP32 to
    /UsersData/{uid}/readings/air   ->  {ppm, co, methane, ammonia, temp, humid}

On each reading this function:
  1. appends the reading (+ server timestamp) to /readings/history
  2. keeps only the last WINDOW entries
  3. once WINDOW readings exist, scales them with the EXACT training stats
     (serving_config.json), runs the int8 TFLite model, and reconstructs the
     forecast as  last_gas + predicted_residual
  4. writes /readings/forecast = {predicted_ppm, willExceedThreshold, ...}

The Flutter app just reads /readings/forecast — no model code on the client.

CADENCE NOTE: the model was trained on HOURLY data (window=24h, horizon=+1h).
The firmware currently pushes every ~2s. For a faithful forecast, sample the
device hourly (or retrain at the device's cadence). The window logic here is
cadence-agnostic; only the *meaning* of the horizon depends on the sampling rate.
"""
import json
import os
import time
from datetime import datetime, timezone
import math

import numpy as np
from firebase_admin import initialize_app, db
from firebase_functions import db_fn, options

# LiteRT / TFLite interpreter — try the standalone runtimes first, fall back to TF.
try:
    from ai_edge_litert.interpreter import Interpreter
except ImportError:  # pragma: no cover
    try:
        from tflite_runtime.interpreter import Interpreter
    except ImportError:
        from tensorflow.lite import Interpreter

initialize_app()

_HERE = os.path.dirname(__file__)
with open(os.path.join(_HERE, "serving_config.json")) as f:
    CFG = json.load(f)

# Load the int8 model once per instance (cold start) and reuse across invocations.
_interp = Interpreter(model_path=os.path.join(_HERE, "model_int8.tflite"))
_interp.allocate_tensors()
_IN = _interp.get_input_details()[0]["index"]
_OUT = _interp.get_output_details()[0]["index"]

MEAN = np.asarray(CFG["scaler_mean"], dtype=np.float32)
SCALE = np.asarray(CFG["scaler_scale"], dtype=np.float32)
WINDOW = CFG["window"]
TARGET = CFG["target"]
GAS_FIELD = CFG["field_map"][TARGET]            # e.g. "ppm"
THRESHOLD = CFG["unhealthy_threshold"]


def _time_feats(ts_epoch: float):
    """Cyclical hour/day-of-week features from an epoch timestamp (UTC)."""
    dt = datetime.fromtimestamp(ts_epoch, tz=timezone.utc)
    h, dow = dt.hour, dt.weekday()
    return {
        "hour_sin": math.sin(2 * math.pi * h / 24),
        "hour_cos": math.cos(2 * math.pi * h / 24),
        "dow_sin": math.sin(2 * math.pi * dow / 7),
        "dow_cos": math.cos(2 * math.pi * dow / 7),
    }


def _row(entry: dict) -> list:
    """Build one feature row in the exact training order from a history entry."""
    tf_feats = _time_feats(entry.get("ts", time.time()))
    field_map = CFG["field_map"]                # model_feature -> device field
    row = []
    for feat in CFG["feature_order"]:
        if feat in field_map:                   # a sensor field
            row.append(float(entry[field_map[feat]]))
        else:                                   # a derived time feature
            row.append(tf_feats[feat])
    return row


@db_fn.on_value_written(
    reference="/UsersData/{uid}/readings/air",
    region="asia-southeast1",
    memory=options.MemoryOption.MB_512,
)
def forecast_air_quality(event: db_fn.Event) -> None:
    after = event.data.after
    if after is None:
        return                                  # reading deleted; nothing to do
    reading = dict(after)
    uid = event.params["uid"]
    base = db.reference(f"/UsersData/{uid}/readings")

    # 1) append to history with a trustworthy server-side timestamp
    reading["ts"] = time.time()
    base.child("history").push(reading)

    # 2) keep only the most recent WINDOW entries
    hist_ref = base.child("history")
    recent = hist_ref.order_by_key().limit_to_last(WINDOW).get() or {}
    entries = [recent[k] for k in sorted(recent.keys())]

    if len(entries) < WINDOW:
        base.child("forecast").set({
            "status": "warming_up",
            "have": len(entries), "need": WINDOW,
        })
        return

    # 3) build + scale the window, run the model, reconstruct the forecast
    X = np.asarray([_row(e) for e in entries], dtype=np.float32)
    X = (X - MEAN) / SCALE
    _interp.set_tensor(_IN, X[np.newaxis, :, :])
    _interp.invoke()
    delta = float(_interp.get_tensor(_OUT).ravel()[0])

    last_gas = float(entries[-1][GAS_FIELD])
    predicted = last_gas + delta

    # 4) publish the forecast for the app to read
    base.child("forecast").set({
        "status": "ok",
        "predicted_ppm": round(predicted, 2),
        "current_ppm": round(last_gas, 2),
        "willExceedThreshold": bool(predicted > THRESHOLD),
        "threshold": THRESHOLD,
        "horizon_steps": CFG["horizon"],
        "generatedAt": datetime.now(timezone.utc).isoformat(),
    })

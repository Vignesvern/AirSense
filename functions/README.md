# AirSense — Predictive Air Quality (Cloud Function)

A Firebase Cloud Function (Python) that turns AirSense from *reactive* ("air is
bad now") into *predictive* ("air will be unhealthy soon"). It runs an int8
TFLite model server-side and writes a forecast back to Realtime Database; the
Flutter app just reads it.

## How it works
```
ESP32 → /UsersData/{uid}/readings/air      (latest reading, existing behaviour)
            │
            ▼  (on write)  Cloud Function: forecast_air_quality
        append → /readings/history          (rolling window + server timestamp)
        run int8 model on last 24 readings
        write  → /readings/forecast = {
                   predicted_ppm, current_ppm,
                   willExceedThreshold, threshold, generatedAt }
```

The model predicts the **residual over persistence**; the function reconstructs
`forecast = last_gas + predicted_residual`. Preprocessing (feature order +
StandardScaler stats) comes from `serving_config.json`, exported at training time.

## Files
- `main.py` — the function
- `model_int8.tflite` — 35 KB int8 model (gas + temp + humidity → next-step gas)
- `serving_config.json` — feature order, scaler mean/scale, window, threshold
- `requirements.txt` — Python deps (firebase-functions, firebase-admin, numpy, ai-edge-litert)

## Deploy
Requires the Firebase **Blaze** plan (Cloud Functions need it) and the Firebase CLI.
```bash
npm install -g firebase-tools
firebase login
cd <repo root>
firebase init functions        # choose Python; point it at this functions/ dir
firebase deploy --only functions
```

## ⚠️ Before going live
1. **Cadence mismatch.** The model was trained on **hourly** data (window=24h,
   horizon=+1h) but the firmware pushes every ~2s. For a faithful forecast,
   sample the device hourly *or* retrain at the device's real cadence.
2. **uid is hardcoded** in the app (`hpS18EC...`); the function uses a `{uid}`
   wildcard, so it already works per-user — fix the app side when you generalise.
3. **Rotate the Firebase secret** that was committed in `Arduino/Arduino.ino`.
4. The model is a proof-of-concept trained on UCI data analogous to the AirSense
   sensors. Retrain on real device history (`/readings/history`) once collected.

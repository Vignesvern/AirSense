#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>
#include <Wire.h>

// WiFi credentials
const char *ssid = "SSN";
const char *password = "Ssn1!Som2@Sase3#";

#define FIREBASE_HOST "https://airsense-cf390-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define FIREBASE_AUTH "1aed1e832d1f021e2b646cef856003ed0b31d0a0" 

// MQTT Broker details
const char *mqtt_broker = "broker.emqx.io";
const char *topic_data = "emqx/air-quality/data";
const char *mqtt_username = "emqx";
const char *mqtt_password = "public";
const int mqtt_port = 1883;

// Sensor and output pins
const int MQ135_PIN = 34; // MQ135 sensor pin
const int DHT_PIN = 27; // DHT11/22 sensor pin
const int FLAME_SENSOR_PIN = 32; // Flame sensor pin
const int LED_ALERT = 12;
const int BUZZER_OUTPUT_PIN = 26;

#define DHTTYPE DHT11 // Change to DHT22 if using a DHT22
DHT dht(DHT_PIN, DHTTYPE);

float alert_threshold = 75.0; // Default air quality alert threshold

FirebaseData firebaseData;

WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  pinMode(MQ135_PIN, INPUT);
  pinMode(FLAME_SENSOR_PIN, INPUT);
  pinMode(LED_ALERT, OUTPUT);
  pinMode(BUZZER_OUTPUT_PIN, OUTPUT);

  dht.begin(); // Start DHT sensor

  // Connecting to Wi-Fi
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi.");

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);

  // Connecting to MQTT Broker
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);

  while (!client.connected()) {
    String client_id = "esp32-client-";
    client_id += String(WiFi.macAddress());
    Serial.printf("Connecting to MQTT Broker as %s\n", client_id.c_str());
    if (client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {
      Serial.println("Connected to MQTT Broker.");
    } else {
      Serial.print("Failed to connect, state: ");
      Serial.println(client.state());
      delay(2000);
    }
  }
}

void callback(char *topic, byte *payload, unsigned int length) {
  Serial.print("Message arrived on topic: ");
  Serial.println(topic);
  Serial.print("Message: ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
  Serial.println("-----------------------");

  // Parse incoming messages to adjust settings or respond to commands
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  // If the topic is for changing the air quality alert threshold
  if (String(topic) == "emqx/air-quality/threshold") {
    float new_threshold = message.toFloat();
    if (new_threshold > 0) {
      alert_threshold = new_threshold;
      Serial.print("New alert threshold set: ");
      Serial.println(alert_threshold);
    } else {
      Serial.println("Invalid threshold value received.");
    }
  }

  // Handle commands to turn on or off the alert LED and buzzer
  if (String(topic) == "emqx/air-quality/control") {
    if (message == "ALERT_ON") {
      digitalWrite(LED_ALERT, HIGH);
      tone(BUZZER_OUTPUT_PIN, 1000);
      Serial.println("Manual alert activated.");
    } else if (message == "ALERT_OFF") {
      digitalWrite(LED_ALERT, LOW);
      noTone(BUZZER_OUTPUT_PIN);
      Serial.println("Manual alert deactivated.");
    }
  }
}


void loop() {
  // Read air quality data
  int rawValue = analogRead(MQ135_PIN);
  float airQuality = (rawValue / 4095.0) * 100.0;

  // Read temperature and humidity
  float tempC = dht.readTemperature();
  float tempF = tempC * 9.0 / 5.0 + 32.0;
  float humidity = dht.readHumidity();

  // Check if DHT readings are valid
  if (isnan(tempC) || isnan(humidity)) {
    Serial.println("Failed to read from DHT sensor!");
  } else {
    // Display temperature and humidity
    Serial.print("Humidity: ");
    Serial.print(humidity);
    Serial.println("%");
    Serial.print("Temperature: ");
    Serial.print(tempC);
    Serial.print("°C / ");
    Serial.print(tempF);
    Serial.println("°F");

    // Publish temperature and humidity data
    char tempHumMessage[100];
    snprintf(tempHumMessage, sizeof(tempHumMessage), "Humidity: %.1f%%, Temp: %.1f°C / %.1f°F", humidity, tempC, tempF);
    client.publish(topic_data, tempHumMessage);
  }

  // Calculate sensor resistance (assuming a known load resistor of 10k ohms)
  float sensorResistance = (4095.0 - rawValue) * 10000.0 / rawValue;
  
  float co2_ppm = airQuality * 9.835; 
  float co_ppm = airQuality * 5.109;   
  float ch4_ppm = airQuality * 2.201;  
  float nh3_ppm = airQuality * 1.522;

  // Get timestamp
  String timestamp = String(millis() / 1000) + "s";

  // Display and publish sensor values
  Serial.print("Raw Analog Value: ");
  Serial.println(rawValue);
  Serial.print("Sensor Resistance: ");
  Serial.print(sensorResistance);
  Serial.println(" ohms");
  Serial.print("CO2 PPM: ");
  Serial.print(co2_ppm);
  Serial.print("CO: ");
  Serial.print(co_ppm);
  Serial.print("Methane (CH4) PPM: ");
  Serial.print(ch4_ppm);
  Serial.print("Ammonia (NH3) PPM: ");
  Serial.print(nh3_ppm);
  Serial.print("time : ");
  Serial.println(timestamp);

  // Publish data to MQTT
  char dataMessage[200];
  snprintf(dataMessage, sizeof(dataMessage),
           "Raw: %d, Resistance: %.2f ohms, CO2: %.2f ppm, CO: %.2f ppm, CH4: %.2f ppm, NH3: %.2f ppm, Time: %s",
           rawValue, sensorResistance, co2_ppm, co_ppm, ch4_ppm, nh3_ppm, timestamp.c_str());
  client.publish(topic_data, dataMessage);

  FirebaseJson json;
  json.set("ammonia", nh3_ppm);
  json.set("co", co_ppm);
  json.set("humid", humidity);
  json.set("methane", ch4_ppm);
  json.set("ppm", co2_ppm);
  json.set("temp", tempC);
  json.set("time", timestamp);

  if (Firebase.pushJSON(firebaseData, path, json)) {
    Serial.println("Data pushed to Firebase successfully.");
  } else {
    Serial.print("Failed to push data: ");
    Serial.println(firebaseData.errorReason());
  }

  // Flame detection logic
  bool flameDetected = digitalRead(FLAME_SENSOR_PIN) == LOW; // Adjust as needed based on sensor output
  if (flameDetected) {
    Serial.println("Flame detected!");
    digitalWrite(LED_ALERT, HIGH);
    tone(BUZZER_OUTPUT_PIN, 1000);
  } else {
    Serial.println("No flame detected => The fire is NOT detected");
    digitalWrite(LED_ALERT, LOW);
    noTone(BUZZER_OUTPUT_PIN);
  }

  delay(2000); // 2-second delay between each loop iteration
  client.loop();
}

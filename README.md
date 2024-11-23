# Indoor Air Quality Monitoring System

## Introduction
According to the United States EPA, Indoor Air Quality (IAQ) refers to the air quality within and around buildings and structures, especially as it relates to the health and comfort of building occupants. Immediate and Long-Term Effects of poor IAQ can be extremely harmful. This project aims to address this issue by creating an Indoor Air Quality Monitoring system using IoT devices. The system detects pollutants, measures air quality, and provides real-time alerts to occupants.

## Features
- **Real-time Monitoring**: Detects pollutants and measures air quality in public spaces.
- **Alert System**: Provides real-time alerts to users via an Android app.
- **Personalized Recommendations**: Offers recommendations such as opening windows or using air purifiers based on specific scenarios.
- **Gamified Reward System**: Integrates incentives for maintaining good indoor air quality.
- **Efficiency and Cost-effectiveness**: Performs real-time monitoring in an efficient and cost-effective manner.

## Hardware Used
- ESP8266 or ESP32
- DHT11 sensor (Temperature and Humidity)
- MQ-135 sensor (Pollutants)
- LEDs
- Buzzer
- Connecting Wires
- Breadboards

## Functionality
1. DHT11 sensor senses temperature and humidity, while MQ-135 sensor detects pollutants.
2. LEDs and Buzzer indicate unsafe air quality levels.
3. The system sends real-time notifications to the user's device via an Android app.
4. Personalized recommendations are provided based on specific scenarios, promoting healthier environments.
5. Integration of a gamified reward system incentivizes users to maintain good indoor air quality.

## App Development with Flutter
- **Framework**: Flutter is used for cross-platform app development, allowing for seamless deployment on both Android and iOS devices.
- **Real-time Graphs**: The syncfusion_flutter_charts library is utilized to create real-time graphs displaying air quality data in the app interface.
- **Real-time Database**: Firebase Realtime Database enables seamless synchronization of air quality data between devices in real-time.
- **User Authentication**: Firebase Authentication provides secure user authentication and management, ensuring only authorized users can access the app and its features.

## Future Work
- **Integration of Machine Learning**: Explore reinforcement learning algorithms to optimize air quality control strategies.
- **Integration with Other Sub-systems**: Integrate with purifiers or health monitoring applications for enhanced efficiency and operation.
- **Data Analysis and Insights**: Utilize machine learning techniques for analyzing historical data and providing insights for long-term improvements in indoor air quality.

## Installation
1. Clone the repository: `git clone https://github.com/Vignesvern/AirSense.git`
2. Navigate to the project directory: `cd AirSense`
3. Install dependencies: `flutter pub get`
4. Run the app on a simulator or connected device: `flutter run`

## Usage
1. Power on the system and ensure proper connectivity between sensors and IoT devices.
2. Monitor real-time air quality data and alerts on the Flutter app interface.
3. Follow personalized recommendations to maintain good indoor air quality.
4. Engage with the gamified reward system to earn incentives for maintaining air quality.


## Acknowledgements
- Special thanks to [Pethu Aravind](https://github.com/Aravind011464), [Sathishkumar](https://github.com/SathishKumar5115) & [Saikrishnan R](https://github.com/saikrishy3808u3qr3pur3q) for their contributions and support.
- This project was inspired by the need for real-time monitoring and improvement of indoor air quality for healthier living environments.

## Contact
For any inquiries or support, please contact [vignesvernb@gmail.com](vignesvernb@gmail.com).

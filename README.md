# Health Tracker Application

The Health Tracker app uses Bluetooth Low Energy (BLE) technology to connect with smartwatches and fitness trackers. It allows users to monitor various health metrics conveniently.

## Features

- **Bluetooth Connectivity:** Connect with smartwatches and fitness trackers using Bluetooth Low Energy.

- **Health Data Tracking:** Track essential health data such as:
  - Heart rate
  - Distance covered
  - Steps taken
  - Calories burnt

- **Scan for Devices:** Start with a scan screen to find nearby BLE devices.

- **Device Selection:** Choose which device to connect with from the list of scanned devices.

- **Continuous Monitoring:** Once connected, the app continuously listens for health data updates from the fitness tracker.

## How to Use
1. Scanning for Devices:
    - Open the app to the scan screen.
    - The app will automatically start scanning for nearby BLE devices.

2. Connecting to a Device:
    - Select your preferred device from the list of available devices.
    - The app will establish a connection with the selected device.

3. Tracking Health Data:
    - Once connected, the app will start receiving and displaying health data from the device in real-time.

## Installation
**1- Clone the repository:**

`git clone https://github.com/Youssef-Remah/Health_Tracker.git`

**2- Navigate to the project directory:**

`cd health-tracker`

**3- Install dependencies:**

`flutter pub get`

**4- Run the application:**

`flutter run`

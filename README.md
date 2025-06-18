🌤️ Weather App Using Flutter

A cross-platform weather application built with Flutter to provide real-time weather updates. Powered by the OpenWeatherMap API, this app features a sleek UI, location-based weather, and support for Android and iOS.
✨ Features

🌡️ Current weather conditions.
🔍 Search weather by city name.
📍 Auto-detect location for local weather updates.
⚠️ Robust error handling for network issues.




Prerequisites

Flutter SDK (version 3.0.0 or higher)
Dart (version 2.17.0 or higher)
An OpenWeatherMap API key

Installation

Clone the Repository:
git clone https://github.com/ranjitadh/Weather-App-Using-Flutter.git
cd Weather-App-Using-Flutter


Install Dependencies:
flutter pub get


Configure API Key:

Sign up at OpenWeatherMap to get an API key.
Add the key to a .env file in the project root:API_KEY=your_openweathermap_api_key


Alternatively, update the key in lib/services/weather_service.dart.


Run the App:
flutter run



📂 Project Structure
├── lib/ 
│                         # UI screens (home, search)
│   ├── models/           # API and location services
│   ├── Pages/            # Weather data models
│   ├── services/         # Reusable UI components
                          # Dependencies and configuration

📦 Dependencies

http: For API requests
geolocator: For location services
provider: For state management
flutter_spinkit: For loading animations

See pubspec.yaml for the complete list.




OpenWeatherMap for the weather API.
Flutter for an amazing framework.
The open-source community for inspiration and support.


⭐ Star this repo if you find it useful!



## Make a .env file create a API from the weather.org 

## Run the project 
-flutter run
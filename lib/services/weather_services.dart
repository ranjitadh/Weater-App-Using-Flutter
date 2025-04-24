import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_models.dart';

class WeatherServices {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices() : apiKey = dotenv.env['API_KEY'] ?? '';

  Future<Weather> fetchWeather(String cityName) async {
    print("Fetching weather for city: $cityName");
    print("API Key: $apiKey");
    final response = await http.get(
      Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'),
    );

    print("API Response Status: ${response.statusCode}");
    print("API Response Body: ${response.body}");
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.body}');
    }
  }

  Future<String> getCurrentCity() async {
    print("Checking location permission...");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("Location permission denied, requesting...");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    print("Getting current position...");
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("Position: ${position.latitude}, ${position.longitude}");

    print("Reverse geocoding...");
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        print("Geocoding timed out, using fallback city...");
        return [];
      });

      if (placemarks.isNotEmpty) {
        String? city = placemarks[0].locality;
        print("City Name: $city");
        return city ?? "Kathmandu"; // Fallback to your expected city
      } else {
        print("No placemarks found, using fallback city...");
        return "Kathmandu"; // Fallback to your expected city
      }
    } catch (e) {
      print("Geocoding failed: $e");
      return "Kathmandu"; // Fallback to your expected city
    }
  }
}
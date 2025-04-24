import 'package:flutter/material.dart';
import 'package:my_app/models/weather_models.dart';
import 'package:my_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  final _weatherServices = WeatherServices();
  Weather? _weather;
  String? _error;
  final _cityController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  // Fetch weather for the specified city
  fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _weather = null;
    });

    try {
      Weather weather = await _weatherServices.fetchWeather(cityName);
      setState(() {
        _weather = weather;
        _error = null;
      });
      _animationController.forward(from: 0); // Start the fade-in animation
    } catch (e) {
      setState(() {
        _error = e.toString();
        _weather = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Get weather icon based on condition
  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.bolt;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Light grey-blue background
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF26A69A), // Teal app bar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Search bar for city name
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  hintText: 'e.g., Kathmandu',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF26A69A),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF26A69A),
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(color: Color(0xFF212121)),
              ),
              const SizedBox(height: 20),
              // Search button with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF26A69A), // Teal
                      Color(0xFFFFCA28), // Orange
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    String cityName = _cityController.text.trim();
                    if (cityName.isNotEmpty) {
                      fetchWeather(cityName);
                    } else {
                      setState(() {
                        _error = 'Please enter a city name';
                        _weather = null;
                        _isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Search Weather',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Show loading indicator
              if (_isLoading)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF26A69A)),
                ),
              // Show error if it exists
              if (_error != null && !_isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Color(0xFFD32F2F), // Red for errors
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Show weather data if available
              if (_weather != null && !_isLoading)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: const Color(0xFFF5F5F5), // Semi-transparent white
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // City name
                          Text(
                            _weather!.cityName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Weather icon and temperature
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                getWeatherIcon(_weather!.maincondition),
                                color: const Color(0xFFFFCA28), // Orange icon
                                size: 40,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${_weather!.temperature.round()}°C",
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF212121),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Weather condition
                          Text(
                            _weather!.maincondition,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

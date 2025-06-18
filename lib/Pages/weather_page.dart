import 'package:flutter/material.dart';
import 'package:my_app/models/weather_models.dart';
import 'package:my_app/services/weather_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Providers/theme_provider.dart';

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
  bool _isCelsius = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fetchInitialWeather();
  }

  void _fetchInitialWeather() async {
    try {
      String city = await _weatherServices.getCurrentCity();
      fetchWeather(city);
    } catch (e) {
      setState(() {
        _error = 'Failed to get location: $e';
        _isLoading = false;
      });
    }
  }

  void fetchWeather(String cityName) async {
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
      _animationController.forward(from: 0);
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

  double _toFahrenheit(double celsius) => (celsius * 9 / 5) + 32;

  String _formatTime(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon:
                Icon(_isCelsius ? Icons.thermostat : Icons.thermostat_outlined),
            onPressed: () {
              setState(() {
                _isCelsius = !_isCelsius;
              });
            },
            tooltip: 'Toggle °C/°F',
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Enter city name',
                  hintText: 'e.g., Kathmandu',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    fetchWeather(value.trim());
                  }
                },
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [const Color(0xFF1E88E5), const Color(0xFF4FC3F7)]
                        : [const Color(0xFF0288D1), const Color(0xFF4FC3F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Get Weather',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator(),
              if (_error != null && !_isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_weather != null && !_isLoading)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _weather!.cityName,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  getWeatherIcon(_weather!.mainCondition),
                                  color: const Color(0xFFFFCA28),
                                  size: 48,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _isCelsius
                                      ? "${_weather!.temperature.round()}°C"
                                      : "${_toFahrenheit(_weather!.temperature).round()}°F",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _weather!.mainCondition,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                _buildWeatherDetail(
                                  icon: Icons.water_drop,
                                  label: 'Humidity',
                                  value: '${_weather!.humidity}%',
                                ),
                                _buildWeatherDetail(
                                  icon: Icons.wb_sunny,
                                  label: 'Sunrise',
                                  value: _formatTime(_weather!.sunrise),
                                ),
                                _buildWeatherDetail(
                                  icon: Icons.nights_stay,
                                  label: 'Sunset',
                                  value: _formatTime(_weather!.sunset),
                                ),
                                _buildWeatherDetail(
                                  icon: Icons.air,
                                  label: 'Wind Speed',
                                  value: '${_weather!.windSpeed} m/s',
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildWeatherDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

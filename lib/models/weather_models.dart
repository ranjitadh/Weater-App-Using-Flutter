class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int humidity;
  final int sunrise;
  final int sunset;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}

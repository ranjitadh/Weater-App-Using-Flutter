class Weather {
  final String cityName;
  final double temperature;
  final String maincondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.maincondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      maincondition: json['weather'][0]['main'],
    );
  }
}

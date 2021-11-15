import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final WeatherData current;
  final List<WeatherData> hourly;
  final List<WeatherData> daily;

  const Weather({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  @override
  List<Object?> get props => [current, hourly, daily];
}

class WeatherData extends Equatable {
  final int id;
  final DateTime dateTime;
  final double temp;
  final double windSpeed;
  final int pressure;
  final int humidity;
  final WeatherIcon icon;

  const WeatherData({
    required this.id,
    required this.dateTime,
    required this.temp,
    required this.windSpeed,
    required this.pressure,
    required this.humidity,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        dateTime,
        temp,
        windSpeed,
        pressure,
        humidity,
        icon,
      ];
}

enum WeatherIcon {
  d01,
  n01,
  d02,
  n02,
  d03,
  n03,
  d04,
  n04,
  d09,
  n09,
  d10,
  n10,
  d11,
  n11,
  d13,
  n13,
  d50,
  n50,
}

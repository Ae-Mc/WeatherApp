part of 'weather_model.dart';

@JsonSerializable(createToJson: false)
class SimpleWeather extends BaseWeather {
  @override
  final double temp;

  const SimpleWeather({
    required List<WeatherType> weather,
    required DateTime dt,
    required this.temp,
    required int pressure,
    required int humidity,
    required double windSpeed,
  }) : super(
          weather: weather,
          dt: dt,
          pressure: pressure,
          humidity: humidity,
          windSpeed: windSpeed,
        );

  factory SimpleWeather.fromJson(Map<String, dynamic> json) =>
      _$SimpleWeatherFromJson(json);

  @override
  double getTemp() => temp;
}

@JsonSerializable(createToJson: false)
class DayWeather extends BaseWeather {
  @override
  final Temp temp;

  const DayWeather({
    required List<WeatherType> weather,
    required DateTime dt,
    required this.temp,
    required int pressure,
    required int humidity,
    required double windSpeed,
  }) : super(
          weather: weather,
          dt: dt,
          pressure: pressure,
          humidity: humidity,
          windSpeed: windSpeed,
        );

  factory DayWeather.fromJson(Map<String, dynamic> json) =>
      _$DayWeatherFromJson(json);

  @override
  double getTemp() {
    return temp.day;
  }
}

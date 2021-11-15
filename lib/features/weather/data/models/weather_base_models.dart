part of 'weather_model.dart';

abstract class BaseWeather extends Equatable {
  final List<WeatherType> weather;
  @JsonKey(fromJson: _dateTimeFromSecondsSinceEpoch)
  final DateTime dt;
  final int pressure;
  final int humidity;
  @JsonKey(name: 'wind_speed')
  final double windSpeed;
  abstract final dynamic temp;

  const BaseWeather({
    required this.weather,
    required this.dt,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
  });

  static DateTime _dateTimeFromSecondsSinceEpoch(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
  }

  @override
  List<Object?> get props => [weather, dt, pressure, humidity, windSpeed, temp];

  double getTemp();

  WeatherData toWeatherData() {
    return WeatherData(
      id: weather.first.id,
      dateTime: dt,
      temp: getTemp(),
      windSpeed: windSpeed,
      pressure: pressure.toDouble(),
      humidity: humidity,
      icon: WeatherIcon.values[weather.first.icon.index],
    );
  }
}

@JsonSerializable(createToJson: false)
class WeatherType extends Equatable {
  final int id;
  final String main;
  final String description;
  final SerializableWeatherIcon icon;

  const WeatherType({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherType.fromJson(Map<String, dynamic> json) =>
      _$WeatherTypeFromJson(json);

  @override
  List<Object?> get props => [id, main, description, icon];
}

@JsonSerializable(createToJson: false)
class Temp {
  @JsonKey(name: 'morn')
  final double morning;
  final double day;
  @JsonKey(name: 'eve')
  final double evening;
  final double night;
  final double min;
  final double max;

  Temp({
    required this.morning,
    required this.day,
    required this.evening,
    required this.night,
    required this.min,
    required this.max,
  });

  factory Temp.fromJson(Map<String, dynamic> json) => _$TempFromJson(json);
}

enum SerializableWeatherIcon {
  @JsonValue('01d')
  d01,
  @JsonValue('01n')
  n01,
  @JsonValue('02d')
  d02,
  @JsonValue('02n')
  n02,
  @JsonValue('03d')
  d03,
  @JsonValue('03n')
  n03,
  @JsonValue('04d')
  d04,
  @JsonValue('04n')
  n04,
  @JsonValue('09d')
  d09,
  @JsonValue('09n')
  n09,
  @JsonValue('10d')
  d10,
  @JsonValue('10n')
  n10,
  @JsonValue('11d')
  d11,
  @JsonValue('11n')
  n11,
  @JsonValue('13d')
  d13,
  @JsonValue('13n')
  n13,
  @JsonValue('50d')
  d50,
  @JsonValue('50n')
  n50,
}

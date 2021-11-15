import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';

part 'weather_base_models.dart';
part 'weather_data_models.dart';
part 'weather_model.g.dart';

@JsonSerializable(createToJson: false)
class WeatherModel extends Equatable {
  final SimpleWeather current;
  final List<SimpleWeather> hourly;
  final List<DayWeather> daily;

  const WeatherModel(this.current, this.hourly, this.daily);

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Weather toWeather() {
    return Weather(
      current: current.toWeatherData(),
      hourly: hourly.map((e) => e.toWeatherData()).toList(),
      daily: daily.map((e) => e.toWeatherData()).toList(),
    );
  }

  @override
  List<Object?> get props => [current, hourly, daily];
}

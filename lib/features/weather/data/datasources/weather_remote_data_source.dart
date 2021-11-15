import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  const WeatherRemoteDataSource();

  Future<WeatherModel> getWeather(Place place);
}

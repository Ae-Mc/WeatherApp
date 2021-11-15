import 'package:weather_app/core/error/handlers.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/tokens.dart';

part 'weather_remote_data_source_impl.g.dart';

class WeatherRemoteDataSourceImpl extends WeatherRemoteDataSource {
  final OpenWeatherApi api;

  const WeatherRemoteDataSourceImpl({
    required this.api,
  });

  @override
  Future<WeatherModel> getWeather(Place place) async {
    return await Handlers.handleDioRequestException(
      () => api.weather(place.latitude, place.longitude),
    );
  }
}

@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class OpenWeatherApi {
  factory OpenWeatherApi(Dio dio, {String? baseUrl}) = _OpenWeatherApi;

  @GET('onecall')
  Future<WeatherModel> weather(
    @Query('lat') double latitude,
    @Query('lon') double longitude, {
    @Query('lang') String language = 'ru',
    @Query('units') String units = 'metric',
    @Query('appid') String apiKey = Tokens.openWeatherApiKey,
  });
}

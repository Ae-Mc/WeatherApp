import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/data/models/onecall_result.dart';
import 'package:weather_app/tokens.dart';

part 'openweather.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class OpenWeatherApi {
  factory OpenWeatherApi(Dio dio, {String? baseUrl}) = _OpenWeatherApi;

  @GET('onecall')
  Future<OneCallResult> weather(
    @Query('lat') double latitude,
    @Query('lon') double longitude, {
    @Query('lang') String language = 'ru',
    @Query('units') String units = 'metric',
    @Query('appid') String apiKey = Tokens.openWeatherApiKey,
  });
}

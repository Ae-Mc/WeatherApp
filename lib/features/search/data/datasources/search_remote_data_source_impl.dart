import 'dart:convert';

import 'package:weather_app/core/error/handlers.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:weather_app/features/search/data/models/place_model.dart';
import 'package:weather_app/tokens.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'search_remote_data_source_impl.g.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final GeoNamesApi api;
  final NetworkInfo networkInfo;

  SearchRemoteDataSourceImpl({required this.api, required this.networkInfo});

  @override
  Future<List<PlaceModel>> searchPlaces(String query) async {
    return await Handlers.handleDioRequestException(() async {
      final result = await api.search(query);
      return (jsonDecode(result.data)['geonames'] as List)
          .map((e) => PlaceModel.fromJson(e))
          .toList();
    });
  }
}

@RestApi(baseUrl: 'http://api.geonames.org/')
abstract class GeoNamesApi {
  factory GeoNamesApi(Dio dio, {String? baseUrl}) = _GeoNamesApi;

  @GET('searchJSON')
  Future<HttpResponse<String>> search(
    @Query('name', encoded: true) String name, {
    @Query('lang') String language = 'ru',
    @Query('username') String username = Tokens.geoNamesUsername,
    @Query('orderby') String orderBy = 'population',
    @Query('fuzzy') double fuzzy = 1,
    @Query('maxRows') int maxRows = 10,
  });
}

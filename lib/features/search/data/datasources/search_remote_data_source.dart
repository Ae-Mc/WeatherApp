import 'dart:convert';

import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/search/data/models/place_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/tokens.dart';

part 'search_remote_data_source.g.dart';

abstract class SearchRemoteDataSource {
  Future<List<PlaceModel>> searchPlaces(String query);
}


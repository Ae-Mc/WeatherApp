import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:weather_app/features/search/data/datasources/search_remote_data_source_impl.dart';
import 'package:weather_app/features/search/data/models/place_model.dart';
import 'search_remote_data_source_test.mocks.dart';

import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([Dio, NetworkInfo])
void main() {
  final dio = MockDio();
  final networkInfo = MockNetworkInfo();
  late GeoNamesApi geoNamesApi;
  late SearchRemoteDataSource remoteDataSource;

  when(networkInfo.isConnected).thenAnswer((_) async => true);
  when(dio.options).thenReturn(BaseOptions());

  group('SearchRemoteDataSource tests.', () {
    setUp(() {
      geoNamesApi = GeoNamesApi(dio);
      remoteDataSource = SearchRemoteDataSourceImpl(
        api: geoNamesApi,
        networkInfo: networkInfo,
      );
    });

    test('Throws ConnectionException on null response', () async {
      when(dio.fetch(any)).thenThrow(
        DioError(requestOptions: RequestOptions(path: '')),
      );
      expect(
        remoteDataSource.searchPlaces('Any'),
        throwsA(const ConnectionException()),
      );
    });

    test(
      'Throws ServerException with status code on response with code != 200',
      () async {
        when(dio.fetch(any)).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 404,
            ),
          ),
        );
        expect(
          remoteDataSource.searchPlaces('Any'),
          throwsA(const ServerException(404)),
        );
      },
    );

    test('Search results parsing', () async {
      when(dio.fetch(any)).thenAnswer(
        (_) async => Response<String>(
          requestOptions: RequestOptions(path: ''),
          data: fixture('places.json'),
        ),
      );
      final jsonString = fixture('places.json');
      final places = jsonDecode(jsonString)['geonames']
          .map((e) => PlaceModel.fromJson(e))
          .toList();
      clearInteractions(dio);
      final result = await remoteDataSource.searchPlaces('St.Petersburg');
      verify(dio.fetch(any)).called(1);
      expect(result, places);
    });
  });
}

import 'package:weather_app/features/search/data/models/place_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<PlaceModel>> searchPlaces(String query);
}

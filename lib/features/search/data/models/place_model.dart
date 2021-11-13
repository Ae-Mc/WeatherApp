import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';

part 'place_model.g.dart';

String toString(dynamic x) => x.toString();

@JsonSerializable()
class PlaceModel extends Equatable implements Place {
  @override
  @JsonKey(name: 'countryName')
  final String? country;
  @override
  @JsonKey(name: 'lat', fromJson: double.parse, toJson: toString)
  final double latitude;
  @override
  @JsonKey(name: 'lng', fromJson: double.parse, toJson: toString)
  final double longitude;
  @override
  final String name;
  @override
  final int population;

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);

  const PlaceModel({
    this.country,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.population,
  });

  factory PlaceModel.fromPlace(Place place) => PlaceModel(
        name: place.name,
        latitude: place.latitude,
        longitude: place.longitude,
        population: place.population,
      );

  @override
  List<Object?> get props => [country, name, latitude, longitude, population];

  @override
  bool? get stringify => true;
}

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Place extends Equatable {
  final String? country;
  final String name;
  final double latitude;
  final double longitude;
  final int population;

  const Place({
    this.country,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.population,
  });

  @override
  get props => [country, name, latitude, longitude, population];

  @override
  String toString() {
    if (country == null) {
      return name;
    }
    return '$country, $name';
  }
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/data/models/weather_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('WeatherModel tests.', () {
    test('Weather parsing', () {
      WeatherModel.fromJson(jsonDecode(fixture('weather.json')));
    });
  });
}

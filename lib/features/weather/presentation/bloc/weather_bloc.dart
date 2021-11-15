import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/gen/assets.gen.dart';

part 'weather_event.dart';
part 'weather_state.dart';

const unknownErrorMessage =
    'Произошла неизвестная ошибка при попытке получить информацию о погоде';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  late final GetWeather getWeather;
  late final StreamSubscription settingsBlocSubscription;
  Settings? _lastSettings;

  WeatherBloc() : super(const WeatherInitial()) {
    on<WeatherInitialized>((event, emit) {
      getWeather = GetWeather(event.repository);
      settingsBlocSubscription =
          event.settingsBloc.stream.listen((settingsState) {
        if (settingsState is SettingsSuccess) {
          _lastSettings = settingsState.settings;
          add(WeatherPlaceChanged(settingsState.settings.activePlace));
        }
      });
    });
    on<WeatherPlaceChanged>((event, emit) async {
      await updateWeather(emit, event.place);
    });
    on<WeatherUpdateRequested>((event, emit) async {
      if (_lastSettings == null) {
        emit(const WeatherFailure(unknownErrorMessage));
      } else {
        await updateWeather(emit, _lastSettings!.activePlace);
      }
    });
  }

  Future<void> updateWeather(Emitter<WeatherState> emit, Place place) async {
    emit(const WeatherLoadInProgress());
    (await getWeather(Params(place))).fold(
      (l) => emit(WeatherFailure(mapFailureToMessage(l))),
      (r) => emit(WeatherSuccess(convertWeatherAccordingToCurrentSettings(r))),
    );
  }

  Weather convertWeatherAccordingToCurrentSettings(Weather weather) {
    if (_lastSettings == null) {
      return weather;
    }
    return Weather(
      current: convertWeatherDataAccordingToCurrentSettings(weather.current),
      hourly: weather.hourly
          .map((e) => convertWeatherDataAccordingToCurrentSettings(e))
          .toList(),
      daily: weather.daily
          .map((e) => convertWeatherDataAccordingToCurrentSettings(e))
          .toList(),
    );
  }

  WeatherData convertWeatherDataAccordingToCurrentSettings(WeatherData data) {
    return WeatherData(
      dateTime: data.dateTime,
      humidity: data.humidity,
      icon: data.icon,
      id: data.id,
      pressure: convertPressure(data.pressure),
      temp: convertTemp(data.temp),
      windSpeed: convertSpeed(data.windSpeed),
    );
  }

  double convertPressure(double pressureInHectopascal) {
    if (_lastSettings?.pressureUnits == PressureUnits.mmOfMercury) {
      return pressureInHectopascal * 0.7500638;
    }
    return pressureInHectopascal;
  }

  double convertTemp(double celciusTemp) {
    if (_lastSettings?.temperatureUnits == TemperatureUnits.farenheit) {
      return celciusTemp * 1.8 + 32;
    }
    return celciusTemp;
  }

  double convertSpeed(double speedInMetersPerSecond) {
    if (_lastSettings?.speedUnits == SpeedUnits.kilometersPerHour) {
      return speedInMetersPerSecond * 3.6;
    }
    return speedInMetersPerSecond;
  }

  static AssetGenImage getIconFromWeather(WeatherData data) {
    switch (data.icon) {
      case WeatherIcon.d01:
      case WeatherIcon.n01:
        return Assets.icons.universal.sun;
      case WeatherIcon.d02:
      case WeatherIcon.n02:
        return Assets.icons.universal.partlyCloudy;
      case WeatherIcon.d03:
      case WeatherIcon.n03:
      case WeatherIcon.d04:
      case WeatherIcon.n04:
        return Assets.icons.universal.cloudy;
      case WeatherIcon.d09:
      case WeatherIcon.n09:
        return Assets.icons.universal.rain;
      case WeatherIcon.d10:
      case WeatherIcon.n10:
        return Assets.icons.universal.rain3Drops;
      case WeatherIcon.d11:
      case WeatherIcon.n11:
        return Assets.icons.universal.thunderstorm;
      case WeatherIcon.d13:
      case WeatherIcon.n13:
        return Assets.icons.universal.snowy;
      case WeatherIcon.d50:
      case WeatherIcon.n50:
        return Assets.icons.universal.mist;
    }
  }

  static String mapFailureToMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return connectionErrorMessage;
    }
    if (failure is ServerFailure) {
      return serverErrorMessage;
    }
    return unknownErrorMessage;
  }

  @override
  Future<void> close() {
    settingsBlocSubscription.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:weather_app/features/weather/domain/entities/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather/domain/usecases/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

const unknownErrorMessage =
    'Произошла неизвестная ошибка при попытке получить информацию о погоде';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  late final GetWeather getWeather;
  late final StreamSubscription settingsBlocSubscription;

  WeatherBloc() : super(const WeatherInitial()) {
    on<WeatherInitialized>((event, emit) {
      getWeather = GetWeather(event.repository);
      settingsBlocSubscription =
          event.settingsBloc.stream.listen((settingsState) {
        if (settingsState is SettingsSuccess) {
          add(WeatherPlaceChanged(settingsState.settings.activePlace));
        }
      });
    });
    on<WeatherPlaceChanged>((event, emit) async {
      emit(const WeatherLoadInProgress());
      (await getWeather(Params(event.place))).fold(
        (l) => emit(WeatherFailure(mapFailureToMessage(l))),
        (r) => emit(WeatherSuccess(r)),
      );
    });
  }

  String mapFailureToMessage(Failure failure) {
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

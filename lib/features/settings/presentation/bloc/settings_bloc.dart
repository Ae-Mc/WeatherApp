import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/usecases/usecase.dart';
import 'package:weather_app/features/settings/domain/entities/settings.dart';
import 'package:weather_app/features/search/domain/entities/place.dart';
import 'package:weather_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:weather_app/features/settings/domain/usecases/set_settings.dart';
import 'package:weather_app/features/settings/domain/usecases/get_settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

const loadErrorMessage = 'Неизвестная ошибка при получении настроек.';
const saveErrorMessage = 'Неизвестная ошибка при сохранении настроек.';
const uninitializedErrorMessage =
    'Ошибка! Попытка изменения настроек до их инициализации.';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final SetSettings setSettings;
  late final GetSettings getSettings;

  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsInitialized>((event, emit) async {
      emit(SettingsInProgress());
      setSettings = SetSettings(event.property);
      getSettings = GetSettings(event.property);
      await loadSettings(
        emit,
        (settings) => emit(SettingsSuccess(settings)),
      );
    });
    on<SettingsFavoriteAdded>(
      (event, emit) async => updateSettings(
        emit,
        (settings) => settings.copyWith(
          favorites: List.from(settings.favorites)..add(event.property),
        ),
      ),
    );
    on<SettingsFavoriteRemoved>(
      (event, emit) async => updateSettings(
        emit,
        (settings) => settings.copyWith(
          favorites: List.from(settings.favorites)..remove(event.property),
        ),
      ),
    );
    initializePropertySetters();
  }

  void initializePropertySetters() {
    on<SetringsTemperatureUnitsSet>(
      (event, emit) async => await updateSettings(
        emit,
        (settings) => settings.copyWith(temperatureUnits: event.property),
      ),
    );
    on<SettingsSpeedUnitsSet>(
      (event, emit) async => await updateSettings(
        emit,
        (settings) => settings.copyWith(speedUnits: event.property),
      ),
    );
    on<SettingsPressureUnitsSet>(
      (event, emit) async => await updateSettings(
        emit,
        (settings) => settings.copyWith(pressureUnits: event.property),
      ),
    );
    on<SettingsThemeModeSet>(
      (event, emit) async => await updateSettings(
        emit,
        (settings) => settings.copyWith(themeMode: event.property),
      ),
    );
    on<SettingsActivePlaceSet>(
      (event, emit) async => await updateSettings(
        emit,
        (settings) => settings.copyWith(activePlace: event.property),
      ),
    );
  }

  Future<void> loadSettings(
    Emitter<SettingsState> emit,
    Function(Settings settings) f,
  ) async {
    final settingsEither = await getSettings(NoParams());
    await settingsEither.fold(
      (l) {
        emit(const SettingsFailure(loadErrorMessage));
      },
      f,
    );
  }

  Future<void> updateSettings(
    Emitter<SettingsState> emit,
    Settings Function(Settings settings) modifier,
  ) async {
    if (state is SettingsInitial || state is SettingsFailure) {
      emit(const SettingsFailure(uninitializedErrorMessage));
      return;
    }
    final curState = state as SettingsSuccess;
    emit(SettingsInProgress());
    final newSettings = modifier(curState.settings);
    final result = await setSettings(Params(newSettings));
    result.fold(
      (l) => emit(const SettingsFailure(saveErrorMessage)),
      (r) => emit(SettingsSuccess(newSettings)),
    );
  }
}

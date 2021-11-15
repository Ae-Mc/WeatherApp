part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

abstract class SinglePropertyEvent<T> extends SettingsEvent {
  final T property;

  const SinglePropertyEvent(this.property);

  @override
  List<Object?> get props => [property];
}

class SettingsInitialized extends SinglePropertyEvent<SettingsRepository> {
  const SettingsInitialized(SettingsRepository repository) : super(repository);
}

class SetringsTemperatureUnitsSet
    extends SinglePropertyEvent<TemperatureUnits> {
  const SetringsTemperatureUnitsSet(TemperatureUnits units) : super(units);
}

class SettingsSpeedUnitsSet extends SinglePropertyEvent<SpeedUnits> {
  const SettingsSpeedUnitsSet(SpeedUnits units) : super(units);
}

class SettingsPressureUnitsSet extends SinglePropertyEvent<PressureUnits> {
  const SettingsPressureUnitsSet(PressureUnits units) : super(units);
}

class SettingsThemeModeSet extends SinglePropertyEvent<ThemeMode> {
  const SettingsThemeModeSet(ThemeMode themeMode) : super(themeMode);
}

class SettingsActivePlaceSet extends SinglePropertyEvent<Place> {
  const SettingsActivePlaceSet(Place place) : super(place);
}

class SettingsFavoriteAdded extends SinglePropertyEvent<Place> {
  const SettingsFavoriteAdded(Place place) : super(place);
}

class SettingsFavoriteRemoved extends SinglePropertyEvent<Place> {
  const SettingsFavoriteRemoved(Place place) : super(place);
}

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

class Init extends SinglePropertyEvent<SettingsRepository> {
  const Init(SettingsRepository repository) : super(repository);
}

class SetTemperatureUnits extends SinglePropertyEvent<TemperatureUnits> {
  const SetTemperatureUnits(TemperatureUnits units) : super(units);
}

class SetSpeedUnits extends SinglePropertyEvent<SpeedUnits> {
  const SetSpeedUnits(SpeedUnits units) : super(units);
}

class SetPressureUnits extends SinglePropertyEvent<PressureUnits> {
  const SetPressureUnits(PressureUnits units) : super(units);
}

class SetThemeMode extends SinglePropertyEvent<ThemeMode> {
  const SetThemeMode(ThemeMode themeMode) : super(themeMode);
}

class SetActivePlace extends SinglePropertyEvent<Place> {
  const SetActivePlace(Place place) : super(place);
}

class AddFavorite extends SinglePropertyEvent<Place> {
  const AddFavorite(Place place) : super(place);
}

class RemoveFavorite extends SinglePropertyEvent<Place> {
  const RemoveFavorite(Place place) : super(place);
}

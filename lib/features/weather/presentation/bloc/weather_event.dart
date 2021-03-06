part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherInitialized extends WeatherEvent {
  final WeatherRepository repository;
  final SettingsBloc settingsBloc;

  const WeatherInitialized({
    required this.repository,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [repository, settingsBloc];
}

class WeatherPlaceChanged extends WeatherEvent {
  final Place place;

  const WeatherPlaceChanged(this.place);

  @override
  List<Object> get props => [place];
}

class WeatherUpdateRequested extends WeatherEvent {
  const WeatherUpdateRequested();
}

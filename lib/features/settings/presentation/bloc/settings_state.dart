part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class Empty extends SettingsState {
  @override
  List<Object> get props => [];
}

class Loading extends SettingsState {
  @override
  List<Object?> get props => [];
}

class Loaded extends SettingsState {
  final Settings settings;

  const Loaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class Error extends SettingsState {
  final String message;

  const Error(this.message);

  @override
  List<Object?> get props => [message];
}

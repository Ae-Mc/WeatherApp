part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsInProgress extends SettingsState {
  @override
  List<Object?> get props => [];
}

class SettingsSuccess extends SettingsState {
  final Settings settings;

  const SettingsSuccess(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsFailure extends SettingsState {
  final String message;

  const SettingsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

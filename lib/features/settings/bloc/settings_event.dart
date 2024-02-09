part of 'settings_bloc.dart';

enum ChangeUnitKeys { temperature, preassure, speed }

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class SettingsEventLoading extends SettingsEvent {
  const SettingsEventLoading();
}

final class SettingsEventChangeUnit extends SettingsEvent {
  final dynamic newUnit;

  const SettingsEventChangeUnit({
    required this.newUnit,
  });
}

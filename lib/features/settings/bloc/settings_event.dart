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

final class SettingsEventChangeSpeedUnit extends SettingsEvent {
  final WindSpeedUnits speedUnit;

  const SettingsEventChangeSpeedUnit({
    required this.speedUnit,
  });
}

final class SettingsEventChangeTemperatureUnit extends SettingsEvent {
  final TemperatureUnits temperatureUnit;

  const SettingsEventChangeTemperatureUnit({
    required this.temperatureUnit,
  });
}

final class SettingsEventChangePreassureUnit extends SettingsEvent {
  final PreassureUnits preassureUnit;

  const SettingsEventChangePreassureUnit({
    required this.preassureUnit,
  });
}

part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, error }

final class SettingsState extends Equatable {
  final SettingsStatus status;
  final String temperatureTitle;
  final String speedTitle;
  final String preassureTitle;
  final Map<String, dynamic> temperatureTitles;
  final Map<String, dynamic> preassureTitles;
  final Map<String, dynamic> windSpeedTitles;
  final String errorTitle;
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.errorTitle = '',
    this.temperatureTitle = '',
    this.speedTitle = '',
    this.preassureTitle = '',
    this.temperatureTitles = const {},
    this.preassureTitles = const {},
    this.windSpeedTitles = const {},
  });

  SettingsState copyWith({
    SettingsStatus Function()? status,
    String Function()? errorTitle,
    String Function()? temperatureTitle,
    String Function()? speedTitle,
    String Function()? preassureTitle,
    Map<String, dynamic> Function()? temperatureTitles,
    Map<String, dynamic> Function()? preassureTitles,
    Map<String, dynamic> Function()? windSpeedTitles,
  }) =>
      SettingsState(
        status: status != null ? status() : this.status,
        errorTitle: errorTitle != null ? errorTitle() : this.errorTitle,
        speedTitle: speedTitle != null ? speedTitle() : this.speedTitle,
        temperatureTitle: temperatureTitle != null
            ? temperatureTitle()
            : this.temperatureTitle,
        preassureTitle:
            preassureTitle != null ? preassureTitle() : this.preassureTitle,
        temperatureTitles: temperatureTitles != null
            ? temperatureTitles()
            : this.temperatureTitles,
        preassureTitles:
            preassureTitles != null ? preassureTitles() : this.preassureTitles,
        windSpeedTitles:
            windSpeedTitles != null ? windSpeedTitles() : this.windSpeedTitles,
      );

  @override
  List<Object> get props => [
        status,
        errorTitle,
        temperatureTitle,
        speedTitle,
        preassureTitle,
        temperatureTitles,
        preassureTitles,
        windSpeedTitles,
      ];
}

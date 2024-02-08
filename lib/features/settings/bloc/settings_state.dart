part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, error }

final class SettingsState extends Equatable {
  final SettingsStatus status;
  final String temperatureTitle;
  final String speedTitle;
  final String preassureTitle;
  final String errorTitle;
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.errorTitle = '',
    this.temperatureTitle = 'csgvsd',
    this.speedTitle = 'csgvsd',
    this.preassureTitle = 'csgvsd',
  });

  SettingsState copyWith({
    SettingsStatus Function()? status,
    String Function()? errorTitle,
    String Function()? temperatureTitle,
    String Function()? speedTitle,
    String Function()? preassureTitle,
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
      );

  @override
  List<Object> get props => [
        status,
        errorTitle,
        temperatureTitle,
        speedTitle,
        preassureTitle,
      ];
}

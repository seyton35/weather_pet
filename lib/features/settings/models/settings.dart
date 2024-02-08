import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final String temperatureTitle;
  final String speedTitle;
  final String preassureTitle;

  const Settings({
    required this.temperatureTitle,
    required this.speedTitle,
    required this.preassureTitle,
  });

  Settings copyWith({
    String Function()? temperatureTitle,
    String Function()? speedTitle,
    String Function()? preassureTitle,
  }) =>
      Settings(
        speedTitle: speedTitle != null ? speedTitle() : this.speedTitle,
        temperatureTitle: temperatureTitle != null
            ? temperatureTitle()
            : this.temperatureTitle,
        preassureTitle:
            preassureTitle != null ? preassureTitle() : this.preassureTitle,
      );

  @override
  List<Object?> get props => [
        temperatureTitle,
        speedTitle,
        preassureTitle,
      ];
}

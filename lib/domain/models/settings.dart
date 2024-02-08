enum TemperatureUnits { celsius, fahrenheit }

enum PreassureUnits { inHg, mbHg, mmHg }

enum WindSpeedUnits { kilometerPerHour, milePerHour }

class Settings {
  final TemperatureUnits temperatureUnit;
  final PreassureUnits preassureUnit;
  final WindSpeedUnits windSpeedUnit;

  Settings({
    required this.temperatureUnit,
    required this.preassureUnit,
    required this.windSpeedUnit,
  });
}

import 'dart:convert';

enum TemperatureUnits { celsius, fahrenheit }

extension TemperatureUnitsAsString on TemperatureUnits {
  String asString() {
    switch (this) {
      case TemperatureUnits.celsius:
        return 'celsius';
      case TemperatureUnits.fahrenheit:
        return 'fahrenheit';
    }
  }
}

enum PreassureUnits { inHg, mbHg, mmHg }

extension PreassureUnitsAsString on PreassureUnits {
  String asString() {
    switch (this) {
      case PreassureUnits.inHg:
        return 'inHg';
      case PreassureUnits.mbHg:
        return 'mbHg';
      case PreassureUnits.mmHg:
        return 'mmHg';
    }
  }
}

enum WindSpeedUnits { kilometerPerHour, milePerHour }

extension WindSpeedUnitsAsString on WindSpeedUnits {
  String asString() {
    switch (this) {
      case WindSpeedUnits.kilometerPerHour:
        return 'kilometerPerHour';
      case WindSpeedUnits.milePerHour:
        return 'milePerHour';
    }
  }
}

class Settings {
  final TemperatureUnits temperatureUnit;
  final PreassureUnits preassureUnit;
  final WindSpeedUnits windSpeedUnit;

  Settings({
    required this.temperatureUnit,
    required this.preassureUnit,
    required this.windSpeedUnit,
  });

  Map<String, dynamic> _toMap() {
    return <String, dynamic>{
      'temperature_unit': temperatureUnit,
      'preassure_unit': preassureUnit,
      'windSpeed_unit': windSpeedUnit,
    };
  }

  factory Settings._fromMap(Map<String, dynamic> map) {
    return Settings(
      temperatureUnit: map['temperature_unit'] as TemperatureUnits,
      preassureUnit: map['preassure_unit'] as PreassureUnits,
      windSpeedUnit: map['windSpeed_unit'] as WindSpeedUnits,
    );
  }

  String toJson() => json.encode(_toMap());

  factory Settings.fromJson(Map<String, dynamic> source) =>
      Settings._fromMap(source);
}

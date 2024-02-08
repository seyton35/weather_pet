import 'dart:math';

import 'package:weather_repository/weather_repository.dart';

class WeatherParser {
  Map<String, int> getMinMaxDayTemperatureInt({
    required List<Hour> hourList,
    inCelsius = true,
  }) {
    double maxTempDouble;
    double minTempDouble;

    if (inCelsius) {
      maxTempDouble = hourList[0].tempC;
      minTempDouble = hourList[0].tempC;
    } else {
      maxTempDouble = hourList[0].tempF;
      minTempDouble = hourList[0].tempF;
    }
    hourList.map((hour) {
      double temp;
      if (inCelsius) {
        temp = hour.tempC;
      } else {
        temp = hour.tempF;
      }
      maxTempDouble = max(maxTempDouble, temp);
      minTempDouble = min(minTempDouble, temp);
    }).toList();
    final maxTemp = maxTempDouble.round();
    final minTemp = minTempDouble.round();
    return {
      'max_temp': maxTemp,
      'min_temp': minTemp,
    };
  }
}

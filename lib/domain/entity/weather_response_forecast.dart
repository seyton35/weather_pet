import 'package:json_annotation/json_annotation.dart';
import 'package:weather_pet/domain/entity/weather_response_condition.dart';

part 'weather_response_forecast.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Forecast {
  final List<Forecastday> forecastday;
  Forecast({
    required this.forecastday,
  });
  factory Forecast.fromJson(Map<String, dynamic> json) =>
      _$ForecastFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Forecastday {
  final String date;
  final int dateEpoch;
  final Day day;
  final Astro astro;
  final List<Hour> hour;
  Forecastday({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hour,
  });
  factory Forecastday.fromJson(Map<String, dynamic> json) =>
      _$ForecastdayFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastdayToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Day {
  final double maxtempC;
  final double maxtempF;
  final double mintempC;
  final double mintempF;
  final double avgtempC;
  final double avgtempF;
  final double maxwindMph;
  final double maxwindKph;
  final double totalprecipMm;
  final double totalprecipIn;
  final double totalsnowCm;
  final double avgvisKm;
  final double avgvisMiles;
  final double avghumidity;
  final int dailyWillItRain;
  final int dailyChanceOfRain;
  final int dailyWillItSnow;
  final int dailyChanceOfSnow;
  final Condition condition;
  final double uv;
  Day({
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.avgtempC,
    required this.avgtempF,
    required this.maxwindMph,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.totalprecipIn,
    required this.totalsnowCm,
    required this.avgvisKm,
    required this.avgvisMiles,
    required this.avghumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
    required this.uv,
  });
  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
  Map<String, dynamic> toJson() => _$DayToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Astro {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moonPhase;
  final int moonIllumination;
  final int isMoonUp;
  final int isSunUp;
  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonIllumination,
    required this.isMoonUp,
    required this.isSunUp,
  });
  factory Astro.fromJson(Map<String, dynamic> json) => _$AstroFromJson(json);
  Map<String, dynamic> toJson() => _$AstroToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Hour {
  final int timeEpoch;
  final String time;
  final double tempC;
  final double tempF;
  final int isDay;
  final Condition condition;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double windchillC;
  final double windchillF;
  final double heatindexC;
  final double heatindexF;
  final double dewpointC;
  final double dewpointF;
  final int willItRain;
  final int chanceOfRain;
  final int willItSnow;
  final int chanceOfSnow;
  final double visKm;
  final double visMiles;
  final double gustMph;
  final double gustKph;
  final double uv;
  Hour({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.willItRain,
    required this.chanceOfRain,
    required this.willItSnow,
    required this.chanceOfSnow,
    required this.visKm,
    required this.visMiles,
    required this.gustMph,
    required this.gustKph,
    required this.uv,
  });
  factory Hour.fromJson(Map<String, dynamic> json) => _$HourFromJson(json);
  Map<String, dynamic> toJson() => _$HourToJson(this);
}

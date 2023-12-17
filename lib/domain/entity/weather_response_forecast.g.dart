// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_response_forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Forecast _$ForecastFromJson(Map<String, dynamic> json) => Forecast(
      forecastday: (json['forecastday'] as List<dynamic>)
          .map((e) => Forecastday.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ForecastToJson(Forecast instance) => <String, dynamic>{
      'forecastday': instance.forecastday.map((e) => e.toJson()).toList(),
    };

Forecastday _$ForecastdayFromJson(Map<String, dynamic> json) => Forecastday(
      date: json['date'] as String,
      dateEpoch: json['date_epoch'] as int,
      day: Day.fromJson(json['day'] as Map<String, dynamic>),
      astro: Astro.fromJson(json['astro'] as Map<String, dynamic>),
      hour: (json['hour'] as List<dynamic>)
          .map((e) => Hour.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ForecastdayToJson(Forecastday instance) =>
    <String, dynamic>{
      'date': instance.date,
      'date_epoch': instance.dateEpoch,
      'day': instance.day.toJson(),
      'astro': instance.astro.toJson(),
      'hour': instance.hour.map((e) => e.toJson()).toList(),
    };

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      maxtempC: (json['maxtemp_c'] as num).toDouble(),
      maxtempF: (json['maxtemp_f'] as num).toDouble(),
      mintempC: (json['mintemp_c'] as num).toDouble(),
      mintempF: (json['mintemp_f'] as num).toDouble(),
      avgtempC: (json['avgtemp_c'] as num).toDouble(),
      avgtempF: (json['avgtemp_f'] as num).toDouble(),
      maxwindMph: (json['maxwind_mph'] as num).toDouble(),
      maxwindKph: (json['maxwind_kph'] as num).toDouble(),
      totalprecipMm: (json['totalprecip_mm'] as num).toDouble(),
      totalprecipIn: (json['totalprecip_in'] as num).toDouble(),
      totalsnowCm: (json['totalsnow_cm'] as num).toDouble(),
      avgvisKm: (json['avgvis_km'] as num).toDouble(),
      avgvisMiles: (json['avgvis_miles'] as num).toDouble(),
      avghumidity: (json['avghumidity'] as num).toDouble(),
      dailyWillItRain: json['daily_will_it_rain'] as int,
      dailyChanceOfRain: json['daily_chance_of_rain'] as int,
      dailyWillItSnow: json['daily_will_it_snow'] as int,
      dailyChanceOfSnow: json['daily_chance_of_snow'] as int,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
      uv: (json['uv'] as num).toDouble(),
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'maxtemp_c': instance.maxtempC,
      'maxtemp_f': instance.maxtempF,
      'mintemp_c': instance.mintempC,
      'mintemp_f': instance.mintempF,
      'avgtemp_c': instance.avgtempC,
      'avgtemp_f': instance.avgtempF,
      'maxwind_mph': instance.maxwindMph,
      'maxwind_kph': instance.maxwindKph,
      'totalprecip_mm': instance.totalprecipMm,
      'totalprecip_in': instance.totalprecipIn,
      'totalsnow_cm': instance.totalsnowCm,
      'avgvis_km': instance.avgvisKm,
      'avgvis_miles': instance.avgvisMiles,
      'avghumidity': instance.avghumidity,
      'daily_will_it_rain': instance.dailyWillItRain,
      'daily_chance_of_rain': instance.dailyChanceOfRain,
      'daily_will_it_snow': instance.dailyWillItSnow,
      'daily_chance_of_snow': instance.dailyChanceOfSnow,
      'condition': instance.condition.toJson(),
      'uv': instance.uv,
    };

Astro _$AstroFromJson(Map<String, dynamic> json) => Astro(
      sunrise: json['sunrise'] as String,
      sunset: json['sunset'] as String,
      moonrise: json['moonrise'] as String,
      moonset: json['moonset'] as String,
      moonPhase: json['moon_phase'] as String,
      moonIllumination: json['moon_illumination'] as int,
      isMoonUp: json['is_moon_up'] as int,
      isSunUp: json['is_sun_up'] as int,
    );

Map<String, dynamic> _$AstroToJson(Astro instance) => <String, dynamic>{
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'moonrise': instance.moonrise,
      'moonset': instance.moonset,
      'moon_phase': instance.moonPhase,
      'moon_illumination': instance.moonIllumination,
      'is_moon_up': instance.isMoonUp,
      'is_sun_up': instance.isSunUp,
    };

Hour _$HourFromJson(Map<String, dynamic> json) => Hour(
      timeEpoch: json['time_epoch'] as int,
      time: json['time'] as String,
      tempC: (json['temp_c'] as num).toDouble(),
      tempF: (json['temp_f'] as num).toDouble(),
      isDay: json['is_day'] as int,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
      windMph: (json['wind_mph'] as num).toDouble(),
      windKph: (json['wind_kph'] as num).toDouble(),
      windDegree: json['wind_degree'] as int,
      windDir: json['wind_dir'] as String,
      pressureMb: (json['pressure_mb'] as num).toDouble(),
      pressureIn: (json['pressure_in'] as num).toDouble(),
      precipMm: (json['precip_mm'] as num).toDouble(),
      precipIn: (json['precip_in'] as num).toDouble(),
      humidity: json['humidity'] as int,
      cloud: json['cloud'] as int,
      feelslikeC: (json['feelslike_c'] as num).toDouble(),
      feelslikeF: (json['feelslike_f'] as num).toDouble(),
      windchillC: (json['windchill_c'] as num).toDouble(),
      windchillF: (json['windchill_f'] as num).toDouble(),
      heatindexC: (json['heatindex_c'] as num).toDouble(),
      heatindexF: (json['heatindex_f'] as num).toDouble(),
      dewpointC: (json['dewpoint_c'] as num).toDouble(),
      dewpointF: (json['dewpoint_f'] as num).toDouble(),
      willItRain: json['will_it_rain'] as int,
      chanceOfRain: json['chance_of_rain'] as int,
      willItSnow: json['will_it_snow'] as int,
      chanceOfSnow: json['chance_of_snow'] as int,
      visKm: (json['vis_km'] as num).toDouble(),
      visMiles: (json['vis_miles'] as num).toDouble(),
      gustMph: (json['gust_mph'] as num).toDouble(),
      gustKph: (json['gust_kph'] as num).toDouble(),
      uv: (json['uv'] as num).toDouble(),
    );

Map<String, dynamic> _$HourToJson(Hour instance) => <String, dynamic>{
      'time_epoch': instance.timeEpoch,
      'time': instance.time,
      'temp_c': instance.tempC,
      'temp_f': instance.tempF,
      'is_day': instance.isDay,
      'condition': instance.condition.toJson(),
      'wind_mph': instance.windMph,
      'wind_kph': instance.windKph,
      'wind_degree': instance.windDegree,
      'wind_dir': instance.windDir,
      'pressure_mb': instance.pressureMb,
      'pressure_in': instance.pressureIn,
      'precip_mm': instance.precipMm,
      'precip_in': instance.precipIn,
      'humidity': instance.humidity,
      'cloud': instance.cloud,
      'feelslike_c': instance.feelslikeC,
      'feelslike_f': instance.feelslikeF,
      'windchill_c': instance.windchillC,
      'windchill_f': instance.windchillF,
      'heatindex_c': instance.heatindexC,
      'heatindex_f': instance.heatindexF,
      'dewpoint_c': instance.dewpointC,
      'dewpoint_f': instance.dewpointF,
      'will_it_rain': instance.willItRain,
      'chance_of_rain': instance.chanceOfRain,
      'will_it_snow': instance.willItSnow,
      'chance_of_snow': instance.chanceOfSnow,
      'vis_km': instance.visKm,
      'vis_miles': instance.visMiles,
      'gust_mph': instance.gustMph,
      'gust_kph': instance.gustKph,
      'uv': instance.uv,
    };

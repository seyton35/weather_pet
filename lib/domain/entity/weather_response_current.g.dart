// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_response_current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherResponceCurrent _$WeatherResponceCurrentFromJson(
        Map<String, dynamic> json) =>
    WeatherResponceCurrent(
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      current: json['current'] == null
          ? null
          : Current.fromJson(json['current'] as Map<String, dynamic>),
      forecast: json['forecast'] == null
          ? null
          : Forecast.fromJson(json['forecast'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherResponceCurrentToJson(
        WeatherResponceCurrent instance) =>
    <String, dynamic>{
      'location': instance.location?.toJson(),
      'current': instance.current?.toJson(),
      'forecast': instance.forecast?.toJson(),
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      tzId: json['tz_id'] as String,
      localtime: json['localtime'] as String,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'region': instance.region,
      'country': instance.country,
      'tz_id': instance.tzId,
      'localtime': instance.localtime,
    };

Current _$CurrentFromJson(Map<String, dynamic> json) => Current(
      tempC: (json['temp_c'] as num).toDouble(),
      tempF: (json['temp_f'] as num).toDouble(),
      isDay: json['is_day'] as int,
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
      windMph: (json['wind_mph'] as num).toDouble(),
      windKph: (json['wind_kph'] as num).toDouble(),
      windDir: json['wind_dir'] as String,
      pressureMb: (json['pressure_mb'] as num).toDouble(),
      pressureIn: (json['pressure_in'] as num).toDouble(),
      precipMm: (json['precip_mm'] as num).toDouble(),
      precipIn: (json['precip_in'] as num).toDouble(),
      humidity: json['humidity'] as int,
      cloud: json['cloud'] as int,
      feelslikeC: (json['feelslike_c'] as num).toDouble(),
      feelslikeF: (json['feelslike_f'] as num).toDouble(),
      uv: (json['uv'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
      'temp_c': instance.tempC,
      'temp_f': instance.tempF,
      'is_day': instance.isDay,
      'condition': instance.condition.toJson(),
      'wind_mph': instance.windMph,
      'wind_kph': instance.windKph,
      'wind_dir': instance.windDir,
      'pressure_mb': instance.pressureMb,
      'pressure_in': instance.pressureIn,
      'precip_mm': instance.precipMm,
      'precip_in': instance.precipIn,
      'humidity': instance.humidity,
      'cloud': instance.cloud,
      'feelslike_c': instance.feelslikeC,
      'feelslike_f': instance.feelslikeF,
      'uv': instance.uv,
    };

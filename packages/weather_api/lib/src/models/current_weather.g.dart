// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'current_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CurrentWeather',
      json,
      ($checkedConvert) {
        final val = CurrentWeather(
          location: $checkedConvert(
              'location', (v) => Location.fromJson(v as Map<String, dynamic>)),
          current: $checkedConvert(
              'current', (v) => Current.fromJson(v as Map<String, dynamic>)),
          forecast: $checkedConvert(
              'forecast', (v) => Forecast.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$CurrentWeatherToJson(CurrentWeather instance) =>
    <String, dynamic>{
      'location': instance.location,
      'current': instance.current,
      'forecast': instance.forecast,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Location',
      json,
      ($checkedConvert) {
        final val = Location(
          name: $checkedConvert('name', (v) => v as String),
          region: $checkedConvert('region', (v) => v as String),
          country: $checkedConvert('country', (v) => v as String),
          lat: $checkedConvert('lat', (v) => (v as num).toDouble()),
          lon: $checkedConvert('lon', (v) => (v as num).toDouble()),
          tzId: $checkedConvert('tz_id', (v) => v as String),
          localtimeEpoch: $checkedConvert('localtime_epoch', (v) => v as int),
          localtime: $checkedConvert('localtime', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'tzId': 'tz_id', 'localtimeEpoch': 'localtime_epoch'},
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'region': instance.region,
      'country': instance.country,
      'lat': instance.lat,
      'lon': instance.lon,
      'tz_id': instance.tzId,
      'localtime_epoch': instance.localtimeEpoch,
      'localtime': instance.localtime,
    };

Current _$CurrentFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Current',
      json,
      ($checkedConvert) {
        final val = Current(
          lastUpdatedEpoch:
              $checkedConvert('last_updated_epoch', (v) => v as int),
          lastUpdated: $checkedConvert('last_updated', (v) => v as String),
          tempC: $checkedConvert('temp_c', (v) => (v as num).toDouble()),
          tempF: $checkedConvert('temp_f', (v) => (v as num).toDouble()),
          isDay: $checkedConvert('is_day', (v) => v as int),
          condition: $checkedConvert('condition',
              (v) => Condition.fromJson(v as Map<String, dynamic>)),
          windMph: $checkedConvert('wind_mph', (v) => (v as num).toDouble()),
          windKph: $checkedConvert('wind_kph', (v) => (v as num).toDouble()),
          windDegree: $checkedConvert('wind_degree', (v) => v as int),
          windDir: $checkedConvert('wind_dir', (v) => v as String),
          pressureMb:
              $checkedConvert('pressure_mb', (v) => (v as num).toDouble()),
          pressureIn:
              $checkedConvert('pressure_in', (v) => (v as num).toDouble()),
          precipMm: $checkedConvert('precip_mm', (v) => (v as num).toDouble()),
          precipIn: $checkedConvert('precip_in', (v) => (v as num).toDouble()),
          humidity: $checkedConvert('humidity', (v) => v as int),
          cloud: $checkedConvert('cloud', (v) => v as int),
          feelslikeC:
              $checkedConvert('feelslike_c', (v) => (v as num).toDouble()),
          feelslikeF:
              $checkedConvert('feelslike_f', (v) => (v as num).toDouble()),
          visKm: $checkedConvert('vis_km', (v) => (v as num).toDouble()),
          visMiles: $checkedConvert('vis_miles', (v) => (v as num).toDouble()),
          uv: $checkedConvert('uv', (v) => (v as num).toDouble()),
          gustMph: $checkedConvert('gust_mph', (v) => (v as num).toDouble()),
          gustKph: $checkedConvert('gust_kph', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'lastUpdatedEpoch': 'last_updated_epoch',
        'lastUpdated': 'last_updated',
        'tempC': 'temp_c',
        'tempF': 'temp_f',
        'isDay': 'is_day',
        'windMph': 'wind_mph',
        'windKph': 'wind_kph',
        'windDegree': 'wind_degree',
        'windDir': 'wind_dir',
        'pressureMb': 'pressure_mb',
        'pressureIn': 'pressure_in',
        'precipMm': 'precip_mm',
        'precipIn': 'precip_in',
        'feelslikeC': 'feelslike_c',
        'feelslikeF': 'feelslike_f',
        'visKm': 'vis_km',
        'visMiles': 'vis_miles',
        'gustMph': 'gust_mph',
        'gustKph': 'gust_kph'
      },
    );

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
      'last_updated_epoch': instance.lastUpdatedEpoch,
      'last_updated': instance.lastUpdated,
      'temp_c': instance.tempC,
      'temp_f': instance.tempF,
      'is_day': instance.isDay,
      'condition': instance.condition,
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
      'vis_km': instance.visKm,
      'vis_miles': instance.visMiles,
      'uv': instance.uv,
      'gust_mph': instance.gustMph,
      'gust_kph': instance.gustKph,
    };

Forecast _$ForecastFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Forecast',
      json,
      ($checkedConvert) {
        final val = Forecast(
          forecastday: $checkedConvert(
              'forecastday',
              (v) => (v as List<dynamic>)
                  .map((e) => Forecastday.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ForecastToJson(Forecast instance) => <String, dynamic>{
      'forecastday': instance.forecastday,
    };

Forecastday _$ForecastdayFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Forecastday',
      json,
      ($checkedConvert) {
        final val = Forecastday(
          date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
          dateEpoch: $checkedConvert('date_epoch', (v) => v as int),
          day: $checkedConvert(
              'day', (v) => Day.fromJson(v as Map<String, dynamic>)),
          astro: $checkedConvert(
              'astro', (v) => Astro.fromJson(v as Map<String, dynamic>)),
          hour: $checkedConvert(
              'hour',
              (v) => (v as List<dynamic>)
                  .map((e) => Hour.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'dateEpoch': 'date_epoch'},
    );

Map<String, dynamic> _$ForecastdayToJson(Forecastday instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'date_epoch': instance.dateEpoch,
      'day': instance.day,
      'astro': instance.astro,
      'hour': instance.hour,
    };

Day _$DayFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Day',
      json,
      ($checkedConvert) {
        final val = Day(
          maxtempC: $checkedConvert('maxtemp_c', (v) => (v as num).toDouble()),
          maxtempF: $checkedConvert('maxtemp_f', (v) => (v as num).toDouble()),
          mintempC: $checkedConvert('mintemp_c', (v) => (v as num).toDouble()),
          mintempF: $checkedConvert('mintemp_f', (v) => (v as num).toDouble()),
          avgtempC: $checkedConvert('avgtemp_c', (v) => (v as num).toDouble()),
          avgtempF: $checkedConvert('avgtemp_f', (v) => (v as num).toDouble()),
          maxwindMph:
              $checkedConvert('maxwind_mph', (v) => (v as num).toDouble()),
          maxwindKph:
              $checkedConvert('maxwind_kph', (v) => (v as num).toDouble()),
          totalprecipMm:
              $checkedConvert('totalprecip_mm', (v) => (v as num).toDouble()),
          totalprecipIn:
              $checkedConvert('totalprecip_in', (v) => (v as num).toDouble()),
          totalsnowCm:
              $checkedConvert('totalsnow_cm', (v) => (v as num).toDouble()),
          avgvisKm: $checkedConvert('avgvis_km', (v) => (v as num).toDouble()),
          avgvisMiles:
              $checkedConvert('avgvis_miles', (v) => (v as num).toDouble()),
          avghumidity:
              $checkedConvert('avghumidity', (v) => (v as num).toDouble()),
          dailyWillItRain:
              $checkedConvert('daily_will_it_rain', (v) => v as int),
          dailyChanceOfRain:
              $checkedConvert('daily_chance_of_rain', (v) => v as int),
          dailyWillItSnow:
              $checkedConvert('daily_will_it_snow', (v) => v as int),
          dailyChanceOfSnow:
              $checkedConvert('daily_chance_of_snow', (v) => v as int),
          condition: $checkedConvert('condition',
              (v) => Condition.fromJson(v as Map<String, dynamic>)),
          uv: $checkedConvert('uv', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'maxtempC': 'maxtemp_c',
        'maxtempF': 'maxtemp_f',
        'mintempC': 'mintemp_c',
        'mintempF': 'mintemp_f',
        'avgtempC': 'avgtemp_c',
        'avgtempF': 'avgtemp_f',
        'maxwindMph': 'maxwind_mph',
        'maxwindKph': 'maxwind_kph',
        'totalprecipMm': 'totalprecip_mm',
        'totalprecipIn': 'totalprecip_in',
        'totalsnowCm': 'totalsnow_cm',
        'avgvisKm': 'avgvis_km',
        'avgvisMiles': 'avgvis_miles',
        'dailyWillItRain': 'daily_will_it_rain',
        'dailyChanceOfRain': 'daily_chance_of_rain',
        'dailyWillItSnow': 'daily_will_it_snow',
        'dailyChanceOfSnow': 'daily_chance_of_snow'
      },
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
      'condition': instance.condition,
      'uv': instance.uv,
    };

Astro _$AstroFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Astro',
      json,
      ($checkedConvert) {
        final val = Astro(
          sunrise: $checkedConvert('sunrise', (v) => v as String),
          sunset: $checkedConvert('sunset', (v) => v as String),
          moonrise: $checkedConvert('moonrise', (v) => v as String),
          moonset: $checkedConvert('moonset', (v) => v as String),
          moonPhase: $checkedConvert('moon_phase', (v) => v as String),
          moonIllumination:
              $checkedConvert('moon_illumination', (v) => v as int),
          isMoonUp: $checkedConvert('is_moon_up', (v) => v as int),
          isSunUp: $checkedConvert('is_sun_up', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'moonPhase': 'moon_phase',
        'moonIllumination': 'moon_illumination',
        'isMoonUp': 'is_moon_up',
        'isSunUp': 'is_sun_up'
      },
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

Hour _$HourFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Hour',
      json,
      ($checkedConvert) {
        final val = Hour(
          timeEpoch: $checkedConvert('time_epoch', (v) => v as int),
          time: $checkedConvert('time', (v) => v as String),
          tempC: $checkedConvert('temp_c', (v) => (v as num).toDouble()),
          tempF: $checkedConvert('temp_f', (v) => (v as num).toDouble()),
          isDay: $checkedConvert('is_day', (v) => v as int),
          condition: $checkedConvert('condition',
              (v) => Condition.fromJson(v as Map<String, dynamic>)),
          windMph: $checkedConvert('wind_mph', (v) => (v as num).toDouble()),
          windKph: $checkedConvert('wind_kph', (v) => (v as num).toDouble()),
          windDegree: $checkedConvert('wind_degree', (v) => v as int),
          windDir: $checkedConvert('wind_dir', (v) => v as String),
          pressureMb:
              $checkedConvert('pressure_mb', (v) => (v as num).toDouble()),
          pressureIn:
              $checkedConvert('pressure_in', (v) => (v as num).toDouble()),
          precipMm: $checkedConvert('precip_mm', (v) => (v as num).toDouble()),
          precipIn: $checkedConvert('precip_in', (v) => (v as num).toDouble()),
          humidity: $checkedConvert('humidity', (v) => v as int),
          cloud: $checkedConvert('cloud', (v) => v as int),
          feelslikeC:
              $checkedConvert('feelslike_c', (v) => (v as num).toDouble()),
          feelslikeF:
              $checkedConvert('feelslike_f', (v) => (v as num).toDouble()),
          windchillC:
              $checkedConvert('windchill_c', (v) => (v as num).toDouble()),
          windchillF:
              $checkedConvert('windchill_f', (v) => (v as num).toDouble()),
          heatindexC:
              $checkedConvert('heatindex_c', (v) => (v as num).toDouble()),
          heatindexF:
              $checkedConvert('heatindex_f', (v) => (v as num).toDouble()),
          dewpointC:
              $checkedConvert('dewpoint_c', (v) => (v as num).toDouble()),
          dewpointF:
              $checkedConvert('dewpoint_f', (v) => (v as num).toDouble()),
          willItRain: $checkedConvert('will_it_rain', (v) => v as int),
          chanceOfRain: $checkedConvert('chance_of_rain', (v) => v as int),
          willItSnow: $checkedConvert('will_it_snow', (v) => v as int),
          chanceOfSnow: $checkedConvert('chance_of_snow', (v) => v as int),
          visKm: $checkedConvert('vis_km', (v) => (v as num).toDouble()),
          visMiles: $checkedConvert('vis_miles', (v) => (v as num).toDouble()),
          gustMph: $checkedConvert('gust_mph', (v) => (v as num).toDouble()),
          gustKph: $checkedConvert('gust_kph', (v) => (v as num).toDouble()),
          uv: $checkedConvert('uv', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'timeEpoch': 'time_epoch',
        'tempC': 'temp_c',
        'tempF': 'temp_f',
        'isDay': 'is_day',
        'windMph': 'wind_mph',
        'windKph': 'wind_kph',
        'windDegree': 'wind_degree',
        'windDir': 'wind_dir',
        'pressureMb': 'pressure_mb',
        'pressureIn': 'pressure_in',
        'precipMm': 'precip_mm',
        'precipIn': 'precip_in',
        'feelslikeC': 'feelslike_c',
        'feelslikeF': 'feelslike_f',
        'windchillC': 'windchill_c',
        'windchillF': 'windchill_f',
        'heatindexC': 'heatindex_c',
        'heatindexF': 'heatindex_f',
        'dewpointC': 'dewpoint_c',
        'dewpointF': 'dewpoint_f',
        'willItRain': 'will_it_rain',
        'chanceOfRain': 'chance_of_rain',
        'willItSnow': 'will_it_snow',
        'chanceOfSnow': 'chance_of_snow',
        'visKm': 'vis_km',
        'visMiles': 'vis_miles',
        'gustMph': 'gust_mph',
        'gustKph': 'gust_kph'
      },
    );

Map<String, dynamic> _$HourToJson(Hour instance) => <String, dynamic>{
      'time_epoch': instance.timeEpoch,
      'time': instance.time,
      'temp_c': instance.tempC,
      'temp_f': instance.tempF,
      'is_day': instance.isDay,
      'condition': instance.condition,
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

Condition _$ConditionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Condition',
      json,
      ($checkedConvert) {
        final val = Condition(
          text: $checkedConvert('text', (v) => v as String),
          icon: $checkedConvert('icon', (v) => v as String),
          code: $checkedConvert('code', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$ConditionToJson(Condition instance) => <String, dynamic>{
      'text': instance.text,
      'icon': instance.icon,
      'code': instance.code,
    };

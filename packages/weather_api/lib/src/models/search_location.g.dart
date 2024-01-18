// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'search_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchLocation _$SearchLocationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SearchLocation',
      json,
      ($checkedConvert) {
        final val = SearchLocation(
          id: $checkedConvert('id', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
          region: $checkedConvert('region', (v) => v as String),
          country: $checkedConvert('country', (v) => v as String),
          lat: $checkedConvert('lat', (v) => (v as num).toDouble()),
          lon: $checkedConvert('lon', (v) => (v as num).toDouble()),
          url: $checkedConvert('url', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$SearchLocationToJson(SearchLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'region': instance.region,
      'country': instance.country,
      'lat': instance.lat,
      'lon': instance.lon,
      'url': instance.url,
    };

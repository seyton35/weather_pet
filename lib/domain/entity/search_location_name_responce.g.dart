// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_location_name_responce.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Searchlocationnameresponce _$SearchlocationnameresponceFromJson(
        Map<String, dynamic> json) =>
    Searchlocationnameresponce(
      id: json['id'] as int,
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$SearchlocationnameresponceToJson(
        Searchlocationnameresponce instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'region': instance.region,
      'country': instance.country,
      'lat': instance.lat,
      'lon': instance.lon,
      'url': instance.url,
    };

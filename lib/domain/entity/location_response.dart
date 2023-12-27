import 'package:json_annotation/json_annotation.dart';

part 'location_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LocationResponse {
  final int id;
  final String name;
  // final String region;
  final String country;
  // final double lat;
  // final double lon;
  // final String url;
  LocationResponse({
    required this.id,
    required this.name,
    // required this.region,
    required this.country,
    // required this.lat,
    // required this.lon,
    // required this.url,
  });
  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LocationResponseToJson(this);

  LocationResponse copyWith({
    int? id,
    String? name,
    // String? region,
    String? country,
    // double? lat,
    // double? lon,
    // String? url,
  }) {
    return LocationResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      // region: region ?? this.region,
      country: country ?? this.country,
      // lat: lat ?? this.lat,
      // lon: lon ?? this.lon,
      // url: url ?? this.url,
    );
  }
}

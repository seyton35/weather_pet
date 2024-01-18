import 'package:json_annotation/json_annotation.dart';

part 'search_location.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchLocation {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;
  SearchLocation({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });
  factory SearchLocation.fromJson(Map<String, dynamic> json) =>
      _$SearchLocationFromJson(json);
  Map<String, dynamic> toJson() => _$SearchLocationToJson(this);

  SearchLocation copyWith({
    int? id,
    String? name,
    String? region,
    String? country,
    double? lat,
    double? lon,
    String? url,
  }) {
    return SearchLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      url: url ?? this.url,
    );
  }
}

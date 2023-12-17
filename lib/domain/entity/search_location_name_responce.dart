import 'package:json_annotation/json_annotation.dart';
part 'search_location_name_responce.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Searchlocationnameresponce {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;
  Searchlocationnameresponce({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });
  factory Searchlocationnameresponce.fromJson(Map<String, dynamic> json) =>
      _$SearchlocationnameresponceFromJson(json);
  Map<String, dynamic> toJson() => _$SearchlocationnameresponceToJson(this);
}

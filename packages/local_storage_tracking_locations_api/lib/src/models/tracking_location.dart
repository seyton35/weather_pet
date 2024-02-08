import 'dart:convert';

class TrackingLocation {
  final String id;
  final String title;
  final double lat;
  final double lon;

  TrackingLocation({
    required this.id,
    required this.title,
    required this.lat,
    required this.lon,
  });

  Map<String, dynamic> _toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'lon': lon,
      'lat': lat,
    };
  }

  factory TrackingLocation._fromMap(Map<String, dynamic> map) {
    return TrackingLocation(
      id: map['id'] as String,
      title: map['title'] as String,
      lat: map['lat'] as double,
      lon: map['lon'] as double,
    );
  }

  String toJson() => json.encode(_toMap());

  factory TrackingLocation.fromJson(Map<String, dynamic> source) =>
      TrackingLocation._fromMap(source);
}

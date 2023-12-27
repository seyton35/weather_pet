// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TrackingLocation {
  final String id;
  final String title;

  TrackingLocation({required this.id, required this.title});

  Map<String, dynamic> _toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory TrackingLocation._fromMap(Map<String, dynamic> map) {
    return TrackingLocation(
      id: map['id'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(_toMap());

  factory TrackingLocation.fromJson(String source) =>
      TrackingLocation._fromMap(json.decode(source) as Map<String, dynamic>);
}

class TrackLocationDataProvider {
  final Future<SharedPreferences> _sP = SharedPreferences.getInstance();

  List<TrackingLocation> locationTrackList = [];

  Future<void> _storeLocationTrackList() async {
    final list =
        locationTrackList.map((location) => location.toJson()).toList();
    (await _sP).setStringList('track_list', list);
  }

  Future<List<TrackingLocation>> loadTrackList() async {
    final list = (await _sP).getStringList('track_list') ?? [];
    return locationTrackList =
        list.map((string) => TrackingLocation.fromJson(string)).toList();
  }

  Future<void> addLocation(TrackingLocation location) async {
    locationTrackList.add(location);
    _storeLocationTrackList();
  }

  Future<void> deleteLocation(String id) async {
    locationTrackList.removeWhere((location) => location.id == id);
    _storeLocationTrackList();
  }
}

import 'dart:convert';

import 'package:local_storage_tracking_locations_api/local_storage_tracking_locations_api.dart';
import 'package:rxdart/subjects.dart';

class TrackLocationDataProvider {
  TrackLocationDataProvider({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  static const kTrackingLocationsCollectionKey =
      '__tracking_locations_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  final _trackingLocationStreamController =
      BehaviorSubject<List<TrackingLocation>>.seeded(const []);

  Stream<List<TrackingLocation>> getLocations() =>
      _trackingLocationStreamController.asBroadcastStream();

  void _init() {
    final trackLocationsJson = _getValue(kTrackingLocationsCollectionKey);
    if (trackLocationsJson != null) {
      final trackLocationsListJson = json.decode(trackLocationsJson) as List;
      final trackLocations = trackLocationsListJson
          .map(
            (locationJson) => TrackingLocation.fromJson(
              jsonDecode(locationJson),
            ),
          )
          .toList();
      _trackingLocationStreamController.add([...trackLocations]);
    } else {
      _trackingLocationStreamController.add(const []);
    }
  }

  Future<void> saveLocation(TrackingLocation location) {
    final locations = [..._trackingLocationStreamController.value];
    final isLocationIndex = locations.indexWhere((l) => l.id == location.id);
    if (isLocationIndex == -1) {
      locations.add(location);
      _trackingLocationStreamController.add(locations);
      return _setValue(kTrackingLocationsCollectionKey, json.encode(locations));
    } else {
      throw Exception();
    }
  }

  Future<void> deleteLocation(String id) async {
    final lcoations = [..._trackingLocationStreamController.value];
    final locationIndex = lcoations.indexWhere((l) => l.id == id);
    if (locationIndex == -1) {
      throw TrackingLocationFoundException();
    } else {
      lcoations.removeAt(locationIndex);
      _trackingLocationStreamController.add(lcoations);
      return _setValue(kTrackingLocationsCollectionKey, json.encode(lcoations));
    }
  }
}

class TrackingLocationFoundException implements Exception {}

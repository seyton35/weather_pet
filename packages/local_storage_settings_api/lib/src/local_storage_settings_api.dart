import 'dart:convert';

import 'package:local_storage_settings_api/local_storage_settings_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSettingsDataProvider {
  final SharedPreferences _plugin;
  ApplicationSettingsDataProvider({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }
  static const kApplicationSettingsCollectionKey =
      '__application_settings_key__';

  void _init() {
    final settingsJson = _plugin.getString(kApplicationSettingsCollectionKey);
    if (settingsJson != null) {
      //   final settingsListJson = json.decode(settingsJson) as Settings;
      //   final trackLocations = settingsListJson
      //       .map(
      //         (locationJson) => TrackingLocation.fromJson(
      //           jsonDecode(locationJson),
      //         ),
      //       )
      //       .toList();
      //   _trackingLocationStreamController.add([...trackLocations]);
      // } else {
      //   _trackingLocationStreamController.add(const []);
    }
  }
}

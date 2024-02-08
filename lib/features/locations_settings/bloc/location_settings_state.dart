part of 'location_settings_bloc.dart';

enum LocationSettingsStatus { initial, success, editing, error }

final class LocationSettingsState extends Equatable {
  final LocationSettingsStatus status;
  final List<Location> locationsList;
  final String errorTitle;
  final int checkedItemsCount;

  const LocationSettingsState({
    this.status = LocationSettingsStatus.initial,
    this.locationsList = const [],
    this.errorTitle = '',
    this.checkedItemsCount = 0,
  });

  LocationSettingsState copyWith({
    LocationSettingsStatus Function()? status,
    List<Location> Function()? locationsList,
    String Function()? errorTitle,
    int Function()? checkedItemsCount,
  }) {
    return LocationSettingsState(
      status: status != null ? status() : this.status,
      locationsList:
          locationsList != null ? locationsList() : this.locationsList,
      errorTitle: errorTitle != null ? errorTitle() : this.errorTitle,
      checkedItemsCount: checkedItemsCount != null
          ? checkedItemsCount()
          : this.checkedItemsCount,
    );
  }

  @override
  List<Object> get props => [
        status,
        locationsList,
        errorTitle,
        checkedItemsCount,
      ];
}

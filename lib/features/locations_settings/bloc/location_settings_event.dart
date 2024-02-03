part of 'location_settings_bloc.dart';

sealed class LocationSettingsEvent extends Equatable {
  const LocationSettingsEvent();

  @override
  List<Object> get props => [];
}

final class LocationSettingsEventSubscription extends LocationSettingsEvent {
  const LocationSettingsEventSubscription();
}

final class LocationSettingsEventEditing extends LocationSettingsEvent {
  final bool editing;
  const LocationSettingsEventEditing({required this.editing});
}

final class LocationSettingsEventCheckAll extends LocationSettingsEvent {
  const LocationSettingsEventCheckAll();
}

final class LocationSettingsEventSearchButtonTap extends LocationSettingsEvent {
  const LocationSettingsEventSearchButtonTap();
}

final class LocationSettingsEventDeleteButtonTap extends LocationSettingsEvent {
  const LocationSettingsEventDeleteButtonTap();
}

final class LocationSettingsEventToggleCheck extends LocationSettingsEvent {
  final int index;
  const LocationSettingsEventToggleCheck({required this.index});
}

final class LocationSettingsEventDragging extends LocationSettingsEvent {
  final int newIndex;
  final int oldIndex;

  const LocationSettingsEventDragging({
    required this.newIndex,
    required this.oldIndex,
  });
}

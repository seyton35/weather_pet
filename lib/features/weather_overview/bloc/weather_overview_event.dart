part of 'weather_overview_bloc.dart';

sealed class WeatherOverviewEvent extends Equatable {
  const WeatherOverviewEvent();

  @override
  List<Object> get props => [];
}

final class WeatherOverviewEventSubscription extends WeatherOverviewEvent {
  const WeatherOverviewEventSubscription();
}

final class WeatherOverviewEventTitleChange extends WeatherOverviewEvent {
  final int index;
  const WeatherOverviewEventTitleChange({
    required this.index,
  });
}

final class WeatherOverviewEventAddLocationButtonTap
    extends WeatherOverviewEvent {
  const WeatherOverviewEventAddLocationButtonTap();
}

final class WeatherOverviewEventSettingsButtonTap extends WeatherOverviewEvent {
  const WeatherOverviewEventSettingsButtonTap();
}

final class WeatherOverviewEventWeeklyWeatherButtonTap
    extends WeatherOverviewEvent {
  final String locationId;
  final String locationTitle;

  const WeatherOverviewEventWeeklyWeatherButtonTap({
    required this.locationId,
    required this.locationTitle,
  });
}

part of 'weather_overview_bloc.dart';

enum WeatherOverviewStatus { initial, loading, success, error }

final class WeatherOverviewState extends Equatable {
  final WeatherOverviewStatus status;
  final String errorTitle;
  final List<Weather> weatherList;
  final String locationTitle;
  final String locationId;

  const WeatherOverviewState({
    this.status = WeatherOverviewStatus.initial,
    this.errorTitle = '',
    this.weatherList = const [],
    this.locationTitle = '',
    this.locationId = '',
  });

  WeatherOverviewState copyWith({
    WeatherOverviewStatus Function()? status,
    String Function()? errorTitle,
    List<Weather> Function()? weatherList,
    String Function()? locationTitle,
    String Function()? locationId,
  }) {
    return WeatherOverviewState(
      status: status != null ? status() : this.status,
      errorTitle: errorTitle != null ? errorTitle() : this.errorTitle,
      weatherList: weatherList != null ? weatherList() : this.weatherList,
      locationTitle:
          locationTitle != null ? locationTitle() : this.locationTitle,
      locationId: locationId != null ? locationId() : this.locationId,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorTitle,
        weatherList,
        locationTitle,
        locationId,
      ];
}

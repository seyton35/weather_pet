part of 'weekly_weather_bloc.dart';

enum WeeklyWeatherStatus { initial, success, loading, error }

final class WeeklyWeatherState extends Equatable {
  final WeeklyWeatherStatus status;
  final List<DaylyWeather> locationDaylyWeatherList;
  final String locationTitle;
  final String errorTitle;
  const WeeklyWeatherState({
    this.status = WeeklyWeatherStatus.initial,
    this.locationDaylyWeatherList = const [],
    required this.locationTitle,
    this.errorTitle = '',
  });

  WeeklyWeatherState copyWith({
    WeeklyWeatherStatus Function()? status,
    List<DaylyWeather> Function()? locationDaylyWeatherList,
    String Function()? locationTitle,
    String Function()? errorTitle,
  }) {
    return WeeklyWeatherState(
      status: status != null ? status() : this.status,
      locationDaylyWeatherList: locationDaylyWeatherList != null
          ? locationDaylyWeatherList()
          : this.locationDaylyWeatherList,
      locationTitle:
          locationTitle != null ? locationTitle() : this.locationTitle,
      errorTitle: errorTitle != null ? errorTitle() : this.errorTitle,
    );
  }

  @override
  List<Object> get props => [
        status,
        locationTitle,
        errorTitle,
      ];
}

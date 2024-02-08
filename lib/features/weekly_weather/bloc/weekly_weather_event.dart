part of 'weekly_weather_bloc.dart';

sealed class WeeklyWeatherEvent extends Equatable {
  const WeeklyWeatherEvent();

  @override
  List<Object> get props => [];
}

class WeeklyWeatherEventLoading extends WeeklyWeatherEvent {
  const WeeklyWeatherEventLoading();
}

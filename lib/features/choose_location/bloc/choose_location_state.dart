part of 'choose_location_bloc.dart';

enum ChooseLocationBlocStatus { initial, loading, success, error }

final class ChooseLocationState extends Equatable {
  final ChooseLocationBlocStatus status;
  final List<Location> locationsList;
  final List<Day> locationDaylyWeatherList;
  final String searchQuery;
  final String errorTitle;

  const ChooseLocationState({
    this.status = ChooseLocationBlocStatus.initial,
    this.locationsList = const [],
    this.locationDaylyWeatherList = const [],
    this.searchQuery = '',
    this.errorTitle = '',
  });

  ChooseLocationState copyWith({
    ChooseLocationBlocStatus Function()? status,
    List<Location> Function()? locationsList,
    List<Day> Function()? locationDaylyWeatherList,
    String Function()? searchQuery,
    String Function()? errorTitle,
  }) {
    return ChooseLocationState(
      status: status != null ? status() : this.status,
      locationsList:
          locationsList != null ? locationsList() : this.locationsList,
      locationDaylyWeatherList: locationDaylyWeatherList != null
          ? locationDaylyWeatherList()
          : this.locationDaylyWeatherList,
      searchQuery: searchQuery != null ? searchQuery() : this.searchQuery,
      errorTitle: errorTitle != null ? errorTitle() : this.errorTitle,
    );
  }

  @override
  List<Object> get props => [
        status,
        locationsList,
        locationDaylyWeatherList,
        searchQuery,
        errorTitle,
      ];
}

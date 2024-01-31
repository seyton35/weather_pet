import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:weather_pet/features/weekly_weather/weekly_weather.dart';
import 'package:weather_pet/domain/parsers/date_parser.dart';
import 'package:weather_pet/domain/parsers/wind_dirrection.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weekly_weather_event.dart';
part 'weekly_weather_state.dart';

class WeeklyWeatherBloc extends Bloc<WeeklyWeatherEvent, WeeklyWeatherState> {
  final WeatherRepository _weatherRepository;
  final String locationId;
  final String? lat;
  final String? lon;
  final _dateFormat = DateFormat();
  final _dateParser = DateParser();

  WeeklyWeatherBloc({
    required WeatherRepository weatherRepository,
    required String locationTitle,
    this.lon,
    this.lat,
    required this.locationId,
  })  : _weatherRepository = weatherRepository,
        super(WeeklyWeatherState(locationTitle: locationTitle)) {
    on<WeeklyWeatherEventLoading>(_onWeeklyWeatherEventLoading);
  }

  Future<void> _onWeeklyWeatherEventLoading(
    WeeklyWeatherEventLoading event,
    Emitter<WeeklyWeatherState> emit,
  ) async {
    emit(state.copyWith(
      status: () => WeeklyWeatherStatus.loading,
    ));
    final List<DaylyWeather> daylyWeatherList = [];
    final weatherLocationsList =
        await _weatherRepository.currentWeatherList.first;
    final locationIndex =
        weatherLocationsList.indexWhere((element) => element.id == locationId);
    if (locationIndex >= 0) {
      final currentWeather = weatherLocationsList[locationIndex];
      daylyWeatherList
          .addAll(_daylyWeatherListParser(currentWeather.forecast.forecastday));
    } else {
      try {
        final res = await _weatherRepository.getWeatherByDays(
            location: '$lat,$lon', days: 7);
        daylyWeatherList.addAll(_daylyWeatherListParser(res));
      } on ApiClientExeption catch (e) {
        switch (e.type) {
          case ApiClientExeptionType.network:
            emit(state.copyWith(
              status: () => WeeklyWeatherStatus.error,
              errorTitle: () => 'Проверьте интернет-соединение',
            ));
            break;
          default:
            throw Error();
        }
      } catch (e) {
        emit(state.copyWith(
          status: () => WeeklyWeatherStatus.error,
          errorTitle: () => 'Неизвестная ошибка',
        ));
      }
    }
    emit(state.copyWith(
      status: () => WeeklyWeatherStatus.success,
      locationDaylyWeatherList: () => daylyWeatherList,
    ));
  }

  List<DaylyWeather> _daylyWeatherListParser(List<Forecastday> forecastList) {
    List<DaylyWeather> daysList = [];

    forecastList.map((forecastday) {
      final dayRaw = forecastday.day;
      final dayOfWeek = _dateParser.dayOfWeekRu(
        date: forecastday.date,
        upperCaseFirst: true,
      );
      final date = _dateFormat.format(forecastday.date);
      final maxnTemp = dayRaw.maxtempC.round().toString();
      final minTemp = dayRaw.mintempC.round().toString();

      final hours = forecastday.hour;
      final dayIconPath = dayRaw.condition.icon
          .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/');
      final nightIconPath = hours[3]
          .condition
          .icon
          .replaceFirst('//cdn.weatherapi.com/', 'lib/domain/resources/');
      final windDegree = WindDirrectionParser.rountWindDirrection(
        windDegree: hours[15].windDegree.toDouble(),
      );
      final windSpeed = dayRaw.maxwindKph.toString();

      final day = DaylyWeather(
          dayOfWeek: dayOfWeek,
          date: date,
          dayIconPath: dayIconPath,
          nightIconPath: nightIconPath,
          maxTempTitle: maxnTemp,
          minTempTitle: minTemp,
          windDegree: windDegree,
          windSpeedTitle: windSpeed);
      daysList.add(day);
    }).toList();
    return daysList;
  }
}

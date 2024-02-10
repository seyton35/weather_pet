import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_storage_settings_api/local_storage_settings_api.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsEventLoading>(_onLoading);
    on<SettingsEventChangeUnit>(_onChangeUnit);
  }
  void _onLoading(
    SettingsEventLoading event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      status: () => SettingsStatus.loading,
    ));
    final tempTitles = <String, dynamic>{};
    final presTitles = <String, dynamic>{};
    final windTitles = <String, dynamic>{};
    for (var element in TemperatureUnits.values) {
      tempTitles[element.asString()] = element;
    }
    for (var element in PreassureUnits.values) {
      presTitles[element.asString()] = element;
    }
    for (var element in WindSpeedUnits.values) {
      windTitles[element.asString()] = element;
    }

    emit(state.copyWith(
      status: () => SettingsStatus.success,
      temperatureTitles: () => tempTitles,
      preassureTitles: () => presTitles,
      windSpeedTitles: () => windTitles,
    ));
  }

  void _onChangeUnit(
    SettingsEventChangeUnit event,
    Emitter<SettingsState> emit,
  ) {
    if (event.newUnit is TemperatureUnits) {
      final unit = event.newUnit as TemperatureUnits;
      emit(state.copyWith(
        temperatureTitle: () => unit.asString(),
      ));
    } else if (event.newUnit is PreassureUnits) {
      final unit = event.newUnit as PreassureUnits;
      emit(state.copyWith(
        preassureTitle: () => unit.asString(),
      ));
    } else if (event.newUnit is WindSpeedUnits) {
      final unit = event.newUnit as WindSpeedUnits;
      emit(state.copyWith(
        speedTitle: () => unit.asString(),
      ));
    }
  }
}

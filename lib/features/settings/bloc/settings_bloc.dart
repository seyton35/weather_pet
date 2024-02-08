import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_pet/domain/models/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsEventLoading>(_onLoading);
    on<SettingsEventChangeTemperatureUnit>(_onChangeTemperatureUnit);
    on<SettingsEventChangePreassureUnit>(_onChangePreassureUnit);
    on<SettingsEventChangeSpeedUnit>(_onChangeSpeedUnit);
  }
  void _onLoading(
    SettingsEventLoading event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      status: () => SettingsStatus.loading,
    ));
    emit(state.copyWith(
      status: () => SettingsStatus.success,
    ));
  }

  void _onChangeTemperatureUnit(
    SettingsEventChangeTemperatureUnit event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      temperatureTitle: () => '${event.temperatureUnit}',
    ));
  }

  void _onChangePreassureUnit(
    SettingsEventChangePreassureUnit event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      preassureTitle: () => '${event.preassureUnit}',
    ));
  }

  void _onChangeSpeedUnit(
    SettingsEventChangeSpeedUnit event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      speedTitle: () => '${event.speedUnit}',
    ));
  }
}

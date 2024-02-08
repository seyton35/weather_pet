import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_pet/domain/models/settings.dart';
import 'package:weather_pet/features/settings/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Widget create() {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc()..add(const SettingsEventLoading()),
      child: const SettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case SettingsStatus.initial:
              return const SizedBox.shrink();
            case SettingsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case SettingsStatus.success:
              return const _BodyWidget();
            case SettingsStatus.error:
            default:
              return Center(child: Text(state.errorTitle));
          }
        },
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        UnitsSettings(),
      ],
    );
  }
}

class UnitsSettings extends StatelessWidget {
  const UnitsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const Text('Еденицы измерения'),
          InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (context) => const _DialogWidget(),
            ),
            child: Row(
              children: [
                const Text('Температура'),
                const Spacer(),
                BlocBuilder<SettingsBloc, SettingsState>(
                  buildWhen: (previous, current) =>
                      previous.temperatureTitle != current.temperatureTitle,
                  builder: (context, state) {
                    return Text(state.temperatureTitle);
                  },
                ),
                const _SwapIcon(),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Text('Скорость ветра'),
                const Spacer(),
                BlocBuilder<SettingsBloc, SettingsState>(
                  buildWhen: (previous, current) =>
                      previous.speedTitle != current.speedTitle,
                  builder: (context, state) {
                    return Text(state.speedTitle);
                  },
                ),
                const _SwapIcon(),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Text('Атмосферное давление'),
                const Spacer(),
                BlocBuilder<SettingsBloc, SettingsState>(
                  buildWhen: (previous, current) =>
                      previous.preassureTitle != current.preassureTitle,
                  builder: (context, state) {
                    return Text(state.preassureTitle);
                  },
                ),
                const _SwapIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapIcon extends StatelessWidget {
  const _SwapIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const RotatedBox(
      quarterTurns: 1,
      child: Icon(Icons.code),
    );
  }
}

class _DialogWidget extends StatelessWidget {
  const _DialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogButtonItem(
              onTap: () => context
                  .read<SettingsBloc>()
                  .add(const SettingsEventChangeTemperatureUnit(
                    temperatureUnit: TemperatureUnits.celsius,
                  )),
              title: 'celsium',
            ),
            _DialogButtonItem(
              onTap: () => context
                  .read<SettingsBloc>()
                  .add(const SettingsEventChangeTemperatureUnit(
                    temperatureUnit: TemperatureUnits.fahrenheit,
                  )),
              title: 'fahrenheit',
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButtonItem extends StatelessWidget {
  final String title;
  final Function onTap;
  const _DialogButtonItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        children: [Text(title), const Icon(Icons.arrow_right)],
      ),
    );
  }
}

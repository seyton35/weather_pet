import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_pet/features/locations_settings/location_settings.dart';
import 'package:weather_repository/weather_repository.dart' hide Location;

class LocationSettingsPage extends StatelessWidget {
  const LocationSettingsPage({super.key});

  static Widget create() {
    return BlocProvider(
      create: (context) => LocationSettingsBloc(
        context: context,
        weatherRepository: context.read<WeatherRepository>(),
      )..add(const LocationSettingsEventSubscription()),
      child: const LocationSettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление городами'),
      ),
      body: BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case LocationSettingsStatus.initial:
              return const SizedBox.shrink();
            case LocationSettingsStatus.editing:
            case LocationSettingsStatus.success:
              return const _BodyWidget();
            case LocationSettingsStatus.error:
            default:
              return Center(child: Text(state.errorTitle));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context
            .read<LocationSettingsBloc>()
            .add(const LocationSettingsEventEditingButtonTap()),
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => Column(
        children: [
          const SizedBox(height: 10),
          const _SearchLocationWidget(),
          const SizedBox(height: 10),
          state.status == LocationSettingsStatus.success
              ? const _LocationsListView()
              : const _EditingLocationsListView(),
        ],
      ),
    );
  }
}

class _SearchLocationWidget extends StatelessWidget {
  const _SearchLocationWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton(
        onPressed: () => context
            .read<LocationSettingsBloc>()
            .add(const LocationSettingsEventSearchButtonTap()),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
          side: const MaterialStatePropertyAll(BorderSide.none),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            Text(
              'Введите местоположение',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditingLocationsListView extends StatelessWidget {
  const _EditingLocationsListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
      builder: (context, state) {
        final locations = state.locationsList;
        return SizedBox(
          height: 500,
          child: ReorderableListView.builder(
            itemCount: locations.length,
            // padding: const EdgeInsets.symmetric(horizontal: 10),
            header: Container(),
            itemBuilder: (context, index) => _ListItem(
              key: ValueKey(locations[index].id),
              index: index,
              location: locations[index],
              editing: true,
            ),
            onReorder: (oldIndex, newIndex) {
              context
                  .read<LocationSettingsBloc>()
                  .add(LocationSettingsEventDragging(
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                  ));
            },
          ),
        );
      },
    );
  }
}

class _LocationsListView extends StatelessWidget {
  const _LocationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
      builder: (context, state) {
        return SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: state.locationsList.length,
            itemBuilder: (context, index) {
              final location = state.locationsList[index];
              return _ListItem(
                key: ValueKey(location.id),
                index: index,
                location: location,
                editing: false,
              );
            },
          ),
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final int index;
  final Location location;
  final bool editing;

  const _ListItem({
    required super.key,
    required this.index,
    required this.location,
    required this.editing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.grey,
        ),
        child: ListTile(
          key: ValueKey(location.id),
          title: _LocationCard(location: location),
          minLeadingWidth: 0,
          leading: editing
              ? ReorderableDragStartListener(
                  key: ValueKey<int>(index),
                  index: index,
                  child: const Icon(Icons.menu),
                )
              : null,
          trailing: editing
              ? IconButton(
                  onPressed: () => context
                      .read<LocationSettingsBloc>()
                      .add(LocationSettingsEventToggleCheck(index: index)),
                  icon: Icon(
                    location.check
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final Location location;
  const _LocationCard({required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.locationTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 10),
            Text(location.regionTitle),
            const SizedBox(width: 10),
            Row(
              children: [
                Image.asset(
                  location.iconPath,
                  width: 50,
                ),
                Text('${location.minTempTitle}°/${location.maxTempTitle}°'),
              ],
            ),
          ],
        ),
        Column(children: [
          Text(
            '${location.currentTempTitle}°',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          )
        ]),
      ],
    );
  }
}

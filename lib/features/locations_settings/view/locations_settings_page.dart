import 'dart:ui';

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
    return BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
      buildWhen: (previous, current) =>
          current.status != previous.status ||
          current.checkedItemsCount == current.locationsList.length &&
              previous.checkedItemsCount != current.locationsList.length ||
          previous.checkedItemsCount == current.locationsList.length &&
              current.checkedItemsCount != current.locationsList.length,
      builder: (context, state) {
        final appBar = AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey[800],
          elevation: 0,
          centerTitle: true,
          title: const _AppBarTitleWidget(),
          leading: state.status != LocationSettingsStatus.editing
              ? null
              : IconButton(
                  onPressed: () => context.read<LocationSettingsBloc>().add(
                        const LocationSettingsEventEditing(editing: false),
                      ),
                  icon: const Icon(Icons.close)),
          actions: state.status != LocationSettingsStatus.editing
              ? null
              : [
                  IconButton(
                    onPressed: () => context
                        .read<LocationSettingsBloc>()
                        .add(const LocationSettingsEventCheckAll()),
                    icon: Icon(
                      Icons.checklist_rounded,
                      color:
                          state.checkedItemsCount == state.locationsList.length
                              ? Colors.blue
                              : null,
                    ),
                  ),
                ],
        );
        return Scaffold(
          appBar: appBar,
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
          floatingActionButton: const _FloatingActionButtonsWidget(),
        );
      },
    );
  }
}

class _AppBarTitleWidget extends StatelessWidget {
  const _AppBarTitleWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
      buildWhen: (previous, current) =>
          current.status != previous.status ||
          current.checkedItemsCount != previous.checkedItemsCount,
      builder: (context, state) {
        if (state.status == LocationSettingsStatus.editing) {
          if (state.checkedItemsCount > 0) {
            return Text('Выбрано ${state.checkedItemsCount}');
          }
          return const Text('Выберите объекты');
        }
        return const Text('Управление городами');
      },
    );
  }
}

class _FloatingActionButtonsWidget extends StatelessWidget {
  const _FloatingActionButtonsWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) =>
          state.status == LocationSettingsStatus.success
              ? FloatingActionButton(
                  onPressed: () => context
                      .read<LocationSettingsBloc>()
                      .add(const LocationSettingsEventEditing(editing: true)),
                  child: const Icon(Icons.edit),
                )
              : FloatingActionButton(
                  onPressed: () => context
                      .read<LocationSettingsBloc>()
                      .add(const LocationSettingsEventDeleteButtonTap()),
                  child: const Icon(Icons.delete),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: state.status == LocationSettingsStatus.success
                ? const _LocationsListView()
                : const _EditingLocationsListView(),
          ),
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

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.07, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: elevation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
      buildWhen: (previous, current) =>
          previous.locationsList != current.locationsList,
      builder: (context, state) {
        final locations = state.locationsList;
        return SizedBox(
          //todo escape fixed height
          height: 543,
          child: ReorderableListView.builder(
            proxyDecorator: proxyDecorator,
            itemCount: locations.length,
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
  const _LocationsListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSettingsBloc, LocationSettingsState>(
      buildWhen: (previous, current) =>
          previous.locationsList != current.locationsList,
      builder: (context, state) {
        return SizedBox(
          //todo escape fixed height
          height: 543,
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
    final List<Widget> list = [];
    if (editing) {
      list.add(ReorderableDragStartListener(
        key: ValueKey<int>(index),
        index: index,
        child: const Icon(Icons.menu),
      ));
    }
    list.add(_LocationCard(location: location));
    if (editing) {
      list.add(IconButton(
        onPressed: () => context
            .read<LocationSettingsBloc>()
            .add(LocationSettingsEventToggleCheck(index: index)),
        icon: Icon(
          location.check
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank,
          color: Colors.white,
        ),
      ));
    }
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu),
                    ],
                  ),
                )
              : null,
          trailing: editing
              ? SizedBox(
                  width: 30,
                  child: IconButton(
                    onPressed: () => context
                        .read<LocationSettingsBloc>()
                        .add(LocationSettingsEventToggleCheck(index: index)),
                    icon: Icon(
                      location.check
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: Colors.white,
                    ),
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
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.locationTitle,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              Text(
                location.regionTitle,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Image.asset(
                    location.iconPath,
                    width: 50,
                  ),
                  const SizedBox(width: 10),
                  Text(location.minTempTitle + location.maxTempTitle),
                ],
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              location.currentTempTitle,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ],
    );
  }
}

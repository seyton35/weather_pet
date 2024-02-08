import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_pet/features/choose_location/choose_location.dart';
import 'package:weather_repository/weather_repository.dart' hide Location;

class ChooseLocation extends StatelessWidget {
  const ChooseLocation({super.key});

  static Widget create({required bool isRootRoute}) {
    return BlocProvider(
      create: (context) => ChooseLocationBloc(
        weatherRepository: context.read<WeatherRepository>(),
        context: context,
        isRootRoute: isRootRoute,
      ),
      child: const ChooseLocation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _AppBarWidget(),
        automaticallyImplyLeading: false,
        titleSpacing: 10,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: BlocBuilder<ChooseLocationBloc, ChooseLocationState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case ChooseLocationBlocStatus.initial:
              return const SizedBox.shrink();
            case ChooseLocationBlocStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ChooseLocationBlocStatus.success:
              return const _BodyWidget();
            case ChooseLocationBlocStatus.error:
            default:
              return Center(child: Text(state.errorTitle));
          }
        },
      ),
    );
  }
}

class _AppBarWidget extends StatelessWidget {
  const _AppBarWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: const Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _AppBarrSearchTextField(),
              ],
            ),
          ),
          _AppBarCancelButton(),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _AppBarrSearchTextField extends StatelessWidget {
  const _AppBarrSearchTextField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      onChanged: (text) => context
          .read<ChooseLocationBloc>()
          .add(ChooseLocationEventChangeQuery(text)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        prefixIcon: const Icon(Icons.search),
        contentPadding: EdgeInsets.zero,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9999)),
            borderSide: BorderSide.none),
      ),
    );
  }
}

class _AppBarCancelButton extends StatelessWidget {
  const _AppBarCancelButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context
          .read<ChooseLocationBloc>()
          .add(ChooseLocationEventCanselButtonTap()),
      child: const Text(
        'отмена',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: size.width,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FirstLocationWidget(),
            _LocationListWidget(),
          ],
        ),
      ),
    ]);
  }
}

class _FirstLocationWidget extends StatelessWidget {
  const _FirstLocationWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationBloc, ChooseLocationState>(
        buildWhen: (previous, current) =>
            current.locationsList.isEmpty != previous.locationsList.isEmpty ||
            previous.locationsList.isNotEmpty &&
                current.locationsList.isNotEmpty &&
                current.locationsList[0] != previous.locationsList[0],
        builder: (context, state) {
          switch (state.locationsList.isEmpty) {
            case true:
              return const SizedBox.shrink();
            case false:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LocationListItem(index: 0, item: state.locationsList[0]),
                  const _DaysWeatherListWidget(),
                ],
              );
          }
        });
  }
}

class _DaysWeatherListWidget extends StatelessWidget {
  const _DaysWeatherListWidget();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationBloc, ChooseLocationState>(
      // buildWhen: (previous, current) =>
      //     previous.locationDaylyWeatherList != current.locationDaylyWeatherList,
      builder: (context, state) => Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: state.locationDaylyWeatherList
                  .map((day) => Column(
                        children: [
                          Text(day.dayOfWeekTitle),
                          Image.asset((day.iconPath), height: 50),
                          Text('${day.maxTempTitle}°'),
                          Text('${day.minTempTitle}°'),
                        ],
                      ))
                  .toList()),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}

class _LocationListWidget extends StatelessWidget {
  const _LocationListWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationBloc, ChooseLocationState>(
        buildWhen: (previous, current) =>
            current.locationsList.length > 1 &&
            current.locationsList != previous.locationsList,
        builder: (context, state) {
          final children = <Widget>[];
          for (var i = 1; i < state.locationsList.length; i++) {
            children.add(_LocationListItem(
              index: i,
              item: state.locationsList[i],
            ));
          }
          return Column(
            children: children,
          );
        });
  }
}

class _LocationListItem extends StatelessWidget {
  final int index;
  final Location item;
  const _LocationListItem({
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => context
          .read<ChooseLocationBloc>()
          .add(ChooseLocationEventItemTap(item)),
      child: Container(
        height: 88,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width / 10 * 5.5,
                  child: Text(
                    item.locationTitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Text(
                  item.regionTitle,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            item.alreadyTracking
                ? _AddLocationButtonGap()
                : _AddLocationButton(location: item),
          ],
        ),
      ),
    );
  }
}

class _AddLocationButton extends StatelessWidget {
  const _AddLocationButton({
    required this.location,
  });

  final Location location;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context
          .read<ChooseLocationBloc>()
          .add(ChooseLocationEventButtonTap(location)),
      icon: const Icon(Icons.add),
      padding: EdgeInsets.zero,
    );
  }
}

class _AddLocationButtonGap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text('Добавлено'),
        Icon(Icons.keyboard_arrow_right_outlined),
      ],
    );
  }
}

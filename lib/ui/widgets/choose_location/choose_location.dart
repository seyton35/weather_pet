import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_pet/ui/widgets/choose_location/choose_location_model.dart';

class ChooseLocation extends StatelessWidget {
  const ChooseLocation({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => ChooseLocationViewModel(context),
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
      body: const _BodyWidget(),
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
    final model = context.read<ChooseLocationViewModel>();
    return TextField(
      autofocus: true,
      onChanged: (text) => model.onTextFieldEdit(text: text),
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
    final model = context.read<ChooseLocationViewModel>();
    return TextButton(
      onPressed: () => model.onCancelButtonTap(),
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
    final errorTitle =
        context.select((ChooseLocationViewModel vm) => vm.state.errorTitle);
    if (errorTitle != null) {
      return Center(
          child: Text(
        errorTitle,
        style: const TextStyle(fontSize: 18),
      ));
    }
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
    final locationsList =
        context.select((ChooseLocationViewModel vm) => vm.state.locationsList);
    if (locationsList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationRowWidget(location: locationsList.first),
        const _DaysWeatherListWidget(),
      ],
    );
  }
}

class _DaysWeatherListWidget extends StatelessWidget {
  const _DaysWeatherListWidget();

  @override
  Widget build(BuildContext context) {
    final daysList = context
        .select((ChooseLocationViewModel vm) => vm.state.locationDaysList);
    if (daysList.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: daysList
                .map((day) => Column(
                      children: [
                        Text(day.dayOfWeekTitle),
                        Image.asset(
                          (day.iconPath),
                          height: 50,
                        ),
                        Text('${day.maxTempTitle}°'),
                        Text('${day.minTempTitle}°'),
                      ],
                    ))
                .toList()),
        const SizedBox(height: 20),
        const Divider(thickness: 1),
      ],
    );
  }
}

class _LocationListWidget extends StatelessWidget {
  const _LocationListWidget();

  @override
  Widget build(BuildContext context) {
    var locationsList =
        context.select((ChooseLocationViewModel vm) => vm.state.locationsList);
    if (locationsList.length < 2) {
      return const SizedBox.shrink();
    }
    locationsList = locationsList.sublist(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: locationsList
          .map((location) => _LocationRowWidget(location: location))
          .toList(),
    );
  }
}

class _LocationRowWidget extends StatelessWidget {
  final ChooseLocationViewModelLocation location;
  const _LocationRowWidget({required this.location});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ChooseLocationViewModel>();
    return InkWell(
      onTap: () => model.onLocationWidgetTap(location),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.locationTitle,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  location.regionTitle,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            location.alreadyTracking
                ? _AddLocationButtonGap()
                : _AddLocationButton(location: location),
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

  final ChooseLocationViewModelLocation location;

  @override
  Widget build(BuildContext context) {
    final model = context.read<ChooseLocationViewModel>();
    return IconButton(
      onPressed: () => model.onAddLocationButtonTap(location),
      icon: const Icon(Icons.add),
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

import 'package:flutter/material.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';

class LocationSettings extends StatelessWidget {
  const LocationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Управление городами')),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 10),
        _SearchLocationWidget(),
        SizedBox(height: 10),
        _LocationListView(),
      ],
    );
  }
}

class _SearchLocationWidget extends StatelessWidget {
  const _SearchLocationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton(
        onPressed: () => Navigator.of(context)
            .pushNamed(MainNavigationRouteNames.chooseLocation),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
          side: const MaterialStatePropertyAll(BorderSide.none),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        child: Row(
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

class _LocationListView extends StatelessWidget {
  const _LocationListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: double.infinity,
      // child: ListView(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_pet/ui/widgets/loader/loader_model.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  static Widget create() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      lazy: false,
      child: const Loader(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

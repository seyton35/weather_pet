import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_pet/domain/data_providers/track_location_data_provider.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';
import 'package:weather_pet/ui/widgets/main_app/main_app.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext _context;
  List<TrackingLocation>? trackList;

  _ViewModel({required BuildContext context, this.trackList})
      : _context = context {
    if (trackList == null) {
      return;
    } else if (trackList!.isNotEmpty) {
      navigateToMainScreen();
    } else {
      navigateToChooseLocation();
    }
  }

  void navigateToChooseLocation() async {
    await Duration();

    Navigator.of(_context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.chooseLocation, (route) => false);
  }

  void navigateToMainScreen() async {
    await Duration();
    Navigator.of(_context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.mainScreen, (route) => false);
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  static Widget create() {
    return ChangeNotifierProxyProvider<MainAppModel, _ViewModel>(
      create: (context) => _ViewModel(context: context),
      lazy: false,
      update: (context, app, _) => _ViewModel(
        context: context,
        trackList: app.trackList,
      ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_pet/domain/data_providers/track_location_data_provider.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';
import 'package:weather_pet/ui/navigation/main_navigartion.dart';

class MainAppModel extends ChangeNotifier {
  final weatherRepository = WeatherRepository();
  List<TrackingLocation>? trackList;

  MainAppModel() {
    init();
  }

  Future<void> init() async {
    await weatherRepository.init();
    trackList = weatherRepository.locationTrackList;
    notifyListeners();
  }

  void trackLocation(TrackingLocation location) {
    weatherRepository.startTrackingLocation(location: location);
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MainApp({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => MainAppModel(),
      lazy: false,
      child: const MainApp(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      initialRoute: mainNavigation.initialRoute(),
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGeneratedRoute,
    );
  }
}

// class Counter extends ChangeNotifier {
//   Counter(this._value);

//   int _value;

//   int get value => _value;

//   void up() {
//     _value++;
//     notifyListeners();
//   }

//   void down() {
//     _value--;
//     notifyListeners();
//   }
// }

// class Translations extends ChangeNotifier {
//   Translations(this._value);

//   final int _value;

//   String get title => 'You clicked $_value times';
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   static Widget create() {
//     return ChangeNotifierProvider(
//       create: (_) => Counter(0),
//       lazy: false,
//       child: const MainApp(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return App.create();
//   }
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   static Widget create() {
//     return ChangeNotifierProxyProvider<Counter, Translations>(
//       create: (_) => Translations(0),
//       update: (_, counter, __) => Translations(counter.value),
//       child: const App(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final model = context.read<Counter>();
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ValueStringTitle(),
//               ValueTitle(),
//               ElevatedButton(
//                 onPressed: model.up,
//                 child: Text('+'),
//               ),
//               ElevatedButton(
//                 onPressed: model.down,
//                 child: Text('-'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ValueStringTitle extends StatelessWidget {
//   const ValueStringTitle({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final counter = context.select((Counter vm) => vm.value);
//     return Text('$counter');
//   }
// }

// class ValueTitle extends StatelessWidget {
//   const ValueTitle({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // final title = context.select((Translations vm) => vm.title);
//     return Text('title');
//   }
// }

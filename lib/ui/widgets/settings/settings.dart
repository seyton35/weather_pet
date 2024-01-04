import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_pet/domain/repositories/weather_repository.dart';

class _Data {
  int value;
  final Key key;

  _Data({
    required this.key,
    required this.value,
  });
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  bool flag = false;
  List<int> _list = [1];
  List<int> get list => _list;
  final weatherRepo = WeatherRepository();

  _ViewModel(this.context) {
    init();
  }

  Future<void> init() => weatherRepo.init();

  void deleteLocations() {
    final locationTrackList = weatherRepo.locationTrackList;
    final res = weatherRepo.deleteTrackingLocations(locationTrackList);
    if (res) {
      Navigator.of(context).pop();
    }
  }

  void changeFlag() {
    flag = !flag;
    notifyListeners();
  }

  void addItem() {
    // _list = [..._list, _Data(key: UniqueKey(), value: 0)];
    // _list.add(0);
    _list = [..._list, 0];
    notifyListeners();
  }

  void deleteItem(int index) {
    _list.removeAt(index);
    // _list = [..._list];
    notifyListeners();
  }

  void increaseItemValue(int index) {
    _list[index] = _list[index] + 1;
    notifyListeners();
  }

  void clearList() {
    _list = [];
    notifyListeners();
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context),
      lazy: false,
      child: const Settings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(children: [
        Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: model.deleteLocations,
                child: Text('удалить все локации'),
              ),
              const _Flag(),
              IconButton(
                onPressed: model.changeFlag,
                icon: const Icon(
                  Icons.loop,
                  size: 36,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: model.addItem,
                    icon: const Icon(
                      Icons.plus_one,
                      size: 36,
                    ),
                  ),
                  IconButton(
                    onPressed: model.clearList,
                    icon: const Icon(
                      Icons.clear,
                      size: 36,
                    ),
                  ),
                ],
              ),
              const _List(),
            ],
          ),
        ),
      ]),
    );
  }
}

class _Flag extends StatelessWidget {
  const _Flag();

  @override
  Widget build(BuildContext context) {
    final flag = context.select((_ViewModel value) => value.flag);
    return Text(
      flag.toString(),
      style: const TextStyle(fontSize: 24),
    );
  }
}

class _List extends StatelessWidget {
  const _List({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final listLength = context.select((_ViewModel vm) => vm.list.length);
    final items = <Widget>[];
    for (var i = 0; i < listLength; i++) {
      items.add(_Item(
        // value: e.value,
        index: i,
      ));
    }
    return Column(
      children: [
        Text(listLength.toString()),
        IconButton(onPressed: () => model.deleteItem(0), icon: deleteIcon),
        SizedBox(
          height: 500,
          child: ListView(children: items
              // list.asMap().entries.map((e) {
              //   final index = e.key;
              //   return _Item(
              //     value: e.value,
              //     index: index,
              //   );
              // }).toList(),
              ),
        ),
      ],
    );
  }
}

const addIcon = Icon(
  Icons.add,
  size: 35,
);
const deleteIcon = Icon(
  Icons.delete,
  size: 35,
);

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    // required this.value,
    required this.index,
  });
  // final int value;
  final int index;
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    if (index >= model.list.length) {
      return SizedBox();
    }
    final item = context.select((_ViewModel value) => value.list[index]);
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Text(
            '$item',
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
              onPressed: () => model.increaseItemValue(index), icon: addIcon),
          IconButton(
              onPressed: () => model.deleteItem(index), icon: deleteIcon),
        ],
      ),
    );
  }
}

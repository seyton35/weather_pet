part of 'choose_location_bloc.dart';

sealed class ChooseLocationEvent extends Equatable {
  const ChooseLocationEvent();

  @override
  List<Object> get props => [];
}

class ChooseLocationEventChangeQuery extends ChooseLocationEvent {
  final String textQuery;
  const ChooseLocationEventChangeQuery(this.textQuery);

  @override
  List<Object> get props => [textQuery];
}

class ChooseLocationEventButtonTap extends ChooseLocationEvent {
  final Location location;
  const ChooseLocationEventButtonTap(this.location);

  @override
  List<Object> get props => [location];
}

class ChooseLocationEventItemTap extends ChooseLocationEvent {
  final Location location;
  const ChooseLocationEventItemTap(this.location);

  @override
  List<Object> get props => [location];
}

class ChooseLocationEventCanselButtonTap extends ChooseLocationEvent {
  @override
  List<Object> get props => [];
}

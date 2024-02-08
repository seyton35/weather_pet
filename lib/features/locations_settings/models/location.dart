import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String locationTitle;
  final String regionTitle;
  final String currentTempTitle;
  final String maxTempTitle;
  final String minTempTitle;
  final bool check;
  final String iconPath;

  const Location({
    required this.id,
    required this.locationTitle,
    required this.regionTitle,
    required this.currentTempTitle,
    required this.maxTempTitle,
    required this.minTempTitle,
    this.check = false,
    required this.iconPath,
  });

  @override
  List<Object> get props => [
        id,
        locationTitle,
        regionTitle,
        currentTempTitle,
        maxTempTitle,
        minTempTitle,
        check,
        iconPath,
      ];

  Location copyWith({
    String? id,
    String? locationTitle,
    String? regionTitle,
    String? currentTempTitle,
    String? maxTempTitle,
    String? minTempTitle,
    bool? check,
    String? iconPath,
  }) {
    return Location(
      id: id ?? this.id,
      locationTitle: locationTitle ?? this.locationTitle,
      regionTitle: regionTitle ?? this.regionTitle,
      currentTempTitle: currentTempTitle ?? this.currentTempTitle,
      maxTempTitle: maxTempTitle ?? this.maxTempTitle,
      minTempTitle: minTempTitle ?? this.minTempTitle,
      check: check ?? this.check,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}

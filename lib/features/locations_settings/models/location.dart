class Location {
  final String id;
  final String locationTitle;
  final String regionTitle;
  final String currentTempTitle;
  final String maxTempTitle;
  final String minTempTitle;
  bool check;
  final String iconPath;

  Location({
    required this.id,
    required this.locationTitle,
    required this.regionTitle,
    required this.currentTempTitle,
    required this.maxTempTitle,
    required this.minTempTitle,
    this.check = false,
    required this.iconPath,
  });
}

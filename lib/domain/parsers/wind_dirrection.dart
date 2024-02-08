class WindDirrectionParser {
  static double rountWindDirrection({required double windDegree}) {
    const angle = 45;
    final division = windDegree % angle;
    if (division < angle / 2) {
      return windDegree - division;
    } else {
      return windDegree - division + angle;
    }
  }
}

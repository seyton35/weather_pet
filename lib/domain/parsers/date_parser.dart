class _DayOfWeekDict {
  final String fullWord;
  final String shortWord;
  _DayOfWeekDict({
    required this.fullWord,
    required this.shortWord,
  });
}

List<_DayOfWeekDict> _dict = [
  _DayOfWeekDict(fullWord: 'понедельник', shortWord: 'пн.'),
  _DayOfWeekDict(fullWord: 'вторник', shortWord: 'вт.'),
  _DayOfWeekDict(fullWord: 'среда', shortWord: 'ср.'),
  _DayOfWeekDict(fullWord: 'четверг', shortWord: 'чт.'),
  _DayOfWeekDict(fullWord: 'пятница', shortWord: 'пт.'),
  _DayOfWeekDict(fullWord: 'суббота', shortWord: 'сб.'),
  _DayOfWeekDict(fullWord: 'воскресенье', shortWord: 'вс.'),
];

class DateParser {
  String dayOfWeekRu({
    required DateTime date,
    short = false,
    upperCaseFirst = false,
  }) {
    String res;
    final index = date.weekday - 1;
    res = short ? _dict[index].shortWord : _dict[index].fullWord;
    if (upperCaseFirst) {
      var letter = res[0].toUpperCase();
      res = res.replaceRange(0, 1, letter);
    }

    return res;
  }

  String dayAndMonthNumeric({
    required DateTime date,
  }) {
    String day = date.day.toString();
    String month = date.month.toString();
    if (month.length == 1) month = '0$month';
    if (day.length == 1) day = '0$day';

    return '$day.$month';
  }
}

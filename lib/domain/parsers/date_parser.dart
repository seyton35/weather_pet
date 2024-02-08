class _DayOfWeekDict {
  final String fullWord;
  final String shortWord;
  _DayOfWeekDict({
    required this.fullWord,
    required this.shortWord,
  });
}

List<_DayOfWeekDict> dict = [
  _DayOfWeekDict(fullWord: 'понедельник', shortWord: 'пн.'),
  _DayOfWeekDict(fullWord: 'вторник', shortWord: 'вт.'),
  _DayOfWeekDict(fullWord: 'среда', shortWord: 'ср.'),
  _DayOfWeekDict(fullWord: 'четверг', shortWord: 'чт.'),
  _DayOfWeekDict(fullWord: 'пятница', shortWord: 'пт.'),
  _DayOfWeekDict(fullWord: 'суббота', shortWord: 'сб.'),
  _DayOfWeekDict(fullWord: 'воскресенье', shortWord: 'вс.'),
];

class DateParser {
  String dayOfWeekRu(
      {required DateTime date, short = false, upperCaseFirst = false}) {
    String res;
    final index = date.weekday - 1;
    res = short ? dict[index].shortWord : dict[index].fullWord;
    if (upperCaseFirst) {
      var letter = res[0].toUpperCase();
      res = res.replaceRange(0, 1, letter);
    }

    return res;
  }
}

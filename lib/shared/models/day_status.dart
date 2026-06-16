enum DayStatus {
  green,
  yellow,
  red,
  empty;

  String get label => switch (this) {
        DayStatus.green => 'Выполнено',
        DayStatus.yellow => 'Қаза закрыта',
        DayStatus.red => 'Пропуск',
        DayStatus.empty => 'Нет данных',
      };
}

enum WeekStatus {
  green,
  yellow,
  red,
  empty,
  future,
  current;

  String get label => switch (this) {
        WeekStatus.green => 'Все намазы выполнены',
        WeekStatus.yellow => 'Были пропуски, қаза закрыта',
        WeekStatus.red => 'Есть незакрытая қаза',
        WeekStatus.empty => 'Нет данных',
        WeekStatus.future => 'Будущая неделя',
        WeekStatus.current => 'Текущая неделя',
      };
}

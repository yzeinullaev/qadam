# Qadam — Өмір апталығы

Локальное Flutter-приложение для трекинга намаза, қаза, Корана, садака, привычек, настроения и визуализации жизни по неделям.

## Запуск

```bash
flutter pub get
dart run build_runner build
flutter run
```

Для iOS-сборки нужен Mac с Xcode (или Codemagic / TestFlight).

## Экраны

| Экран | Маршрут | Описание |
|-------|---------|----------|
| Onboarding | `/onboarding` | Первый запуск: профиль, намазы, привычки |
| Today | `/today` | Быстрая отметка дня |
| Life Map | `/life` | Карта жизни по неделям |
| Stats | `/stats` | Статистика и инсайты |
| Settings | `/settings` | Профиль и настройки |
| Week Detail | `/week/:weekIndex` | 7 дней недели |
| Day Detail | `/day/:date` | Подробности дня |

## Архитектура

```
lib/
  app/           — приложение, роутер, тема
  core/          — константы, расчёты, утилиты
  data/          — Drift SQLite, репозитории
  features/      — экраны по фичам
  shared/        — провайдеры, виджеты, модели
```

## Стек

- `flutter_riverpod` — состояние
- `go_router` — навигация
- `drift` — локальная БД
- `adhan_dart` — время намаза
- `geolocator` + `permission_handler` — геолокация
- `fl_chart` — графики в Stats

## База данных

Таблицы: `user_profiles`, `prayer_settings`, `habit_settings`, `day_records`, `prayer_records`, `habit_records`.

После изменения схемы:

```bash
dart run build_runner build
```

## Логика статусов

**День:** green (все намазы) → yellow (пропуски, қаза закрыта) → red (незакрытая қаза)

**Неделя:** red > yellow > green; текущая неделя — синяя

**Баллы:**
- **Completion Score** — % выполненных активных намазов
- **Bereke Score** — 0–100 (намаз 70 + қаза 10 + Коран 10 + садака 5 + привычки 5)

## Геолокация

- Включена — координаты с GPS
- Выключена — координаты по названию города (Алматы, Астана, Шымкент и др.)

## MVP-1 — не входит

Сервер, авторизация, синхронизация, виджеты, push, App Store, социальные функции.

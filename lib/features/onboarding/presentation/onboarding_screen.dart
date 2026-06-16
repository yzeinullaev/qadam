import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/habit_keys.dart';
import '../../../core/constants/prayer_keys.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/repository_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();

  int _step = 0;
  DateTime? _birthDate;
  int _lifeExpectancy = 80;
  bool _useGeolocation = true;
  bool _saving = false;

  static const _stepCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step < _stepCount - 1) {
      if (!_validateStep()) return;
      setState(() => _step++);
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    await _finish();
  }

  bool _validateStep() {
    switch (_step) {
      case 0:
        if (_nameController.text.trim().isEmpty) {
          _showError('Введите имя');
          return false;
        }
        if (_birthDate == null) {
          _showError('Выберите дату рождения');
          return false;
        }
        if (_cityController.text.trim().isEmpty) {
          _showError('Введите город');
          return false;
        }
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _finish() async {
    if (!_validateStep()) return;
    setState(() => _saving = true);

    try {
      await ref.read(userProfileRepositoryProvider).saveProfile(
            name: _nameController.text.trim(),
            birthDate: _birthDate!,
            lifeExpectancy: _lifeExpectancy,
            city: _cityController.text.trim(),
            latitude: null,
            longitude: null,
            useGeolocation: _useGeolocation,
            calculationMethod: AppConstants.calculationMethods.first,
            asrMadhab: AppConstants.asrMadhabOptions.first,
            onboardingCompleted: true,
            activePrayerKeys: PrayerKeys.defaultActive,
            activeHabitKeys: HabitKeys.mvpActive,
          );
      ref.invalidate(onboardingCompletedProvider);
      ref.invalidate(userProfileProvider);
      ref.read(dayRecordRepositoryProvider).invalidateSettingsCache();
      await ref.read(onboardingCompletedProvider.future);

      if (!mounted) return;
      context.go('/today');
    } catch (e) {
      if (mounted) {
        _showError('Не удалось сохранить: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(AppConstants.appName),
            Text(
              AppConstants.appSubtitle,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_step + 1) / _stepCount),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _profileStep(),
                _locationStep(),
                _readyStep(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_step > 0)
                  TextButton(
                    onPressed: _saving
                        ? null
                        : () {
                            setState(() => _step--);
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    child: const Text('Назад'),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: _saving ? null : _next,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _step == _stepCount - 1
                              ? (_saving ? AppStrings.saving : 'Начать')
                              : 'Далее',
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Добро пожаловать', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Расскажи немного о себе — это основа карты жизни'),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Имя'),
        ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Дата рождения'),
          subtitle: Text(
            _birthDate == null
                ? 'Не выбрана'
                : '${_birthDate!.day}.${_birthDate!.month}.${_birthDate!.year}',
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _birthDate ?? DateTime(1990),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
            );
            if (picked != null) setState(() => _birthDate = picked);
          },
        ),
        const SizedBox(height: 8),
        Text('Ожидаемый возраст', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          segments: AppConstants.lifeExpectancyOptions
              .map((e) => ButtonSegment(value: e, label: Text('$e')))
              .toList(),
          selected: {_lifeExpectancy},
          onSelectionChanged: (s) => setState(() => _lifeExpectancy = s.first),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _cityController,
          decoration: const InputDecoration(labelText: 'Город'),
        ),
      ],
    );
  }

  Widget _locationStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Геолокация', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
          'Нужна для расчёта времени намаза. Можно отключить и указать город.',
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.geolocationHint,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Использовать геолокацию'),
          value: _useGeolocation,
          onChanged: (v) => setState(() => _useGeolocation = v),
        ),
      ],
    );
  }

  Widget _readyStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Твой путь', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('В MVP отслеживаем только главное:'),
        const SizedBox(height: 20),
        _readyItem('🕌', '5 намазов + қаза'),
        _readyItem('📖', 'Коран'),
        _readyItem('🤲', 'Садака'),
        _readyItem('😊', 'Настроение'),
        _readyItem('🗺', 'Карта жизни'),
        const SizedBox(height: 16),
        Text(
          'Остальное — позже, когда привыкнешь к ритму.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _readyItem(String emoji, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

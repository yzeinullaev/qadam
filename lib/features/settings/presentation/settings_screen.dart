import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/location_service.dart';
import '../../../core/utils/city_coordinates.dart';
import '../../../data/local/app_database.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/repository_providers.dart';
import '../../../shared/widgets/qadam_ui.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();

  UserProfile? _profile;
  bool _loading = true;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final profile = await settingsRepo.getProfile();

    if (profile != null) {
      _nameController.text = profile.name;
      _cityController.text = profile.city;
    }

    setState(() {
      _profile = profile;
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_profile == null) return;
    final city = _cityController.text.trim();
    final coords = CityCoordinates.forCity(city);
    final lat = _profile!.useGeolocation ? _profile!.latitude : coords.$1;
    final lng = _profile!.useGeolocation ? _profile!.longitude : coords.$2;

    final repo = ref.read(settingsRepositoryProvider);
    await repo.updateProfile(
      UserProfilesCompanion(
        id: Value(_profile!.id),
        name: Value(_nameController.text.trim()),
        city: Value(city),
        latitude: Value(lat),
        longitude: Value(lng),
        updatedAt: Value(DateTime.now()),
      ),
    );
    ref.invalidate(userProfileProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.profileSaved)),
      );
    }
  }

  Future<void> _updateGeolocation(bool enabled) async {
    if (_profile == null) return;
    double? lat = _profile!.latitude;
    double? lng = _profile!.longitude;

    if (enabled) {
      try {
        final pos = await LocationService().getCurrentPosition();
        lat = pos?.latitude;
        lng = pos?.longitude;
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.geolocationHint)),
          );
        }
      }
    }

    if (!enabled || lat == null || lng == null) {
      final coords = CityCoordinates.forCity(_profile!.city);
      lat = coords.$1;
      lng = coords.$2;
    }

    await ref.read(settingsRepositoryProvider).updateProfile(
          UserProfilesCompanion(
            id: Value(_profile!.id),
            useGeolocation: Value(enabled),
            latitude: Value(lat),
            longitude: Value(lng),
            updatedAt: Value(DateTime.now()),
          ),
        );
    await _load();
    ref.invalidate(userProfileProvider);
  }

  Future<void> _updatePrayerMethod(String method) async {
    if (_profile == null) return;
    await ref.read(settingsRepositoryProvider).updateProfile(
          UserProfilesCompanion(
            id: Value(_profile!.id),
            calculationMethod: Value(method),
            updatedAt: Value(DateTime.now()),
          ),
        );
    await _load();
  }

  Future<void> _updateAsrMadhab(String madhab) async {
    if (_profile == null) return;
    await ref.read(settingsRepositoryProvider).updateProfile(
          UserProfilesCompanion(
            id: Value(_profile!.id),
            asrMadhab: Value(madhab),
            updatedAt: Value(DateTime.now()),
          ),
        );
    await _load();
  }

  Future<void> _updateLifeExpectancy(int value) async {
    if (_profile == null) return;
    await ref.read(settingsRepositoryProvider).updateProfile(
          UserProfilesCompanion(
            id: Value(_profile!.id),
            lifeExpectancy: Value(value),
            updatedAt: Value(DateTime.now()),
          ),
        );
    await _load();
    ref.invalidate(userProfileProvider);
  }

  Future<void> _updateBirthDate(DateTime date) async {
    if (_profile == null) return;
    await ref.read(settingsRepositoryProvider).updateProfile(
          UserProfilesCompanion(
            id: Value(_profile!.id),
            birthDate: Value(date),
            updatedAt: Value(DateTime.now()),
          ),
        );
    await _load();
    ref.invalidate(userProfileProvider);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const QadamSectionTitle('Профиль'),
          QadamSoftCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Имя',
                    border: InputBorder.none,
                  ),
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Дата рождения'),
                  subtitle: Text(
                    _profile != null
                        ? '${_profile!.birthDate.day}.${_profile!.birthDate.month}.${_profile!.birthDate.year}'
                        : '—',
                  ),
                  trailing: const Icon(Icons.calendar_today, size: 20),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _profile?.birthDate ?? DateTime(1990),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (picked != null) await _updateBirthDate(picked);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Ожидаемый возраст',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: AppConstants.lifeExpectancyOptions
                      .map((e) => ButtonSegment(value: e, label: Text('$e')))
                      .toList(),
                  selected: {_profile?.lifeExpectancy ?? 80},
                  onSelectionChanged: (s) => _updateLifeExpectancy(s.first),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Город',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const QadamSectionTitle('Геолокация'),
          QadamSoftCard(
            child: SwitchListTile(
              title: const Text('Использовать GPS'),
              subtitle: const Text('Иначе — координаты города'),
              value: _profile?.useGeolocation ?? false,
              onChanged: _updateGeolocation,
            ),
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              'Дополнительно',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: const Text('Метод расчёта намаза'),
            children: [
              QadamSoftCard(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: AppConstants.calculationMethods
                      .map(
                        (m) => RadioListTile<String>(
                          title: Text(m, style: const TextStyle(fontSize: 14)),
                          value: m,
                          groupValue: _profile?.calculationMethod,
                          onChanged: (v) => _updatePrayerMethod(v!),
                          dense: true,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              QadamSoftCard(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        'Мазхаб для Аср',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    ...AppConstants.asrMadhabOptions.map(
                      (m) => RadioListTile<String>(
                        title: Text(m, style: const TextStyle(fontSize: 14)),
                        value: m,
                        groupValue: _profile?.asrMadhab,
                        onChanged: (v) => _updateAsrMadhab(v!),
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

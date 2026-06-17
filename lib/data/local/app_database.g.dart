// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _birthDateMeta =
      const VerificationMeta('birthDate');
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
      'birth_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lifeExpectancyMeta =
      const VerificationMeta('lifeExpectancy');
  @override
  late final GeneratedColumn<int> lifeExpectancy = GeneratedColumn<int>(
      'life_expectancy', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _useGeolocationMeta =
      const VerificationMeta('useGeolocation');
  @override
  late final GeneratedColumn<bool> useGeolocation = GeneratedColumn<bool>(
      'use_geolocation', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("use_geolocation" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _calculationMethodMeta =
      const VerificationMeta('calculationMethod');
  @override
  late final GeneratedColumn<String> calculationMethod =
      GeneratedColumn<String>('calculation_method', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _asrMadhabMeta =
      const VerificationMeta('asrMadhab');
  @override
  late final GeneratedColumn<String> asrMadhab = GeneratedColumn<String>(
      'asr_madhab', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
      'onboarding_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("onboarding_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        birthDate,
        lifeExpectancy,
        city,
        latitude,
        longitude,
        useGeolocation,
        calculationMethod,
        asrMadhab,
        onboardingCompleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(_birthDateMeta,
          birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta));
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('life_expectancy')) {
      context.handle(
          _lifeExpectancyMeta,
          lifeExpectancy.isAcceptableOrUnknown(
              data['life_expectancy']!, _lifeExpectancyMeta));
    } else if (isInserting) {
      context.missing(_lifeExpectancyMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('use_geolocation')) {
      context.handle(
          _useGeolocationMeta,
          useGeolocation.isAcceptableOrUnknown(
              data['use_geolocation']!, _useGeolocationMeta));
    }
    if (data.containsKey('calculation_method')) {
      context.handle(
          _calculationMethodMeta,
          calculationMethod.isAcceptableOrUnknown(
              data['calculation_method']!, _calculationMethodMeta));
    } else if (isInserting) {
      context.missing(_calculationMethodMeta);
    }
    if (data.containsKey('asr_madhab')) {
      context.handle(_asrMadhabMeta,
          asrMadhab.isAcceptableOrUnknown(data['asr_madhab']!, _asrMadhabMeta));
    } else if (isInserting) {
      context.missing(_asrMadhabMeta);
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
          _onboardingCompletedMeta,
          onboardingCompleted.isAcceptableOrUnknown(
              data['onboarding_completed']!, _onboardingCompletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      birthDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birth_date'])!,
      lifeExpectancy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}life_expectancy'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      useGeolocation: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}use_geolocation'])!,
      calculationMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}calculation_method'])!,
      asrMadhab: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}asr_madhab'])!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}onboarding_completed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String name;
  final DateTime birthDate;
  final int lifeExpectancy;
  final String city;
  final double? latitude;
  final double? longitude;
  final bool useGeolocation;
  final String calculationMethod;
  final String asrMadhab;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfile(
      {required this.id,
      required this.name,
      required this.birthDate,
      required this.lifeExpectancy,
      required this.city,
      this.latitude,
      this.longitude,
      required this.useGeolocation,
      required this.calculationMethod,
      required this.asrMadhab,
      required this.onboardingCompleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['life_expectancy'] = Variable<int>(lifeExpectancy);
    map['city'] = Variable<String>(city);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['use_geolocation'] = Variable<bool>(useGeolocation);
    map['calculation_method'] = Variable<String>(calculationMethod);
    map['asr_madhab'] = Variable<String>(asrMadhab);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: Value(name),
      birthDate: Value(birthDate),
      lifeExpectancy: Value(lifeExpectancy),
      city: Value(city),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      useGeolocation: Value(useGeolocation),
      calculationMethod: Value(calculationMethod),
      asrMadhab: Value(asrMadhab),
      onboardingCompleted: Value(onboardingCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      lifeExpectancy: serializer.fromJson<int>(json['lifeExpectancy']),
      city: serializer.fromJson<String>(json['city']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      useGeolocation: serializer.fromJson<bool>(json['useGeolocation']),
      calculationMethod: serializer.fromJson<String>(json['calculationMethod']),
      asrMadhab: serializer.fromJson<String>(json['asrMadhab']),
      onboardingCompleted:
          serializer.fromJson<bool>(json['onboardingCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'lifeExpectancy': serializer.toJson<int>(lifeExpectancy),
      'city': serializer.toJson<String>(city),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'useGeolocation': serializer.toJson<bool>(useGeolocation),
      'calculationMethod': serializer.toJson<String>(calculationMethod),
      'asrMadhab': serializer.toJson<String>(asrMadhab),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfile copyWith(
          {int? id,
          String? name,
          DateTime? birthDate,
          int? lifeExpectancy,
          String? city,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          bool? useGeolocation,
          String? calculationMethod,
          String? asrMadhab,
          bool? onboardingCompleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UserProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        lifeExpectancy: lifeExpectancy ?? this.lifeExpectancy,
        city: city ?? this.city,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        useGeolocation: useGeolocation ?? this.useGeolocation,
        calculationMethod: calculationMethod ?? this.calculationMethod,
        asrMadhab: asrMadhab ?? this.asrMadhab,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      lifeExpectancy: data.lifeExpectancy.present
          ? data.lifeExpectancy.value
          : this.lifeExpectancy,
      city: data.city.present ? data.city.value : this.city,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      useGeolocation: data.useGeolocation.present
          ? data.useGeolocation.value
          : this.useGeolocation,
      calculationMethod: data.calculationMethod.present
          ? data.calculationMethod.value
          : this.calculationMethod,
      asrMadhab: data.asrMadhab.present ? data.asrMadhab.value : this.asrMadhab,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('lifeExpectancy: $lifeExpectancy, ')
          ..write('city: $city, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('useGeolocation: $useGeolocation, ')
          ..write('calculationMethod: $calculationMethod, ')
          ..write('asrMadhab: $asrMadhab, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      birthDate,
      lifeExpectancy,
      city,
      latitude,
      longitude,
      useGeolocation,
      calculationMethod,
      asrMadhab,
      onboardingCompleted,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          other.lifeExpectancy == this.lifeExpectancy &&
          other.city == this.city &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.useGeolocation == this.useGeolocation &&
          other.calculationMethod == this.calculationMethod &&
          other.asrMadhab == this.asrMadhab &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> birthDate;
  final Value<int> lifeExpectancy;
  final Value<String> city;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> useGeolocation;
  final Value<String> calculationMethod;
  final Value<String> asrMadhab;
  final Value<bool> onboardingCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.lifeExpectancy = const Value.absent(),
    this.city = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.useGeolocation = const Value.absent(),
    this.calculationMethod = const Value.absent(),
    this.asrMadhab = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime birthDate,
    required int lifeExpectancy,
    required String city,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.useGeolocation = const Value.absent(),
    required String calculationMethod,
    required String asrMadhab,
    this.onboardingCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        birthDate = Value(birthDate),
        lifeExpectancy = Value(lifeExpectancy),
        city = Value(city),
        calculationMethod = Value(calculationMethod),
        asrMadhab = Value(asrMadhab),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? birthDate,
    Expression<int>? lifeExpectancy,
    Expression<String>? city,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? useGeolocation,
    Expression<String>? calculationMethod,
    Expression<String>? asrMadhab,
    Expression<bool>? onboardingCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (lifeExpectancy != null) 'life_expectancy': lifeExpectancy,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (useGeolocation != null) 'use_geolocation': useGeolocation,
      if (calculationMethod != null) 'calculation_method': calculationMethod,
      if (asrMadhab != null) 'asr_madhab': asrMadhab,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? birthDate,
      Value<int>? lifeExpectancy,
      Value<String>? city,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<bool>? useGeolocation,
      Value<String>? calculationMethod,
      Value<String>? asrMadhab,
      Value<bool>? onboardingCompleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      lifeExpectancy: lifeExpectancy ?? this.lifeExpectancy,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      useGeolocation: useGeolocation ?? this.useGeolocation,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      asrMadhab: asrMadhab ?? this.asrMadhab,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (lifeExpectancy.present) {
      map['life_expectancy'] = Variable<int>(lifeExpectancy.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (useGeolocation.present) {
      map['use_geolocation'] = Variable<bool>(useGeolocation.value);
    }
    if (calculationMethod.present) {
      map['calculation_method'] = Variable<String>(calculationMethod.value);
    }
    if (asrMadhab.present) {
      map['asr_madhab'] = Variable<String>(asrMadhab.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('lifeExpectancy: $lifeExpectancy, ')
          ..write('city: $city, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('useGeolocation: $useGeolocation, ')
          ..write('calculationMethod: $calculationMethod, ')
          ..write('asrMadhab: $asrMadhab, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PrayerSettingsTable extends PrayerSettings
    with TableInfo<$PrayerSettingsTable, PrayerSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _prayerKeyMeta =
      const VerificationMeta('prayerKey');
  @override
  late final GeneratedColumn<String> prayerKey = GeneratedColumn<String>(
      'prayer_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isObligatoryMeta =
      const VerificationMeta('isObligatory');
  @override
  late final GeneratedColumn<bool> isObligatory = GeneratedColumn<bool>(
      'is_obligatory', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_obligatory" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, prayerKey, title, isActive, isObligatory, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_settings';
  @override
  VerificationContext validateIntegrity(Insertable<PrayerSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prayer_key')) {
      context.handle(_prayerKeyMeta,
          prayerKey.isAcceptableOrUnknown(data['prayer_key']!, _prayerKeyMeta));
    } else if (isInserting) {
      context.missing(_prayerKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_obligatory')) {
      context.handle(
          _isObligatoryMeta,
          isObligatory.isAcceptableOrUnknown(
              data['is_obligatory']!, _isObligatoryMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrayerSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      prayerKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prayer_key'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isObligatory: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_obligatory'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $PrayerSettingsTable createAlias(String alias) {
    return $PrayerSettingsTable(attachedDatabase, alias);
  }
}

class PrayerSetting extends DataClass implements Insertable<PrayerSetting> {
  final int id;
  final String prayerKey;
  final String title;
  final bool isActive;
  final bool isObligatory;
  final int sortOrder;
  const PrayerSetting(
      {required this.id,
      required this.prayerKey,
      required this.title,
      required this.isActive,
      required this.isObligatory,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prayer_key'] = Variable<String>(prayerKey);
    map['title'] = Variable<String>(title);
    map['is_active'] = Variable<bool>(isActive);
    map['is_obligatory'] = Variable<bool>(isObligatory);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  PrayerSettingsCompanion toCompanion(bool nullToAbsent) {
    return PrayerSettingsCompanion(
      id: Value(id),
      prayerKey: Value(prayerKey),
      title: Value(title),
      isActive: Value(isActive),
      isObligatory: Value(isObligatory),
      sortOrder: Value(sortOrder),
    );
  }

  factory PrayerSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerSetting(
      id: serializer.fromJson<int>(json['id']),
      prayerKey: serializer.fromJson<String>(json['prayerKey']),
      title: serializer.fromJson<String>(json['title']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isObligatory: serializer.fromJson<bool>(json['isObligatory']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prayerKey': serializer.toJson<String>(prayerKey),
      'title': serializer.toJson<String>(title),
      'isActive': serializer.toJson<bool>(isActive),
      'isObligatory': serializer.toJson<bool>(isObligatory),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  PrayerSetting copyWith(
          {int? id,
          String? prayerKey,
          String? title,
          bool? isActive,
          bool? isObligatory,
          int? sortOrder}) =>
      PrayerSetting(
        id: id ?? this.id,
        prayerKey: prayerKey ?? this.prayerKey,
        title: title ?? this.title,
        isActive: isActive ?? this.isActive,
        isObligatory: isObligatory ?? this.isObligatory,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  PrayerSetting copyWithCompanion(PrayerSettingsCompanion data) {
    return PrayerSetting(
      id: data.id.present ? data.id.value : this.id,
      prayerKey: data.prayerKey.present ? data.prayerKey.value : this.prayerKey,
      title: data.title.present ? data.title.value : this.title,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isObligatory: data.isObligatory.present
          ? data.isObligatory.value
          : this.isObligatory,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerSetting(')
          ..write('id: $id, ')
          ..write('prayerKey: $prayerKey, ')
          ..write('title: $title, ')
          ..write('isActive: $isActive, ')
          ..write('isObligatory: $isObligatory, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, prayerKey, title, isActive, isObligatory, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerSetting &&
          other.id == this.id &&
          other.prayerKey == this.prayerKey &&
          other.title == this.title &&
          other.isActive == this.isActive &&
          other.isObligatory == this.isObligatory &&
          other.sortOrder == this.sortOrder);
}

class PrayerSettingsCompanion extends UpdateCompanion<PrayerSetting> {
  final Value<int> id;
  final Value<String> prayerKey;
  final Value<String> title;
  final Value<bool> isActive;
  final Value<bool> isObligatory;
  final Value<int> sortOrder;
  const PrayerSettingsCompanion({
    this.id = const Value.absent(),
    this.prayerKey = const Value.absent(),
    this.title = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isObligatory = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  PrayerSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String prayerKey,
    required String title,
    this.isActive = const Value.absent(),
    this.isObligatory = const Value.absent(),
    required int sortOrder,
  })  : prayerKey = Value(prayerKey),
        title = Value(title),
        sortOrder = Value(sortOrder);
  static Insertable<PrayerSetting> custom({
    Expression<int>? id,
    Expression<String>? prayerKey,
    Expression<String>? title,
    Expression<bool>? isActive,
    Expression<bool>? isObligatory,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prayerKey != null) 'prayer_key': prayerKey,
      if (title != null) 'title': title,
      if (isActive != null) 'is_active': isActive,
      if (isObligatory != null) 'is_obligatory': isObligatory,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  PrayerSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? prayerKey,
      Value<String>? title,
      Value<bool>? isActive,
      Value<bool>? isObligatory,
      Value<int>? sortOrder}) {
    return PrayerSettingsCompanion(
      id: id ?? this.id,
      prayerKey: prayerKey ?? this.prayerKey,
      title: title ?? this.title,
      isActive: isActive ?? this.isActive,
      isObligatory: isObligatory ?? this.isObligatory,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prayerKey.present) {
      map['prayer_key'] = Variable<String>(prayerKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isObligatory.present) {
      map['is_obligatory'] = Variable<bool>(isObligatory.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerSettingsCompanion(')
          ..write('id: $id, ')
          ..write('prayerKey: $prayerKey, ')
          ..write('title: $title, ')
          ..write('isActive: $isActive, ')
          ..write('isObligatory: $isObligatory, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $HabitSettingsTable extends HabitSettings
    with TableInfo<$HabitSettingsTable, HabitSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _habitKeyMeta =
      const VerificationMeta('habitKey');
  @override
  late final GeneratedColumn<String> habitKey = GeneratedColumn<String>(
      'habit_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _customTitleMeta =
      const VerificationMeta('customTitle');
  @override
  late final GeneratedColumn<String> customTitle = GeneratedColumn<String>(
      'custom_title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, habitKey, title, isActive, sortOrder, customTitle];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_settings';
  @override
  VerificationContext validateIntegrity(Insertable<HabitSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_key')) {
      context.handle(_habitKeyMeta,
          habitKey.isAcceptableOrUnknown(data['habit_key']!, _habitKeyMeta));
    } else if (isInserting) {
      context.missing(_habitKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('custom_title')) {
      context.handle(
          _customTitleMeta,
          customTitle.isAcceptableOrUnknown(
              data['custom_title']!, _customTitleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      habitKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_key'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      customTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_title']),
    );
  }

  @override
  $HabitSettingsTable createAlias(String alias) {
    return $HabitSettingsTable(attachedDatabase, alias);
  }
}

class HabitSetting extends DataClass implements Insertable<HabitSetting> {
  final int id;
  final String habitKey;
  final String title;
  final bool isActive;
  final int sortOrder;
  final String? customTitle;
  const HabitSetting(
      {required this.id,
      required this.habitKey,
      required this.title,
      required this.isActive,
      required this.sortOrder,
      this.customTitle});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_key'] = Variable<String>(habitKey);
    map['title'] = Variable<String>(title);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || customTitle != null) {
      map['custom_title'] = Variable<String>(customTitle);
    }
    return map;
  }

  HabitSettingsCompanion toCompanion(bool nullToAbsent) {
    return HabitSettingsCompanion(
      id: Value(id),
      habitKey: Value(habitKey),
      title: Value(title),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
      customTitle: customTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(customTitle),
    );
  }

  factory HabitSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitSetting(
      id: serializer.fromJson<int>(json['id']),
      habitKey: serializer.fromJson<String>(json['habitKey']),
      title: serializer.fromJson<String>(json['title']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      customTitle: serializer.fromJson<String?>(json['customTitle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitKey': serializer.toJson<String>(habitKey),
      'title': serializer.toJson<String>(title),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'customTitle': serializer.toJson<String?>(customTitle),
    };
  }

  HabitSetting copyWith(
          {int? id,
          String? habitKey,
          String? title,
          bool? isActive,
          int? sortOrder,
          Value<String?> customTitle = const Value.absent()}) =>
      HabitSetting(
        id: id ?? this.id,
        habitKey: habitKey ?? this.habitKey,
        title: title ?? this.title,
        isActive: isActive ?? this.isActive,
        sortOrder: sortOrder ?? this.sortOrder,
        customTitle: customTitle.present ? customTitle.value : this.customTitle,
      );
  HabitSetting copyWithCompanion(HabitSettingsCompanion data) {
    return HabitSetting(
      id: data.id.present ? data.id.value : this.id,
      habitKey: data.habitKey.present ? data.habitKey.value : this.habitKey,
      title: data.title.present ? data.title.value : this.title,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      customTitle:
          data.customTitle.present ? data.customTitle.value : this.customTitle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitSetting(')
          ..write('id: $id, ')
          ..write('habitKey: $habitKey, ')
          ..write('title: $title, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('customTitle: $customTitle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, habitKey, title, isActive, sortOrder, customTitle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitSetting &&
          other.id == this.id &&
          other.habitKey == this.habitKey &&
          other.title == this.title &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder &&
          other.customTitle == this.customTitle);
}

class HabitSettingsCompanion extends UpdateCompanion<HabitSetting> {
  final Value<int> id;
  final Value<String> habitKey;
  final Value<String> title;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<String?> customTitle;
  const HabitSettingsCompanion({
    this.id = const Value.absent(),
    this.habitKey = const Value.absent(),
    this.title = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.customTitle = const Value.absent(),
  });
  HabitSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String habitKey,
    required String title,
    this.isActive = const Value.absent(),
    required int sortOrder,
    this.customTitle = const Value.absent(),
  })  : habitKey = Value(habitKey),
        title = Value(title),
        sortOrder = Value(sortOrder);
  static Insertable<HabitSetting> custom({
    Expression<int>? id,
    Expression<String>? habitKey,
    Expression<String>? title,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<String>? customTitle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitKey != null) 'habit_key': habitKey,
      if (title != null) 'title': title,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (customTitle != null) 'custom_title': customTitle,
    });
  }

  HabitSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? habitKey,
      Value<String>? title,
      Value<bool>? isActive,
      Value<int>? sortOrder,
      Value<String?>? customTitle}) {
    return HabitSettingsCompanion(
      id: id ?? this.id,
      habitKey: habitKey ?? this.habitKey,
      title: title ?? this.title,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      customTitle: customTitle ?? this.customTitle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitKey.present) {
      map['habit_key'] = Variable<String>(habitKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (customTitle.present) {
      map['custom_title'] = Variable<String>(customTitle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitSettingsCompanion(')
          ..write('id: $id, ')
          ..write('habitKey: $habitKey, ')
          ..write('title: $title, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('customTitle: $customTitle')
          ..write(')'))
        .toString();
  }
}

class $DayRecordsTable extends DayRecords
    with TableInfo<$DayRecordsTable, DayRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _moodPercentMeta =
      const VerificationMeta('moodPercent');
  @override
  late final GeneratedColumn<int> moodPercent = GeneratedColumn<int>(
      'mood_percent', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quranReadMeta =
      const VerificationMeta('quranRead');
  @override
  late final GeneratedColumn<bool> quranRead = GeneratedColumn<bool>(
      'quran_read', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("quran_read" IN (0, 1))'));
  static const VerificationMeta _sadaqaDoneMeta =
      const VerificationMeta('sadaqaDone');
  @override
  late final GeneratedColumn<bool> sadaqaDone = GeneratedColumn<bool>(
      'sadaqa_done', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sadaqa_done" IN (0, 1))'));
  static const VerificationMeta _zikrDoneMeta =
      const VerificationMeta('zikrDone');
  @override
  late final GeneratedColumn<bool> zikrDone = GeneratedColumn<bool>(
      'zikr_done', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("zikr_done" IN (0, 1))'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        moodPercent,
        quranRead,
        sadaqaDone,
        zikrDone,
        note,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_records';
  @override
  VerificationContext validateIntegrity(Insertable<DayRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mood_percent')) {
      context.handle(
          _moodPercentMeta,
          moodPercent.isAcceptableOrUnknown(
              data['mood_percent']!, _moodPercentMeta));
    }
    if (data.containsKey('quran_read')) {
      context.handle(_quranReadMeta,
          quranRead.isAcceptableOrUnknown(data['quran_read']!, _quranReadMeta));
    }
    if (data.containsKey('sadaqa_done')) {
      context.handle(
          _sadaqaDoneMeta,
          sadaqaDone.isAcceptableOrUnknown(
              data['sadaqa_done']!, _sadaqaDoneMeta));
    }
    if (data.containsKey('zikr_done')) {
      context.handle(_zikrDoneMeta,
          zikrDone.isAcceptableOrUnknown(data['zikr_done']!, _zikrDoneMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      moodPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mood_percent']),
      quranRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}quran_read']),
      sadaqaDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}sadaqa_done']),
      zikrDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}zikr_done']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DayRecordsTable createAlias(String alias) {
    return $DayRecordsTable(attachedDatabase, alias);
  }
}

class DayRecord extends DataClass implements Insertable<DayRecord> {
  final int id;
  final String date;
  final int? moodPercent;
  final bool? quranRead;
  final bool? sadaqaDone;
  final bool? zikrDone;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DayRecord(
      {required this.id,
      required this.date,
      this.moodPercent,
      this.quranRead,
      this.sadaqaDone,
      this.zikrDone,
      this.note,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || moodPercent != null) {
      map['mood_percent'] = Variable<int>(moodPercent);
    }
    if (!nullToAbsent || quranRead != null) {
      map['quran_read'] = Variable<bool>(quranRead);
    }
    if (!nullToAbsent || sadaqaDone != null) {
      map['sadaqa_done'] = Variable<bool>(sadaqaDone);
    }
    if (!nullToAbsent || zikrDone != null) {
      map['zikr_done'] = Variable<bool>(zikrDone);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DayRecordsCompanion toCompanion(bool nullToAbsent) {
    return DayRecordsCompanion(
      id: Value(id),
      date: Value(date),
      moodPercent: moodPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(moodPercent),
      quranRead: quranRead == null && nullToAbsent
          ? const Value.absent()
          : Value(quranRead),
      sadaqaDone: sadaqaDone == null && nullToAbsent
          ? const Value.absent()
          : Value(sadaqaDone),
      zikrDone: zikrDone == null && nullToAbsent
          ? const Value.absent()
          : Value(zikrDone),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DayRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayRecord(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      moodPercent: serializer.fromJson<int?>(json['moodPercent']),
      quranRead: serializer.fromJson<bool?>(json['quranRead']),
      sadaqaDone: serializer.fromJson<bool?>(json['sadaqaDone']),
      zikrDone: serializer.fromJson<bool?>(json['zikrDone']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'moodPercent': serializer.toJson<int?>(moodPercent),
      'quranRead': serializer.toJson<bool?>(quranRead),
      'sadaqaDone': serializer.toJson<bool?>(sadaqaDone),
      'zikrDone': serializer.toJson<bool?>(zikrDone),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DayRecord copyWith(
          {int? id,
          String? date,
          Value<int?> moodPercent = const Value.absent(),
          Value<bool?> quranRead = const Value.absent(),
          Value<bool?> sadaqaDone = const Value.absent(),
          Value<bool?> zikrDone = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DayRecord(
        id: id ?? this.id,
        date: date ?? this.date,
        moodPercent: moodPercent.present ? moodPercent.value : this.moodPercent,
        quranRead: quranRead.present ? quranRead.value : this.quranRead,
        sadaqaDone: sadaqaDone.present ? sadaqaDone.value : this.sadaqaDone,
        zikrDone: zikrDone.present ? zikrDone.value : this.zikrDone,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DayRecord copyWithCompanion(DayRecordsCompanion data) {
    return DayRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      moodPercent:
          data.moodPercent.present ? data.moodPercent.value : this.moodPercent,
      quranRead: data.quranRead.present ? data.quranRead.value : this.quranRead,
      sadaqaDone:
          data.sadaqaDone.present ? data.sadaqaDone.value : this.sadaqaDone,
      zikrDone: data.zikrDone.present ? data.zikrDone.value : this.zikrDone,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('moodPercent: $moodPercent, ')
          ..write('quranRead: $quranRead, ')
          ..write('sadaqaDone: $sadaqaDone, ')
          ..write('zikrDone: $zikrDone, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, moodPercent, quranRead, sadaqaDone,
      zikrDone, note, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.moodPercent == this.moodPercent &&
          other.quranRead == this.quranRead &&
          other.sadaqaDone == this.sadaqaDone &&
          other.zikrDone == this.zikrDone &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DayRecordsCompanion extends UpdateCompanion<DayRecord> {
  final Value<int> id;
  final Value<String> date;
  final Value<int?> moodPercent;
  final Value<bool?> quranRead;
  final Value<bool?> sadaqaDone;
  final Value<bool?> zikrDone;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DayRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.moodPercent = const Value.absent(),
    this.quranRead = const Value.absent(),
    this.sadaqaDone = const Value.absent(),
    this.zikrDone = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DayRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.moodPercent = const Value.absent(),
    this.quranRead = const Value.absent(),
    this.sadaqaDone = const Value.absent(),
    this.zikrDone = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : date = Value(date),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DayRecord> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? moodPercent,
    Expression<bool>? quranRead,
    Expression<bool>? sadaqaDone,
    Expression<bool>? zikrDone,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (moodPercent != null) 'mood_percent': moodPercent,
      if (quranRead != null) 'quran_read': quranRead,
      if (sadaqaDone != null) 'sadaqa_done': sadaqaDone,
      if (zikrDone != null) 'zikr_done': zikrDone,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DayRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<int?>? moodPercent,
      Value<bool?>? quranRead,
      Value<bool?>? sadaqaDone,
      Value<bool?>? zikrDone,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DayRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      moodPercent: moodPercent ?? this.moodPercent,
      quranRead: quranRead ?? this.quranRead,
      sadaqaDone: sadaqaDone ?? this.sadaqaDone,
      zikrDone: zikrDone ?? this.zikrDone,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (moodPercent.present) {
      map['mood_percent'] = Variable<int>(moodPercent.value);
    }
    if (quranRead.present) {
      map['quran_read'] = Variable<bool>(quranRead.value);
    }
    if (sadaqaDone.present) {
      map['sadaqa_done'] = Variable<bool>(sadaqaDone.value);
    }
    if (zikrDone.present) {
      map['zikr_done'] = Variable<bool>(zikrDone.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('moodPercent: $moodPercent, ')
          ..write('quranRead: $quranRead, ')
          ..write('sadaqaDone: $sadaqaDone, ')
          ..write('zikrDone: $zikrDone, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PrayerRecordsTable extends PrayerRecords
    with TableInfo<$PrayerRecordsTable, PrayerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dayRecordIdMeta =
      const VerificationMeta('dayRecordId');
  @override
  late final GeneratedColumn<int> dayRecordId = GeneratedColumn<int>(
      'day_record_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES day_records (id)'));
  static const VerificationMeta _prayerKeyMeta =
      const VerificationMeta('prayerKey');
  @override
  late final GeneratedColumn<String> prayerKey = GeneratedColumn<String>(
      'prayer_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _prayedMeta = const VerificationMeta('prayed');
  @override
  late final GeneratedColumn<bool> prayed = GeneratedColumn<bool>(
      'prayed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("prayed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _qazaPrayedMeta =
      const VerificationMeta('qazaPrayed');
  @override
  late final GeneratedColumn<bool> qazaPrayed = GeneratedColumn<bool>(
      'qaza_prayed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("qaza_prayed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _prayedAtMeta =
      const VerificationMeta('prayedAt');
  @override
  late final GeneratedColumn<DateTime> prayedAt = GeneratedColumn<DateTime>(
      'prayed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dayRecordId,
        prayerKey,
        prayed,
        qazaPrayed,
        prayedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_records';
  @override
  VerificationContext validateIntegrity(Insertable<PrayerRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_record_id')) {
      context.handle(
          _dayRecordIdMeta,
          dayRecordId.isAcceptableOrUnknown(
              data['day_record_id']!, _dayRecordIdMeta));
    } else if (isInserting) {
      context.missing(_dayRecordIdMeta);
    }
    if (data.containsKey('prayer_key')) {
      context.handle(_prayerKeyMeta,
          prayerKey.isAcceptableOrUnknown(data['prayer_key']!, _prayerKeyMeta));
    } else if (isInserting) {
      context.missing(_prayerKeyMeta);
    }
    if (data.containsKey('prayed')) {
      context.handle(_prayedMeta,
          prayed.isAcceptableOrUnknown(data['prayed']!, _prayedMeta));
    }
    if (data.containsKey('qaza_prayed')) {
      context.handle(
          _qazaPrayedMeta,
          qazaPrayed.isAcceptableOrUnknown(
              data['qaza_prayed']!, _qazaPrayedMeta));
    }
    if (data.containsKey('prayed_at')) {
      context.handle(_prayedAtMeta,
          prayedAt.isAcceptableOrUnknown(data['prayed_at']!, _prayedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {dayRecordId, prayerKey},
      ];
  @override
  PrayerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dayRecordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_record_id'])!,
      prayerKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prayer_key'])!,
      prayed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}prayed'])!,
      qazaPrayed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}qaza_prayed'])!,
      prayedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}prayed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PrayerRecordsTable createAlias(String alias) {
    return $PrayerRecordsTable(attachedDatabase, alias);
  }
}

class PrayerRecord extends DataClass implements Insertable<PrayerRecord> {
  final int id;
  final int dayRecordId;
  final String prayerKey;
  final bool prayed;
  final bool qazaPrayed;
  final DateTime? prayedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PrayerRecord(
      {required this.id,
      required this.dayRecordId,
      required this.prayerKey,
      required this.prayed,
      required this.qazaPrayed,
      this.prayedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_record_id'] = Variable<int>(dayRecordId);
    map['prayer_key'] = Variable<String>(prayerKey);
    map['prayed'] = Variable<bool>(prayed);
    map['qaza_prayed'] = Variable<bool>(qazaPrayed);
    if (!nullToAbsent || prayedAt != null) {
      map['prayed_at'] = Variable<DateTime>(prayedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PrayerRecordsCompanion toCompanion(bool nullToAbsent) {
    return PrayerRecordsCompanion(
      id: Value(id),
      dayRecordId: Value(dayRecordId),
      prayerKey: Value(prayerKey),
      prayed: Value(prayed),
      qazaPrayed: Value(qazaPrayed),
      prayedAt: prayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(prayedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PrayerRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerRecord(
      id: serializer.fromJson<int>(json['id']),
      dayRecordId: serializer.fromJson<int>(json['dayRecordId']),
      prayerKey: serializer.fromJson<String>(json['prayerKey']),
      prayed: serializer.fromJson<bool>(json['prayed']),
      qazaPrayed: serializer.fromJson<bool>(json['qazaPrayed']),
      prayedAt: serializer.fromJson<DateTime?>(json['prayedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayRecordId': serializer.toJson<int>(dayRecordId),
      'prayerKey': serializer.toJson<String>(prayerKey),
      'prayed': serializer.toJson<bool>(prayed),
      'qazaPrayed': serializer.toJson<bool>(qazaPrayed),
      'prayedAt': serializer.toJson<DateTime?>(prayedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PrayerRecord copyWith(
          {int? id,
          int? dayRecordId,
          String? prayerKey,
          bool? prayed,
          bool? qazaPrayed,
          Value<DateTime?> prayedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PrayerRecord(
        id: id ?? this.id,
        dayRecordId: dayRecordId ?? this.dayRecordId,
        prayerKey: prayerKey ?? this.prayerKey,
        prayed: prayed ?? this.prayed,
        qazaPrayed: qazaPrayed ?? this.qazaPrayed,
        prayedAt: prayedAt.present ? prayedAt.value : this.prayedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PrayerRecord copyWithCompanion(PrayerRecordsCompanion data) {
    return PrayerRecord(
      id: data.id.present ? data.id.value : this.id,
      dayRecordId:
          data.dayRecordId.present ? data.dayRecordId.value : this.dayRecordId,
      prayerKey: data.prayerKey.present ? data.prayerKey.value : this.prayerKey,
      prayed: data.prayed.present ? data.prayed.value : this.prayed,
      qazaPrayed:
          data.qazaPrayed.present ? data.qazaPrayed.value : this.qazaPrayed,
      prayedAt: data.prayedAt.present ? data.prayedAt.value : this.prayedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerRecord(')
          ..write('id: $id, ')
          ..write('dayRecordId: $dayRecordId, ')
          ..write('prayerKey: $prayerKey, ')
          ..write('prayed: $prayed, ')
          ..write('qazaPrayed: $qazaPrayed, ')
          ..write('prayedAt: $prayedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dayRecordId, prayerKey, prayed,
      qazaPrayed, prayedAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerRecord &&
          other.id == this.id &&
          other.dayRecordId == this.dayRecordId &&
          other.prayerKey == this.prayerKey &&
          other.prayed == this.prayed &&
          other.qazaPrayed == this.qazaPrayed &&
          other.prayedAt == this.prayedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PrayerRecordsCompanion extends UpdateCompanion<PrayerRecord> {
  final Value<int> id;
  final Value<int> dayRecordId;
  final Value<String> prayerKey;
  final Value<bool> prayed;
  final Value<bool> qazaPrayed;
  final Value<DateTime?> prayedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PrayerRecordsCompanion({
    this.id = const Value.absent(),
    this.dayRecordId = const Value.absent(),
    this.prayerKey = const Value.absent(),
    this.prayed = const Value.absent(),
    this.qazaPrayed = const Value.absent(),
    this.prayedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PrayerRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int dayRecordId,
    required String prayerKey,
    this.prayed = const Value.absent(),
    this.qazaPrayed = const Value.absent(),
    this.prayedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : dayRecordId = Value(dayRecordId),
        prayerKey = Value(prayerKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PrayerRecord> custom({
    Expression<int>? id,
    Expression<int>? dayRecordId,
    Expression<String>? prayerKey,
    Expression<bool>? prayed,
    Expression<bool>? qazaPrayed,
    Expression<DateTime>? prayedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayRecordId != null) 'day_record_id': dayRecordId,
      if (prayerKey != null) 'prayer_key': prayerKey,
      if (prayed != null) 'prayed': prayed,
      if (qazaPrayed != null) 'qaza_prayed': qazaPrayed,
      if (prayedAt != null) 'prayed_at': prayedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PrayerRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? dayRecordId,
      Value<String>? prayerKey,
      Value<bool>? prayed,
      Value<bool>? qazaPrayed,
      Value<DateTime?>? prayedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return PrayerRecordsCompanion(
      id: id ?? this.id,
      dayRecordId: dayRecordId ?? this.dayRecordId,
      prayerKey: prayerKey ?? this.prayerKey,
      prayed: prayed ?? this.prayed,
      qazaPrayed: qazaPrayed ?? this.qazaPrayed,
      prayedAt: prayedAt ?? this.prayedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayRecordId.present) {
      map['day_record_id'] = Variable<int>(dayRecordId.value);
    }
    if (prayerKey.present) {
      map['prayer_key'] = Variable<String>(prayerKey.value);
    }
    if (prayed.present) {
      map['prayed'] = Variable<bool>(prayed.value);
    }
    if (qazaPrayed.present) {
      map['qaza_prayed'] = Variable<bool>(qazaPrayed.value);
    }
    if (prayedAt.present) {
      map['prayed_at'] = Variable<DateTime>(prayedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerRecordsCompanion(')
          ..write('id: $id, ')
          ..write('dayRecordId: $dayRecordId, ')
          ..write('prayerKey: $prayerKey, ')
          ..write('prayed: $prayed, ')
          ..write('qazaPrayed: $qazaPrayed, ')
          ..write('prayedAt: $prayedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $HabitRecordsTable extends HabitRecords
    with TableInfo<$HabitRecordsTable, HabitRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dayRecordIdMeta =
      const VerificationMeta('dayRecordId');
  @override
  late final GeneratedColumn<int> dayRecordId = GeneratedColumn<int>(
      'day_record_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES day_records (id)'));
  static const VerificationMeta _habitKeyMeta =
      const VerificationMeta('habitKey');
  @override
  late final GeneratedColumn<String> habitKey = GeneratedColumn<String>(
      'habit_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, dayRecordId, habitKey, completed, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_records';
  @override
  VerificationContext validateIntegrity(Insertable<HabitRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_record_id')) {
      context.handle(
          _dayRecordIdMeta,
          dayRecordId.isAcceptableOrUnknown(
              data['day_record_id']!, _dayRecordIdMeta));
    } else if (isInserting) {
      context.missing(_dayRecordIdMeta);
    }
    if (data.containsKey('habit_key')) {
      context.handle(_habitKeyMeta,
          habitKey.isAcceptableOrUnknown(data['habit_key']!, _habitKeyMeta));
    } else if (isInserting) {
      context.missing(_habitKeyMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {dayRecordId, habitKey},
      ];
  @override
  HabitRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dayRecordId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_record_id'])!,
      habitKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_key'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HabitRecordsTable createAlias(String alias) {
    return $HabitRecordsTable(attachedDatabase, alias);
  }
}

class HabitRecord extends DataClass implements Insertable<HabitRecord> {
  final int id;
  final int dayRecordId;
  final String habitKey;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HabitRecord(
      {required this.id,
      required this.dayRecordId,
      required this.habitKey,
      required this.completed,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_record_id'] = Variable<int>(dayRecordId);
    map['habit_key'] = Variable<String>(habitKey);
    map['completed'] = Variable<bool>(completed);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HabitRecordsCompanion toCompanion(bool nullToAbsent) {
    return HabitRecordsCompanion(
      id: Value(id),
      dayRecordId: Value(dayRecordId),
      habitKey: Value(habitKey),
      completed: Value(completed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HabitRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRecord(
      id: serializer.fromJson<int>(json['id']),
      dayRecordId: serializer.fromJson<int>(json['dayRecordId']),
      habitKey: serializer.fromJson<String>(json['habitKey']),
      completed: serializer.fromJson<bool>(json['completed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayRecordId': serializer.toJson<int>(dayRecordId),
      'habitKey': serializer.toJson<String>(habitKey),
      'completed': serializer.toJson<bool>(completed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HabitRecord copyWith(
          {int? id,
          int? dayRecordId,
          String? habitKey,
          bool? completed,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      HabitRecord(
        id: id ?? this.id,
        dayRecordId: dayRecordId ?? this.dayRecordId,
        habitKey: habitKey ?? this.habitKey,
        completed: completed ?? this.completed,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HabitRecord copyWithCompanion(HabitRecordsCompanion data) {
    return HabitRecord(
      id: data.id.present ? data.id.value : this.id,
      dayRecordId:
          data.dayRecordId.present ? data.dayRecordId.value : this.dayRecordId,
      habitKey: data.habitKey.present ? data.habitKey.value : this.habitKey,
      completed: data.completed.present ? data.completed.value : this.completed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRecord(')
          ..write('id: $id, ')
          ..write('dayRecordId: $dayRecordId, ')
          ..write('habitKey: $habitKey, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayRecordId, habitKey, completed, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRecord &&
          other.id == this.id &&
          other.dayRecordId == this.dayRecordId &&
          other.habitKey == this.habitKey &&
          other.completed == this.completed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HabitRecordsCompanion extends UpdateCompanion<HabitRecord> {
  final Value<int> id;
  final Value<int> dayRecordId;
  final Value<String> habitKey;
  final Value<bool> completed;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const HabitRecordsCompanion({
    this.id = const Value.absent(),
    this.dayRecordId = const Value.absent(),
    this.habitKey = const Value.absent(),
    this.completed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HabitRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int dayRecordId,
    required String habitKey,
    this.completed = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : dayRecordId = Value(dayRecordId),
        habitKey = Value(habitKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<HabitRecord> custom({
    Expression<int>? id,
    Expression<int>? dayRecordId,
    Expression<String>? habitKey,
    Expression<bool>? completed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayRecordId != null) 'day_record_id': dayRecordId,
      if (habitKey != null) 'habit_key': habitKey,
      if (completed != null) 'completed': completed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HabitRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? dayRecordId,
      Value<String>? habitKey,
      Value<bool>? completed,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return HabitRecordsCompanion(
      id: id ?? this.id,
      dayRecordId: dayRecordId ?? this.dayRecordId,
      habitKey: habitKey ?? this.habitKey,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayRecordId.present) {
      map['day_record_id'] = Variable<int>(dayRecordId.value);
    }
    if (habitKey.present) {
      map['habit_key'] = Variable<String>(habitKey.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitRecordsCompanion(')
          ..write('id: $id, ')
          ..write('dayRecordId: $dayRecordId, ')
          ..write('habitKey: $habitKey, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $PrayerSettingsTable prayerSettings = $PrayerSettingsTable(this);
  late final $HabitSettingsTable habitSettings = $HabitSettingsTable(this);
  late final $DayRecordsTable dayRecords = $DayRecordsTable(this);
  late final $PrayerRecordsTable prayerRecords = $PrayerRecordsTable(this);
  late final $HabitRecordsTable habitRecords = $HabitRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userProfiles,
        prayerSettings,
        habitSettings,
        dayRecords,
        prayerRecords,
        habitRecords
      ];
}

typedef $$UserProfilesTableCreateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  required String name,
  required DateTime birthDate,
  required int lifeExpectancy,
  required String city,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<bool> useGeolocation,
  required String calculationMethod,
  required String asrMadhab,
  Value<bool> onboardingCompleted,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$UserProfilesTableUpdateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> birthDate,
  Value<int> lifeExpectancy,
  Value<String> city,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<bool> useGeolocation,
  Value<String> calculationMethod,
  Value<String> asrMadhab,
  Value<bool> onboardingCompleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lifeExpectancy => $composableBuilder(
      column: $table.lifeExpectancy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get useGeolocation => $composableBuilder(
      column: $table.useGeolocation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get calculationMethod => $composableBuilder(
      column: $table.calculationMethod,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get asrMadhab => $composableBuilder(
      column: $table.asrMadhab, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lifeExpectancy => $composableBuilder(
      column: $table.lifeExpectancy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get useGeolocation => $composableBuilder(
      column: $table.useGeolocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get calculationMethod => $composableBuilder(
      column: $table.calculationMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get asrMadhab => $composableBuilder(
      column: $table.asrMadhab, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<int> get lifeExpectancy => $composableBuilder(
      column: $table.lifeExpectancy, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get useGeolocation => $composableBuilder(
      column: $table.useGeolocation, builder: (column) => column);

  GeneratedColumn<String> get calculationMethod => $composableBuilder(
      column: $table.calculationMethod, builder: (column) => column);

  GeneratedColumn<String> get asrMadhab =>
      $composableBuilder(column: $table.asrMadhab, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()> {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> birthDate = const Value.absent(),
            Value<int> lifeExpectancy = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<bool> useGeolocation = const Value.absent(),
            Value<String> calculationMethod = const Value.absent(),
            Value<String> asrMadhab = const Value.absent(),
            Value<bool> onboardingCompleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UserProfilesCompanion(
            id: id,
            name: name,
            birthDate: birthDate,
            lifeExpectancy: lifeExpectancy,
            city: city,
            latitude: latitude,
            longitude: longitude,
            useGeolocation: useGeolocation,
            calculationMethod: calculationMethod,
            asrMadhab: asrMadhab,
            onboardingCompleted: onboardingCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required DateTime birthDate,
            required int lifeExpectancy,
            required String city,
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<bool> useGeolocation = const Value.absent(),
            required String calculationMethod,
            required String asrMadhab,
            Value<bool> onboardingCompleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              UserProfilesCompanion.insert(
            id: id,
            name: name,
            birthDate: birthDate,
            lifeExpectancy: lifeExpectancy,
            city: city,
            latitude: latitude,
            longitude: longitude,
            useGeolocation: useGeolocation,
            calculationMethod: calculationMethod,
            asrMadhab: asrMadhab,
            onboardingCompleted: onboardingCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()>;
typedef $$PrayerSettingsTableCreateCompanionBuilder = PrayerSettingsCompanion
    Function({
  Value<int> id,
  required String prayerKey,
  required String title,
  Value<bool> isActive,
  Value<bool> isObligatory,
  required int sortOrder,
});
typedef $$PrayerSettingsTableUpdateCompanionBuilder = PrayerSettingsCompanion
    Function({
  Value<int> id,
  Value<String> prayerKey,
  Value<String> title,
  Value<bool> isActive,
  Value<bool> isObligatory,
  Value<int> sortOrder,
});

class $$PrayerSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerSettingsTable> {
  $$PrayerSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prayerKey => $composableBuilder(
      column: $table.prayerKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isObligatory => $composableBuilder(
      column: $table.isObligatory, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$PrayerSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerSettingsTable> {
  $$PrayerSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prayerKey => $composableBuilder(
      column: $table.prayerKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isObligatory => $composableBuilder(
      column: $table.isObligatory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$PrayerSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerSettingsTable> {
  $$PrayerSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prayerKey =>
      $composableBuilder(column: $table.prayerKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isObligatory => $composableBuilder(
      column: $table.isObligatory, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$PrayerSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrayerSettingsTable,
    PrayerSetting,
    $$PrayerSettingsTableFilterComposer,
    $$PrayerSettingsTableOrderingComposer,
    $$PrayerSettingsTableAnnotationComposer,
    $$PrayerSettingsTableCreateCompanionBuilder,
    $$PrayerSettingsTableUpdateCompanionBuilder,
    (
      PrayerSetting,
      BaseReferences<_$AppDatabase, $PrayerSettingsTable, PrayerSetting>
    ),
    PrayerSetting,
    PrefetchHooks Function()> {
  $$PrayerSettingsTableTableManager(
      _$AppDatabase db, $PrayerSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> prayerKey = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isObligatory = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              PrayerSettingsCompanion(
            id: id,
            prayerKey: prayerKey,
            title: title,
            isActive: isActive,
            isObligatory: isObligatory,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String prayerKey,
            required String title,
            Value<bool> isActive = const Value.absent(),
            Value<bool> isObligatory = const Value.absent(),
            required int sortOrder,
          }) =>
              PrayerSettingsCompanion.insert(
            id: id,
            prayerKey: prayerKey,
            title: title,
            isActive: isActive,
            isObligatory: isObligatory,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PrayerSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PrayerSettingsTable,
    PrayerSetting,
    $$PrayerSettingsTableFilterComposer,
    $$PrayerSettingsTableOrderingComposer,
    $$PrayerSettingsTableAnnotationComposer,
    $$PrayerSettingsTableCreateCompanionBuilder,
    $$PrayerSettingsTableUpdateCompanionBuilder,
    (
      PrayerSetting,
      BaseReferences<_$AppDatabase, $PrayerSettingsTable, PrayerSetting>
    ),
    PrayerSetting,
    PrefetchHooks Function()>;
typedef $$HabitSettingsTableCreateCompanionBuilder = HabitSettingsCompanion
    Function({
  Value<int> id,
  required String habitKey,
  required String title,
  Value<bool> isActive,
  required int sortOrder,
  Value<String?> customTitle,
});
typedef $$HabitSettingsTableUpdateCompanionBuilder = HabitSettingsCompanion
    Function({
  Value<int> id,
  Value<String> habitKey,
  Value<String> title,
  Value<bool> isActive,
  Value<int> sortOrder,
  Value<String?> customTitle,
});

class $$HabitSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitSettingsTable> {
  $$HabitSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get habitKey => $composableBuilder(
      column: $table.habitKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnFilters(column));
}

class $$HabitSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitSettingsTable> {
  $$HabitSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get habitKey => $composableBuilder(
      column: $table.habitKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnOrderings(column));
}

class $$HabitSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitSettingsTable> {
  $$HabitSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitKey =>
      $composableBuilder(column: $table.habitKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => column);
}

class $$HabitSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitSettingsTable,
    HabitSetting,
    $$HabitSettingsTableFilterComposer,
    $$HabitSettingsTableOrderingComposer,
    $$HabitSettingsTableAnnotationComposer,
    $$HabitSettingsTableCreateCompanionBuilder,
    $$HabitSettingsTableUpdateCompanionBuilder,
    (
      HabitSetting,
      BaseReferences<_$AppDatabase, $HabitSettingsTable, HabitSetting>
    ),
    HabitSetting,
    PrefetchHooks Function()> {
  $$HabitSettingsTableTableManager(_$AppDatabase db, $HabitSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> habitKey = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> customTitle = const Value.absent(),
          }) =>
              HabitSettingsCompanion(
            id: id,
            habitKey: habitKey,
            title: title,
            isActive: isActive,
            sortOrder: sortOrder,
            customTitle: customTitle,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String habitKey,
            required String title,
            Value<bool> isActive = const Value.absent(),
            required int sortOrder,
            Value<String?> customTitle = const Value.absent(),
          }) =>
              HabitSettingsCompanion.insert(
            id: id,
            habitKey: habitKey,
            title: title,
            isActive: isActive,
            sortOrder: sortOrder,
            customTitle: customTitle,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HabitSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitSettingsTable,
    HabitSetting,
    $$HabitSettingsTableFilterComposer,
    $$HabitSettingsTableOrderingComposer,
    $$HabitSettingsTableAnnotationComposer,
    $$HabitSettingsTableCreateCompanionBuilder,
    $$HabitSettingsTableUpdateCompanionBuilder,
    (
      HabitSetting,
      BaseReferences<_$AppDatabase, $HabitSettingsTable, HabitSetting>
    ),
    HabitSetting,
    PrefetchHooks Function()>;
typedef $$DayRecordsTableCreateCompanionBuilder = DayRecordsCompanion Function({
  Value<int> id,
  required String date,
  Value<int?> moodPercent,
  Value<bool?> quranRead,
  Value<bool?> sadaqaDone,
  Value<bool?> zikrDone,
  Value<String?> note,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$DayRecordsTableUpdateCompanionBuilder = DayRecordsCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<int?> moodPercent,
  Value<bool?> quranRead,
  Value<bool?> sadaqaDone,
  Value<bool?> zikrDone,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$DayRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $DayRecordsTable, DayRecord> {
  $$DayRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PrayerRecordsTable, List<PrayerRecord>>
      _prayerRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.prayerRecords,
              aliasName: $_aliasNameGenerator(
                  db.dayRecords.id, db.prayerRecords.dayRecordId));

  $$PrayerRecordsTableProcessedTableManager get prayerRecordsRefs {
    final manager = $$PrayerRecordsTableTableManager($_db, $_db.prayerRecords)
        .filter((f) => f.dayRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_prayerRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HabitRecordsTable, List<HabitRecord>>
      _habitRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.habitRecords,
              aliasName: $_aliasNameGenerator(
                  db.dayRecords.id, db.habitRecords.dayRecordId));

  $$HabitRecordsTableProcessedTableManager get habitRecordsRefs {
    final manager = $$HabitRecordsTableTableManager($_db, $_db.habitRecords)
        .filter((f) => f.dayRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DayRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DayRecordsTable> {
  $$DayRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get moodPercent => $composableBuilder(
      column: $table.moodPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get quranRead => $composableBuilder(
      column: $table.quranRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sadaqaDone => $composableBuilder(
      column: $table.sadaqaDone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get zikrDone => $composableBuilder(
      column: $table.zikrDone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> prayerRecordsRefs(
      Expression<bool> Function($$PrayerRecordsTableFilterComposer f) f) {
    final $$PrayerRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.prayerRecords,
        getReferencedColumn: (t) => t.dayRecordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PrayerRecordsTableFilterComposer(
              $db: $db,
              $table: $db.prayerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> habitRecordsRefs(
      Expression<bool> Function($$HabitRecordsTableFilterComposer f) f) {
    final $$HabitRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitRecords,
        getReferencedColumn: (t) => t.dayRecordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitRecordsTableFilterComposer(
              $db: $db,
              $table: $db.habitRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DayRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DayRecordsTable> {
  $$DayRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get moodPercent => $composableBuilder(
      column: $table.moodPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get quranRead => $composableBuilder(
      column: $table.quranRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sadaqaDone => $composableBuilder(
      column: $table.sadaqaDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get zikrDone => $composableBuilder(
      column: $table.zikrDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DayRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayRecordsTable> {
  $$DayRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get moodPercent => $composableBuilder(
      column: $table.moodPercent, builder: (column) => column);

  GeneratedColumn<bool> get quranRead =>
      $composableBuilder(column: $table.quranRead, builder: (column) => column);

  GeneratedColumn<bool> get sadaqaDone => $composableBuilder(
      column: $table.sadaqaDone, builder: (column) => column);

  GeneratedColumn<bool> get zikrDone =>
      $composableBuilder(column: $table.zikrDone, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> prayerRecordsRefs<T extends Object>(
      Expression<T> Function($$PrayerRecordsTableAnnotationComposer a) f) {
    final $$PrayerRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.prayerRecords,
        getReferencedColumn: (t) => t.dayRecordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PrayerRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.prayerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> habitRecordsRefs<T extends Object>(
      Expression<T> Function($$HabitRecordsTableAnnotationComposer a) f) {
    final $$HabitRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitRecords,
        getReferencedColumn: (t) => t.dayRecordId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.habitRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DayRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DayRecordsTable,
    DayRecord,
    $$DayRecordsTableFilterComposer,
    $$DayRecordsTableOrderingComposer,
    $$DayRecordsTableAnnotationComposer,
    $$DayRecordsTableCreateCompanionBuilder,
    $$DayRecordsTableUpdateCompanionBuilder,
    (DayRecord, $$DayRecordsTableReferences),
    DayRecord,
    PrefetchHooks Function({bool prayerRecordsRefs, bool habitRecordsRefs})> {
  $$DayRecordsTableTableManager(_$AppDatabase db, $DayRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int?> moodPercent = const Value.absent(),
            Value<bool?> quranRead = const Value.absent(),
            Value<bool?> sadaqaDone = const Value.absent(),
            Value<bool?> zikrDone = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DayRecordsCompanion(
            id: id,
            date: date,
            moodPercent: moodPercent,
            quranRead: quranRead,
            sadaqaDone: sadaqaDone,
            zikrDone: zikrDone,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            Value<int?> moodPercent = const Value.absent(),
            Value<bool?> quranRead = const Value.absent(),
            Value<bool?> sadaqaDone = const Value.absent(),
            Value<bool?> zikrDone = const Value.absent(),
            Value<String?> note = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              DayRecordsCompanion.insert(
            id: id,
            date: date,
            moodPercent: moodPercent,
            quranRead: quranRead,
            sadaqaDone: sadaqaDone,
            zikrDone: zikrDone,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DayRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {prayerRecordsRefs = false, habitRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (prayerRecordsRefs) db.prayerRecords,
                if (habitRecordsRefs) db.habitRecords
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (prayerRecordsRefs)
                    await $_getPrefetchedData<DayRecord, $DayRecordsTable,
                            PrayerRecord>(
                        currentTable: table,
                        referencedTable: $$DayRecordsTableReferences
                            ._prayerRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DayRecordsTableReferences(db, table, p0)
                                .prayerRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dayRecordId == item.id),
                        typedResults: items),
                  if (habitRecordsRefs)
                    await $_getPrefetchedData<DayRecord, $DayRecordsTable,
                            HabitRecord>(
                        currentTable: table,
                        referencedTable: $$DayRecordsTableReferences
                            ._habitRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DayRecordsTableReferences(db, table, p0)
                                .habitRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dayRecordId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DayRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DayRecordsTable,
    DayRecord,
    $$DayRecordsTableFilterComposer,
    $$DayRecordsTableOrderingComposer,
    $$DayRecordsTableAnnotationComposer,
    $$DayRecordsTableCreateCompanionBuilder,
    $$DayRecordsTableUpdateCompanionBuilder,
    (DayRecord, $$DayRecordsTableReferences),
    DayRecord,
    PrefetchHooks Function({bool prayerRecordsRefs, bool habitRecordsRefs})>;
typedef $$PrayerRecordsTableCreateCompanionBuilder = PrayerRecordsCompanion
    Function({
  Value<int> id,
  required int dayRecordId,
  required String prayerKey,
  Value<bool> prayed,
  Value<bool> qazaPrayed,
  Value<DateTime?> prayedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$PrayerRecordsTableUpdateCompanionBuilder = PrayerRecordsCompanion
    Function({
  Value<int> id,
  Value<int> dayRecordId,
  Value<String> prayerKey,
  Value<bool> prayed,
  Value<bool> qazaPrayed,
  Value<DateTime?> prayedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$PrayerRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $PrayerRecordsTable, PrayerRecord> {
  $$PrayerRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DayRecordsTable _dayRecordIdTable(_$AppDatabase db) =>
      db.dayRecords.createAlias(
          $_aliasNameGenerator(db.prayerRecords.dayRecordId, db.dayRecords.id));

  $$DayRecordsTableProcessedTableManager get dayRecordId {
    final $_column = $_itemColumn<int>('day_record_id')!;

    final manager = $$DayRecordsTableTableManager($_db, $_db.dayRecords)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PrayerRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerRecordsTable> {
  $$PrayerRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prayerKey => $composableBuilder(
      column: $table.prayerKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get prayed => $composableBuilder(
      column: $table.prayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get qazaPrayed => $composableBuilder(
      column: $table.qazaPrayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get prayedAt => $composableBuilder(
      column: $table.prayedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DayRecordsTableFilterComposer get dayRecordId {
    final $$DayRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayRecordId,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableFilterComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PrayerRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerRecordsTable> {
  $$PrayerRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prayerKey => $composableBuilder(
      column: $table.prayerKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get prayed => $composableBuilder(
      column: $table.prayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get qazaPrayed => $composableBuilder(
      column: $table.qazaPrayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get prayedAt => $composableBuilder(
      column: $table.prayedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DayRecordsTableOrderingComposer get dayRecordId {
    final $$DayRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayRecordId,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PrayerRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerRecordsTable> {
  $$PrayerRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prayerKey =>
      $composableBuilder(column: $table.prayerKey, builder: (column) => column);

  GeneratedColumn<bool> get prayed =>
      $composableBuilder(column: $table.prayed, builder: (column) => column);

  GeneratedColumn<bool> get qazaPrayed => $composableBuilder(
      column: $table.qazaPrayed, builder: (column) => column);

  GeneratedColumn<DateTime> get prayedAt =>
      $composableBuilder(column: $table.prayedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DayRecordsTableAnnotationComposer get dayRecordId {
    final $$DayRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayRecordId,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PrayerRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrayerRecordsTable,
    PrayerRecord,
    $$PrayerRecordsTableFilterComposer,
    $$PrayerRecordsTableOrderingComposer,
    $$PrayerRecordsTableAnnotationComposer,
    $$PrayerRecordsTableCreateCompanionBuilder,
    $$PrayerRecordsTableUpdateCompanionBuilder,
    (PrayerRecord, $$PrayerRecordsTableReferences),
    PrayerRecord,
    PrefetchHooks Function({bool dayRecordId})> {
  $$PrayerRecordsTableTableManager(_$AppDatabase db, $PrayerRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> dayRecordId = const Value.absent(),
            Value<String> prayerKey = const Value.absent(),
            Value<bool> prayed = const Value.absent(),
            Value<bool> qazaPrayed = const Value.absent(),
            Value<DateTime?> prayedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PrayerRecordsCompanion(
            id: id,
            dayRecordId: dayRecordId,
            prayerKey: prayerKey,
            prayed: prayed,
            qazaPrayed: qazaPrayed,
            prayedAt: prayedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int dayRecordId,
            required String prayerKey,
            Value<bool> prayed = const Value.absent(),
            Value<bool> qazaPrayed = const Value.absent(),
            Value<DateTime?> prayedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              PrayerRecordsCompanion.insert(
            id: id,
            dayRecordId: dayRecordId,
            prayerKey: prayerKey,
            prayed: prayed,
            qazaPrayed: qazaPrayed,
            prayedAt: prayedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PrayerRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dayRecordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dayRecordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dayRecordId,
                    referencedTable:
                        $$PrayerRecordsTableReferences._dayRecordIdTable(db),
                    referencedColumn:
                        $$PrayerRecordsTableReferences._dayRecordIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PrayerRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PrayerRecordsTable,
    PrayerRecord,
    $$PrayerRecordsTableFilterComposer,
    $$PrayerRecordsTableOrderingComposer,
    $$PrayerRecordsTableAnnotationComposer,
    $$PrayerRecordsTableCreateCompanionBuilder,
    $$PrayerRecordsTableUpdateCompanionBuilder,
    (PrayerRecord, $$PrayerRecordsTableReferences),
    PrayerRecord,
    PrefetchHooks Function({bool dayRecordId})>;
typedef $$HabitRecordsTableCreateCompanionBuilder = HabitRecordsCompanion
    Function({
  Value<int> id,
  required int dayRecordId,
  required String habitKey,
  Value<bool> completed,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$HabitRecordsTableUpdateCompanionBuilder = HabitRecordsCompanion
    Function({
  Value<int> id,
  Value<int> dayRecordId,
  Value<String> habitKey,
  Value<bool> completed,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$HabitRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitRecordsTable, HabitRecord> {
  $$HabitRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DayRecordsTable _dayRecordIdTable(_$AppDatabase db) =>
      db.dayRecords.createAlias(
          $_aliasNameGenerator(db.habitRecords.dayRecordId, db.dayRecords.id));

  $$DayRecordsTableProcessedTableManager get dayRecordId {
    final $_column = $_itemColumn<int>('day_record_id')!;

    final manager = $$DayRecordsTableTableManager($_db, $_db.dayRecords)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HabitRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get habitKey => $composableBuilder(
      column: $table.habitKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DayRecordsTableFilterComposer get dayRecordId {
    final $$DayRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayRecordId,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableFilterComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get habitKey => $composableBuilder(
      column: $table.habitKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DayRecordsTableOrderingComposer get dayRecordId {
    final $$DayRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayRecordId,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitRecordsTable> {
  $$HabitRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitKey =>
      $composableBuilder(column: $table.habitKey, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DayRecordsTableAnnotationComposer get dayRecordId {
    final $$DayRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayRecordId,
        referencedTable: $db.dayRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DayRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.dayRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitRecordsTable,
    HabitRecord,
    $$HabitRecordsTableFilterComposer,
    $$HabitRecordsTableOrderingComposer,
    $$HabitRecordsTableAnnotationComposer,
    $$HabitRecordsTableCreateCompanionBuilder,
    $$HabitRecordsTableUpdateCompanionBuilder,
    (HabitRecord, $$HabitRecordsTableReferences),
    HabitRecord,
    PrefetchHooks Function({bool dayRecordId})> {
  $$HabitRecordsTableTableManager(_$AppDatabase db, $HabitRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> dayRecordId = const Value.absent(),
            Value<String> habitKey = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              HabitRecordsCompanion(
            id: id,
            dayRecordId: dayRecordId,
            habitKey: habitKey,
            completed: completed,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int dayRecordId,
            required String habitKey,
            Value<bool> completed = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              HabitRecordsCompanion.insert(
            id: id,
            dayRecordId: dayRecordId,
            habitKey: habitKey,
            completed: completed,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HabitRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dayRecordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dayRecordId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dayRecordId,
                    referencedTable:
                        $$HabitRecordsTableReferences._dayRecordIdTable(db),
                    referencedColumn:
                        $$HabitRecordsTableReferences._dayRecordIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HabitRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitRecordsTable,
    HabitRecord,
    $$HabitRecordsTableFilterComposer,
    $$HabitRecordsTableOrderingComposer,
    $$HabitRecordsTableAnnotationComposer,
    $$HabitRecordsTableCreateCompanionBuilder,
    $$HabitRecordsTableUpdateCompanionBuilder,
    (HabitRecord, $$HabitRecordsTableReferences),
    HabitRecord,
    PrefetchHooks Function({bool dayRecordId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$PrayerSettingsTableTableManager get prayerSettings =>
      $$PrayerSettingsTableTableManager(_db, _db.prayerSettings);
  $$HabitSettingsTableTableManager get habitSettings =>
      $$HabitSettingsTableTableManager(_db, _db.habitSettings);
  $$DayRecordsTableTableManager get dayRecords =>
      $$DayRecordsTableTableManager(_db, _db.dayRecords);
  $$PrayerRecordsTableTableManager get prayerRecords =>
      $$PrayerRecordsTableTableManager(_db, _db.prayerRecords);
  $$HabitRecordsTableTableManager get habitRecords =>
      $$HabitRecordsTableTableManager(_db, _db.habitRecords);
}

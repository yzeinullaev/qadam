import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  return ref.watch(databaseProvider).getUserProfile();
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  return profile?.onboardingCompleted ?? false;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/supabase_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  User? build() {
    return Supabase.instance.client.auth.currentUser;
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      await SupabaseService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      // Automatically sign in after sign up
      await SupabaseService.signIn(
        email: email,
        password: password,
      );
      state = Supabase.instance.client.auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await SupabaseService.signIn(
        email: email,
        password: password,
      );
      state = Supabase.instance.client.auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await SupabaseService.signOut();
      state = null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await SupabaseService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  void updateUser(User? user) {
    state = user;
  }
}

@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<Map<String, dynamic>?> build() async {
    final user = ref.watch(authNotifierProvider);
    if (user == null) return null;
    
    return await SupabaseService.getUserProfile(user.id);
  }

  Future<void> updateProfile({
    String? fullName,
    String? language,
    String? theme,
  }) async {
    final user = ref.read(authNotifierProvider);
    if (user == null) return;

    await SupabaseService.updateUserProfile(
      userId: user.id,
      fullName: fullName,
      language: language,
      theme: theme,
    );
    
    // Refresh the profile
    ref.invalidateSelf();
  }
}

@riverpod
class DailyUsageNotifier extends _$DailyUsageNotifier {
  @override
  Future<Map<String, dynamic>?> build() async {
    final user = ref.watch(authNotifierProvider);
    if (user == null) return null;
    
    return await SupabaseService.getUserDailyUsage(user.id);
  }

  Future<void> incrementQuestions() async {
    final user = ref.read(authNotifierProvider);
    if (user == null) return;

    await SupabaseService.incrementDailyQuestions(user.id);
    ref.invalidateSelf();
  }

  Future<void> incrementAds() async {
    final user = ref.read(authNotifierProvider);
    if (user == null) return;

    await SupabaseService.incrementDailyAds(user.id);
    ref.invalidateSelf();
  }
} 
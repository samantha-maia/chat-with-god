import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../models/subscription_plan.dart';

class SubscriptionState {
  final bool isLoading;
  final bool isSubscribed;
  final String? subscriptionStatus;
  final DateTime? subscriptionEndDate;
  final String? error;

  const SubscriptionState({
    this.isLoading = false,
    this.isSubscribed = false,
    this.subscriptionStatus,
    this.subscriptionEndDate,
    this.error,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    bool? isSubscribed,
    String? subscriptionStatus,
    DateTime? subscriptionEndDate,
    String? error,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      error: error ?? this.error,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  SubscriptionNotifier() : super(const SubscriptionState()) {
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final user = _supabase.auth.currentUser;
      if (user == null) {
        state = state.copyWith(isLoading: false, isSubscribed: false);
        return;
      }

      final userData = await _supabase
          .from('users')
          .select('subscription_status, subscription_end_date')
          .eq('id', user.id)
          .single();

      final status = userData['subscription_status'] as String?;
      final endDateStr = userData['subscription_end_date'] as String?;
      
      DateTime? endDate;
      if (endDateStr != null) {
        endDate = DateTime.parse(endDateStr);
      }

      final isSubscribed = status == 'active' && 
          (endDate == null || endDate.isAfter(DateTime.now()));

      state = state.copyWith(
        isLoading: false,
        isSubscribed: isSubscribed,
        subscriptionStatus: status,
        subscriptionEndDate: endDate,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load subscription status: $e',
      );
    }
  }

  Future<void> refresh() async {
    await _loadSubscriptionStatus();
  }

  Future<void> subscribeToPlan(SubscriptionPlan plan) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // TODO: Implement actual payment processing with Stripe
      // For now, we'll simulate a successful subscription
      
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Calculate end date based on plan type
      final now = DateTime.now();
      final endDate = plan.id.contains('yearly') 
          ? DateTime(now.year + 1, now.month, now.day)
          : DateTime(now.year, now.month + 1, now.day);

      // Update subscription status in database
      await SupabaseService.updateSubscriptionStatus(
        userId: user.id,
        status: 'active',
        endDate: endDate,
      );

      // Refresh state
      await _loadSubscriptionStatus();
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to subscribe: $e',
      );
    }
  }

  Future<void> cancelSubscription() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Update subscription status to cancelled
      await SupabaseService.updateSubscriptionStatus(
        userId: user.id,
        status: 'cancelled',
      );

      // Refresh state
      await _loadSubscriptionStatus();
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to cancel subscription: $e',
      );
    }
  }
}

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

final subscriptionPlansProvider = Provider<List<SubscriptionPlan>>((ref) {
  // Get current locale from context or default to 'en_US'
  // This will be updated when we have access to the context
  return SubscriptionPlans.getPlansForLocale('en_US');
}); 
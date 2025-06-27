import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/supabase_service.dart';
import '../../../shared/providers/auth_provider.dart';

part 'favorite_conversations_provider.g.dart';

@riverpod
class FavoriteConversationsNotifier extends _$FavoriteConversationsNotifier {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final user = ref.watch(authNotifierProvider);
    if (user == null) return [];
    
    return await SupabaseService.getFavoriteConversations(user.id);
  }

  Future<void> toggleFavorite(String conversationId, bool isFavorite) async {
    await SupabaseService.toggleConversationFavorite(
      conversationId: conversationId,
      isFavorite: isFavorite,
    );
    
    // Refresh the list
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class FavoriteConversationsCount extends _$FavoriteConversationsCount {
  @override
  Future<int> build() async {
    final conversations = await ref.watch(favoriteConversationsNotifierProvider.future);
    return conversations.length;
  }
} 
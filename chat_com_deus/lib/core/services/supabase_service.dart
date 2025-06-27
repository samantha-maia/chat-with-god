import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_config.dart';
import '../../shared/models/message.dart';

class SupabaseService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // User operations
  static Future<User?> getCurrentUser() async {
    return _supabase.auth.currentUser;
  }

  static Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
      },
    );

    if (response.user != null) {
      // Create user profile
      await _supabase.from(SupabaseConfig.usersTable).insert({
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
      });
    }
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // User profile operations
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _supabase
        .from(SupabaseConfig.usersTable)
        .select()
        .eq('id', userId)
        .single();
    return response;
  }

  // Ensure user exists in users table (for existing users who might not have profiles)
  static Future<void> ensureUserExists(String userId) async {
    try {
      // Try to get the current user from auth
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Check if user exists in users table
      final existingUser = await _supabase
          .from(SupabaseConfig.usersTable)
          .select()
          .eq('id', userId)
          .maybeSingle();

      // If user doesn't exist, create them
      if (existingUser == null) {
        await _supabase.from(SupabaseConfig.usersTable).insert({
          'id': userId,
          'email': user.email,
          'full_name': user.userMetadata?['full_name'] ?? user.email?.split('@')[0] ?? 'User',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error ensuring user exists: $e');
      // Don't throw here to avoid breaking the chat flow
    }
  }

  static Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? language,
    String? theme,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) updates['full_name'] = fullName;
    if (language != null) updates['language'] = language;
    if (theme != null) updates['theme'] = theme;

    await _supabase
        .from(SupabaseConfig.usersTable)
        .update(updates)
        .eq('id', userId);
  }

  // Conversation operations
  static Future<List<Map<String, dynamic>>> getUserConversations(String userId) async {
    final response = await _supabase
        .from(SupabaseConfig.conversationsTable)
        .select('*, messages:messages(count)')
        .eq('user_id', userId)
        .eq('is_archived', false)
        .order('updated_at', ascending: false);
    
    // Processa o response para extrair o count real
    final conversations = List<Map<String, dynamic>>.from(response);
    for (final conversation in conversations) {
      if (conversation['messages'] != null &&
          conversation['messages'] is List &&
          conversation['messages'].isNotEmpty &&
          conversation['messages'][0]['count'] != null) {
        conversation['message_count'] = conversation['messages'][0]['count'];
      } else {
        conversation['message_count'] = 0;
      }
      // Remove o array messages, só precisamos do count
      conversation.remove('messages');
    }
    
    return conversations;
  }

  static Future<String> createConversation({
    required String userId,
    String? title,
  }) async {
    // Ensure user exists before creating conversation
    await ensureUserExists(userId);
    
    final response = await _supabase
        .from(SupabaseConfig.conversationsTable)
        .insert({
          'user_id': userId,
          'title': title ?? 'New Conversation',
        })
        .select()
        .single();
    return response['id'];
  }

  static Future<void> updateConversationTitle({
    required String conversationId,
    required String title,
  }) async {
    await _supabase
        .from(SupabaseConfig.conversationsTable)
        .update({
          'title': title,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', conversationId);
  }

  static Future<void> toggleConversationFavorite({
    required String conversationId,
    required bool isFavorite,
  }) async {
    await _supabase
        .from(SupabaseConfig.conversationsTable)
        .update({
          'is_favorite': isFavorite,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', conversationId);
  }

  static Future<List<Map<String, dynamic>>> getFavoriteConversations(String userId) async {
    final response = await _supabase
        .from(SupabaseConfig.conversationsTable)
        .select('''
          *,
          messages:messages(count)
        ''')
        .eq('user_id', userId)
        .eq('is_favorite', true)
        .eq('is_archived', false)
        .order('updated_at', ascending: false);
    
    // Process the response to extract message count
    final conversations = List<Map<String, dynamic>>.from(response);
    for (final conversation in conversations) {
      if (conversation['messages'] != null && conversation['messages'] is List) {
        conversation['message_count'] = conversation['messages'].length;
      } else {
        conversation['message_count'] = 0;
      }
      // Remove the messages array since we only need the count
      conversation.remove('messages');
    }
    
    return conversations;
  }

  static Future<void> generateConversationTitle({
    required String conversationId,
    required String firstMessage,
  }) async {
    try {
      // Generate a title using OpenAI
      final response = await _supabase.functions.invoke(
        'chatgpt',
        body: {
          'message': 'Generate a short, descriptive title (max 50 characters) for this conversation based on the first message. Return only the title, nothing else: "$firstMessage"',
          'userId': 'system', // Use system user for title generation
          'conversationHistory': [],
        },
      );

      if (response.status == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['response'] != null) {
          final title = data['response'].toString().trim();
          // Update the conversation title
          await updateConversationTitle(
            conversationId: conversationId,
            title: title,
          );
        }
      }
    } catch (e) {
      print('Error generating conversation title: $e');
      // Fallback to using the first message as title
      final fallbackTitle = firstMessage.length > 50 
          ? '${firstMessage.substring(0, 50)}...' 
          : firstMessage;
      await updateConversationTitle(
        conversationId: conversationId,
        title: fallbackTitle,
      );
    }
  }

  static Future<void> deleteConversation(String conversationId) async {
    // First delete all messages in the conversation
    await _supabase
        .from(SupabaseConfig.messagesTable)
        .delete()
        .eq('conversation_id', conversationId);
    
    // Then delete the conversation
    await _supabase
        .from(SupabaseConfig.conversationsTable)
        .delete()
        .eq('id', conversationId);
  }

  // Message operations
  static Future<List<Map<String, dynamic>>> getConversationMessages(String conversationId) async {
    final response = await _supabase
        .from(SupabaseConfig.messagesTable)
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<String> createMessage({
    required String conversationId,
    required String userId,
    required String content,
    required String messageType,
    String? personalNote,
  }) async {
    final response = await _supabase
        .from(SupabaseConfig.messagesTable)
        .insert({
          'conversation_id': conversationId,
          'user_id': userId,
          'content': content,
          'message_type': messageType,
          'personal_note': personalNote,
        })
        .select()
        .single();
    return response['id'];
  }

  static Future<void> updateMessage({
    required String messageId,
    bool? isFavorite,
    String? personalNote,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (isFavorite != null) updates['is_favorite'] = isFavorite;
    if (personalNote != null) updates['personal_note'] = personalNote;

    await _supabase
        .from(SupabaseConfig.messagesTable)
        .update(updates)
        .eq('id', messageId);
  }

  // Daily usage tracking
  static Future<Map<String, dynamic>?> getUserDailyUsage(String userId) async {
    final response = await _supabase
        .from(SupabaseConfig.usersTable)
        .select('daily_questions_used, daily_questions_reset_date, daily_ads_watched, daily_ads_reset_date')
        .eq('id', userId)
        .single();
    return response;
  }

  static Future<void> incrementDailyQuestions(String userId) async {
    await _supabase.rpc('increment_daily_questions', params: {'user_id': userId});
  }

  static Future<void> incrementDailyAds(String userId) async {
    await _supabase.rpc('increment_daily_ads', params: {'user_id': userId});
  }

  // Bible verses
  static Future<Map<String, dynamic>?> getDailyVerse() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final response = await _supabase
        .from(SupabaseConfig.bibleVersesTable)
        .select()
        .eq('is_daily_verse', true)
        .eq('verse_date', today)
        .maybeSingle();
    return response;
  }

  // Subscription operations
  static Future<void> updateSubscriptionStatus({
    required String userId,
    required String status,
    DateTime? endDate,
    String? stripeCustomerId,
  }) async {
    final updates = <String, dynamic>{
      'subscription_status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (endDate != null) updates['subscription_end_date'] = endDate.toIso8601String();
    if (stripeCustomerId != null) updates['stripe_customer_id'] = stripeCustomerId;

    await _supabase
        .from(SupabaseConfig.usersTable)
        .update(updates)
        .eq('id', userId);
  }

  // OpenAI Chat Function
  static Future<String> getAiResponse({
    required String message,
    required String userId,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'chatgpt',
        body: {
          'message': message,
          'userId': userId,
          'conversationHistory': conversationHistory ?? [],
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to get AI response: ${response.status}');
      }

      final data = response.data as Map<String, dynamic>;
      
      if (data['error'] != null) {
        throw Exception('AI Error: ${data['error']}');
      }

      return data['response'] as String;
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }

  // Real-time subscriptions
  static RealtimeChannel subscribeToMessages(String conversationId, Function(Map<String, dynamic>) onMessage) {
    return _supabase
        .channel('messages:$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: SupabaseConfig.messagesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            onMessage(payload.newRecord);
          },
        )
        .subscribe();
  }
} 
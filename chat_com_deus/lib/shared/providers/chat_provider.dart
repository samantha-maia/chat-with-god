import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/message.dart';
import '../../core/services/supabase_service.dart';

part 'chat_provider.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  List<Message> build() {
    return [];
  }

  void addMessage(Message message) {
    state = [...state, message];
  }

  void updateMessage(String messageId, Message updatedMessage) {
    state = [
      for (final message in state)
        if (message.id == messageId) updatedMessage else message,
    ];
  }

  void removeMessage(String messageId) {
    state = state.where((message) => message.id != messageId).toList();
  }

  void toggleFavorite(String messageId) {
    state = [
      for (final message in state)
        if (message.id == messageId)
          message.copyWith(isFavorite: !message.isFavorite)
        else
          message,
    ];
    
    // Save the favorite status to database
    _saveFavoriteStatus(messageId, state.firstWhere((m) => m.id == messageId).isFavorite);
  }

  void addPersonalNote(String messageId, String note) {
    state = [
      for (final message in state)
        if (message.id == messageId)
          message.copyWith(personalNote: note)
        else
          message,
    ];
    
    // Save the personal note to database
    _savePersonalNote(messageId, note);
  }

  void clearChat() {
    state = [];
  }

  void startNewChat() {
    clearChat();
  }

  Future<void> startNewChatWithMessage(String initialMessage) async {
    clearChat();
    await sendUserMessage(initialMessage);
  }

  void startNewChatWithUserMessage(String initialMessage) {
    clearChat();
    final userMessage = Message.createUserMessage(initialMessage);
    addMessage(userMessage);
  }

  List<Message> getFavoriteMessages() {
    return state.where((message) => message.isFavorite).toList();
  }

  Future<void> sendUserMessage(String content) async {
    final user = await SupabaseService.getCurrentUser();
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final userMessage = Message.createUserMessage(content);
    addMessage(userMessage);
    
    // Create a loading AI message
    final loadingMessage = Message.createAiMessage('Thinking...');
    addMessage(loadingMessage);
    
    try {
      // Prepare conversation history for context (exclude the current loading message)
      final conversationHistory = state
          .where((msg) => msg.id != loadingMessage.id) // Exclude the loading message
          .map((msg) => {
                'role': msg.type == MessageType.user ? 'user' : 'assistant',
                'content': msg.content,
              })
          .toList();

      // Get AI response from Supabase Edge Function
      final aiResponse = await SupabaseService.getAiResponse(
        message: content,
        userId: user.id,
        conversationHistory: conversationHistory,
      );

      // Update the loading message with the real response (same message ID)
      final updatedMessage = loadingMessage.copyWith(
        content: aiResponse,
        status: MessageStatus.sent,
      );
      updateMessage(loadingMessage.id, updatedMessage);

      // Update user message status to 'sent'
      final sentUserMessage = userMessage.copyWith(status: MessageStatus.sent);
      updateMessage(userMessage.id, sentUserMessage);

      // Save messages to database
      await _saveMessagesToDatabase(user.id, sentUserMessage, updatedMessage);
      
    } catch (e) {
      // Update loading message with error (same message ID)
      final errorMessage = loadingMessage.copyWith(
        content: 'Sorry, I encountered an error. Please try again later.',
        status: MessageStatus.error,
        errorMessage: e.toString(),
      );
      updateMessage(loadingMessage.id, errorMessage);

      // Update user message status to 'error'
      final errorUserMessage = userMessage.copyWith(
        status: MessageStatus.error,
        errorMessage: e.toString(),
      );
      updateMessage(userMessage.id, errorUserMessage);
      
      throw e;
    }
  }

  Future<void> _saveMessagesToDatabase(String userId, Message userMessage, Message aiMessage) async {
    try {
      // Ensure user exists in users table first
      await SupabaseService.ensureUserExists(userId);
      
      // Create or get conversation
      final conversations = await SupabaseService.getUserConversations(userId);
      String conversationId;
      bool isNewConversation = false;
      
      if (conversations.isEmpty) {
        // Create new conversation
        conversationId = await SupabaseService.createConversation(
          userId: userId,
          title: 'New Conversation', // Temporary title
        );
        isNewConversation = true;
      } else {
        // Use the most recent conversation
        conversationId = conversations.first['id'];
      }

      // Save user message
      await SupabaseService.createMessage(
        conversationId: conversationId,
        userId: userId,
        content: userMessage.content,
        messageType: 'user',
      );

      // Save AI message
      await SupabaseService.createMessage(
        conversationId: conversationId,
        userId: userId,
        content: aiMessage.content,
        messageType: 'ai',
      );

      // Generate title for new conversations based on the first message
      if (isNewConversation) {
        // Generate title asynchronously (don't wait for it)
        SupabaseService.generateConversationTitle(
          conversationId: conversationId,
          firstMessage: userMessage.content,
        );
      }
    } catch (e) {
      print('Error saving messages to database: $e');
      // Don't throw here to avoid breaking the chat flow
      // The messages are already displayed in the UI, so the user experience isn't broken
    }
  }

  Future<void> _saveFavoriteStatus(String messageId, bool isFavorite) async {
    try {
      await SupabaseService.updateMessage(
        messageId: messageId,
        isFavorite: isFavorite,
      );
    } catch (e) {
      print('Error saving favorite status to database: $e');
      // Don't throw here to avoid breaking the UI
    }
  }

  Future<void> _savePersonalNote(String messageId, String note) async {
    try {
      await SupabaseService.updateMessage(
        messageId: messageId,
        personalNote: note,
      );
    } catch (e) {
      print('Error saving personal note to database: $e');
      // Don't throw here to avoid breaking the UI
    }
  }
}

@riverpod
class FreeQuestionsNotifier extends _$FreeQuestionsNotifier {
  @override
  int build() {
    return 3; // Start with 3 free questions
  }

  void useQuestion() {
    if (state > 0) {
      state = state - 1;
    }
  }

  void addQuestions(int count) {
    state = state + count;
  }

  void resetDailyQuestions() {
    state = 3;
  }

  bool get canAskQuestion => state > 0;
}

@riverpod
class AdWatchedCountNotifier extends _$AdWatchedCountNotifier {
  @override
  int build() {
    return 0; // Start with 0 ads watched today
  }

  void watchAd() {
    if (state < 3) { // Max 3 ads per day
      state = state + 1;
    }
  }

  void resetDailyAds() {
    state = 0;
  }

  bool get canWatchAd => state < 3;
} 
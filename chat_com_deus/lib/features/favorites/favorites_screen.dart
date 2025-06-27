import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/chat_provider.dart';
import '../../shared/models/message.dart';
import '../../shared/widgets/chat_message.dart';
import 'providers/favorite_conversations_provider.dart';
import '../chat/chat_screen.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../core/services/supabase_service.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chatNotifier = ref.watch(chatNotifierProvider.notifier);
    final favoriteMessages = chatNotifier.getFavoriteMessages();
    final allMessages = ref.watch(chatNotifierProvider);
    final messagesWithNotes = allMessages.where((msg) => msg.personalNote != null && msg.personalNote!.isNotEmpty).toList();
    final favoriteConversationsAsync = ref.watch(favoriteConversationsNotifierProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/cloud.jpg'),
              fit: BoxFit.cover,
              opacity: isDark ? 0.06 : 0.1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [theme.colorScheme.background, theme.colorScheme.surface]
                  : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.95)],
            ),
          ),
          child: Column(
            children: [
              // Tab Bar
              Container(
                color: theme.colorScheme.surface.withOpacity(isDark ? 0.97 : 0.95),
                child: const TabBar(
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppTheme.primaryColor,
                  tabs: [
                    Tab(text: 'Favorite Messages'),
                    Tab(text: 'Personal Notes'),
                    Tab(text: 'Favorite Chats'),
                  ],
                ),
              ),
              // Tab Content
              Expanded(
                child: TabBarView(
                  children: [
                    _buildFavoriteMessagesTab(ref),
                    _buildPersonalNotesTab(ref),
                    _buildFavoriteChatsTab(ref),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteMessagesTab(WidgetRef ref) {
    final chatNotifier = ref.watch(chatNotifierProvider.notifier);
    final favoriteMessages = chatNotifier.getFavoriteMessages();

    if (favoriteMessages.isEmpty) {
      return _buildEmptyState(
        ref.context,
        icon: Icons.favorite_border,
        title: 'No Favorite Messages',
        subtitle: 'Messages you favorite will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(chatNotifierProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteMessages.length,
        itemBuilder: (context, index) {
          final message = favoriteMessages[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ChatMessage(
              message: message,
              onFavorite: () {
                ref.read(chatNotifierProvider.notifier).toggleFavorite(message.id);
              },
              onAddNote: () {
                _addPersonalNote(ref.context, message.id, ref.read(chatNotifierProvider.notifier));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalNotesTab(WidgetRef ref) {
    final chatNotifier = ref.watch(chatNotifierProvider.notifier);
    final allMessages = ref.watch(chatNotifierProvider);
    final messagesWithNotes = allMessages.where((msg) => msg.personalNote != null && msg.personalNote!.isNotEmpty).toList();

    if (messagesWithNotes.isEmpty) {
      return _buildEmptyState(
        ref.context,
        icon: Icons.note_outlined,
        title: 'No Personal Notes',
        subtitle: 'Add notes to messages to see them here',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(chatNotifierProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messagesWithNotes.length,
        itemBuilder: (context, index) {
          final message = messagesWithNotes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ChatMessage(
              message: message,
              onFavorite: () {
                ref.read(chatNotifierProvider.notifier).toggleFavorite(message.id);
              },
              onAddNote: () {
                _addPersonalNote(ref.context, message.id, ref.read(chatNotifierProvider.notifier));
              },
            ),
          );
        },
      ),
    );
  }

  void _addPersonalNote(BuildContext context, String messageId, chatNotifier) {
    showDialog(
      context: context,
      builder: (context) => _AddNoteDialog(
        messageId: messageId,
        onSave: (note) {
          chatNotifier.addPersonalNote(messageId, note);
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteChatsTab(WidgetRef ref) {
    final favoriteConversationsAsync = ref.watch(favoriteConversationsNotifierProvider);

    return favoriteConversationsAsync.when(
      data: (conversations) {
        if (conversations.isEmpty) {
          return _buildEmptyState(
            ref.context,
            icon: Icons.group_outlined,
            title: 'No Favorite Conversations',
            subtitle: 'Tap the heart icon on any conversation to add it to your favorites',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            final title = conversation['title'] ?? 'Untitled Conversation';
            final updatedAt = DateTime.parse(conversation['updated_at']);
            final messageCount = conversation['message_count'] ?? 0;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: const FaIcon(
                    FontAwesomeIcons.comments,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.favorite,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy • HH:mm').format(updatedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (messageCount > 0)
                      Text(
                        '$messageCount message${messageCount == 1 ? '' : 's'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: AppTheme.primaryColor),
                  onPressed: () => _removeFromFavorites(context, conversation['id']),
                  tooltip: 'Remove from favorites',
                ),
                onTap: () => _continueConversation(context, conversation['id']),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildEmptyState(
        ref.context,
        icon: Icons.error_outline,
        title: 'Error Loading Conversations',
        subtitle: 'Please try again later',
      ),
    );
  }

  void _removeFromFavorites(BuildContext context, String conversationId) async {
    try {
      await SupabaseService.toggleConversationFavorite(
        conversationId: conversationId,
        isFavorite: false,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing from favorites: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _continueConversation(BuildContext context, String conversationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MainScaffold(
          child: ChatScreen(conversationId: conversationId),
        ),
      ),
    );
  }
}

class _AddNoteDialog extends StatefulWidget {
  final String messageId;
  final Function(String) onSave;

  const _AddNoteDialog({
    required this.messageId,
    required this.onSave,
  });

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Personal Note'),
      content: TextField(
        controller: _noteController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Write your personal note about this message...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final note = _noteController.text.trim();
            if (note.isNotEmpty) {
              widget.onSave(note);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 
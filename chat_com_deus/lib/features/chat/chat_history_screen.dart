import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/chat_provider.dart';
import '../../core/services/supabase_service.dart';
import '../../core/theme/app_theme.dart';
import '../chat/chat_screen.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../favorites/providers/favorite_conversations_provider.dart';

class ChatHistoryScreen extends ConsumerStatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  ConsumerState<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends ConsumerState<ChatHistoryScreen> {
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final user = ref.read(authNotifierProvider);
      if (user == null) {
        setState(() {
          _error = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      final conversations = await SupabaseService.getUserConversations(user.id);
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load conversations: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteConversation(String conversationId) async {
    try {
      await SupabaseService.deleteConversation(conversationId);
      
      // Remove from local list
      setState(() {
        _conversations.removeWhere((conv) => conv['id'] == conversationId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conversation deleted'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete conversation: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _continueConversation(String conversationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MainScaffold(
          child: ChatScreen(conversationId: conversationId),
        ),
      ),
    ).then((_) {
      // Refresh the conversation list when returning
      _loadConversations();
    });
  }

  void _showDeleteDialog(String conversationId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteConversation(conversationId);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildErrorState(theme)
                : _conversations.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildConversationsList(theme, isDark),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new chat to see your conversation history here',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainScaffold(child: ChatScreen()),
                ),
              );
            },
            child: const Text('Start New Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'Error loading conversations',
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.error),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadConversations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          final title = conversation['title'] ?? 'Untitled Conversation';
          final updatedAt = DateTime.parse(conversation['updated_at']);
          final messageCount = conversation['message_count'] ?? 0;
          final isFavorite = conversation['is_favorite'] ?? false;

          return Card(
            color: theme.colorScheme.surface.withOpacity(isDark ? 0.97 : 1.0),
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: Icon(Icons.chat, color: theme.colorScheme.onPrimary, size: 20),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface),
                    ),
                  ),
                  if (isFavorite)
                    Icon(Icons.favorite, size: 16, color: theme.colorScheme.primary),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(updatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  if (messageCount > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '$messageCount message${messageCount == 1 ? '' : 's'}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onPressed: () => _toggleFavorite(conversation['id'], !isFavorite),
                    tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                    onPressed: () => _showDeleteDialog(conversation['id'], title),
                    tooltip: 'Delete conversation',
                  ),
                ],
              ),
              onTap: () => _continueConversation(conversation['id']),
            ),
          );
        },
      ),
    );
  }

  void _toggleFavorite(String conversationId, bool isFavorite) async {
    try {
      await SupabaseService.toggleConversationFavorite(
        conversationId: conversationId,
        isFavorite: isFavorite,
      );
      
      // Refresh the conversation list
      _loadConversations();
      
      // Show feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite ? 'Added to favorites' : 'Removed from favorites',
            ),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating favorite: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
} 
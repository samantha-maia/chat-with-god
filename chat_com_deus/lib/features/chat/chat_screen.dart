import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../shared/widgets/chat_message.dart';
import '../../shared/providers/chat_provider.dart';
import '../../shared/models/message.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/supabase_service.dart';
import '../../shared/providers/auth_provider.dart';
import '../../core/services/ad_service.dart';
import '../../shared/widgets/main_scaffold.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? conversationId;
  final String? initialInput;
  const ChatScreen({super.key, this.conversationId, this.initialInput});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _conversationId;
  String _conversationTitle = 'New Chat';
  bool _isLoadingTitle = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialInput != null && widget.initialInput!.isNotEmpty) {
      _messageController.text = widget.initialInput!;
    }
    _initConversation();
  }

  Future<void> _initConversation() async {
    if (widget.conversationId != null) {
      setState(() {
        _conversationId = widget.conversationId;
      });
      // Load existing messages for this conversation
      await _loadConversationMessages();
      // Load conversation title
      await _loadConversationTitle();
    } else {
      // Create a new conversation in Supabase
      final user = ref.read(authNotifierProvider);
      if (user != null) {
        final newId = await SupabaseService.createConversation(userId: user.id);
        setState(() {
          _conversationId = newId;
        });
      }
    }
  }

  Future<void> _loadConversationMessages() async {
    if (widget.conversationId == null) return;

    try {
      final messages = await SupabaseService.getConversationMessages(widget.conversationId!);
      
      // Convert database messages to Message objects
      final messageList = messages.map((msg) {
        return Message(
          id: msg['id'],
          content: msg['content'],
          type: msg['message_type'] == 'user' ? MessageType.user : MessageType.ai,
          timestamp: DateTime.parse(msg['created_at']),
          status: MessageStatus.sent,
          isFavorite: msg['is_favorite'] ?? false,
          personalNote: msg['personal_note'],
        );
      }).toList();

      // Add messages to the chat provider
      for (final message in messageList) {
        ref.read(chatNotifierProvider.notifier).addMessage(message);
      }
    } catch (e) {
      print('Error loading conversation messages: $e');
      // Don't show error to user, just log it
    }
  }

  Future<void> _loadConversationTitle() async {
    if (widget.conversationId == null) return;

    try {
      final conversations = await SupabaseService.getUserConversations(
        ref.read(authNotifierProvider)!.id,
      );
      final conversation = conversations.firstWhere(
        (conv) => conv['id'] == widget.conversationId,
        orElse: () => {'title': 'Untitled Conversation'},
      );
      
      setState(() {
        _conversationTitle = conversation['title'] ?? 'Untitled Conversation';
      });
    } catch (e) {
      print('Error loading conversation title: $e');
    }
  }

  Future<void> _editConversationTitle() async {
    if (_conversationId == null) return;

    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => _EditTitleDialog(initialTitle: _conversationTitle),
    );

    if (newTitle != null && newTitle != _conversationTitle) {
      try {
        setState(() {
          _isLoadingTitle = true;
        });

        await SupabaseService.updateConversationTitle(
          conversationId: _conversationId!,
          title: newTitle,
        );

        setState(() {
          _conversationTitle = newTitle;
          _isLoadingTitle = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conversation title updated'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoadingTitle = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update title: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final freeQuestions = ref.read(freeQuestionsNotifierProvider);
    if (freeQuestions <= 0) {
      _showLimitReachedDialog();
      return;
    }

    ref.read(chatNotifierProvider.notifier).sendUserMessage(message);
    ref.read(freeQuestionsNotifierProvider.notifier).useQuestion();
    _messageController.clear();

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily limit reached'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Upgrade to Premium for unlimited questions'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _watchAd();
                    },
                    child: const Text('Watch ad for +2 questions'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _upgradeToPremium();
                    },
                    child: const Text('Premium'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _watchAd() {
    // TODO: Implement AdMob rewarded ad
    ref.read(adWatchedCountNotifierProvider.notifier).watchAd();
    ref.read(freeQuestionsNotifierProvider.notifier).addQuestions(2);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('+2 questions added!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _upgradeToPremium() {
    // TODO: Navigate to subscription screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigate to subscription screen'),
      ),
    );
  }

  void _addPersonalNote(String messageId) {
    showDialog(
      context: context,
      builder: (context) => _AddNoteDialog(
        messageId: messageId,
        onSave: (note) {
          ref.read(chatNotifierProvider.notifier).addPersonalNote(messageId, note);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final messages = ref.watch(chatNotifierProvider);
    final freeQuestions = ref.watch(freeQuestionsNotifierProvider);
    final adWatchedCount = ref.watch(adWatchedCountNotifierProvider);
    final canWatchAd = ref.read(adWatchedCountNotifierProvider.notifier).canWatchAd;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/cloud.jpg'),
          fit: BoxFit.cover,
          opacity: isDark ? 0.06 : 0.1, // Subtler in dark mode
        ),
      ),
      child: Column(
        children: [
          // Free questions indicator and actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(isDark ? 0.97 : 0.95),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.18) : Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    if (freeQuestions > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Free questions: $freeQuestions',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (canWatchAd)
                      IconButton(
                        onPressed: _watchAd,
                        icon: const FaIcon(FontAwesomeIcons.play),
                        tooltip: 'Watch ad for questions',
                        color: theme.colorScheme.primary,
                      ),
                    IconButton(
                      onPressed: () {
                        // TODO: Open settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings coming soon!')),
                        );
                      },
                      icon: Icon(Icons.settings, color: theme.colorScheme.primary),
                      tooltip: 'Settings',
                    ),
                  ],
                ),
                if (freeQuestions == 0 && canWatchAd)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text('Watch ad for +2 questions'),
                      onPressed: () {
                        AdService().loadAndShowRewardedAd(
                          onRewarded: () {
                            ref.read(freeQuestionsNotifierProvider.notifier).addQuestions(2);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('You earned +2 questions!')),
                            );
                          },
                          onError: (msg) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ad failed: $msg')),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState(context, theme, isDark)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatMessage(
                        message: message,
                        onFavorite: () {
                          ref.read(chatNotifierProvider.notifier).toggleFavorite(message.id);
                        },
                        onAddNote: () => _addPersonalNote(message.id),
                      );
                    },
                  ),
          ),
          _buildMessageInput(context, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask anything that is on your heart.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      color: theme.colorScheme.surface.withOpacity(isDark ? 0.98 : 1.0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(isDark ? 0.95 : 1.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: theme.colorScheme.primary),
            onPressed: _sendMessage,
            tooltip: 'Send',
          ),
        ],
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
      title: const Text('Add note'),
      content: TextField(
        controller: _noteController,
        decoration: const InputDecoration(
          hintText: 'Add your personal note...',
        ),
        maxLines: 3,
        textCapitalization: TextCapitalization.sentences,
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
          child: const Text('Save note'),
        ),
      ],
    );
  }
}

class _EditTitleDialog extends StatefulWidget {
  final String initialTitle;

  const _EditTitleDialog({
    required this.initialTitle,
  });

  @override
  State<_EditTitleDialog> createState() => _EditTitleDialogState();
}

class _EditTitleDialogState extends State<_EditTitleDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Conversation Title'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter new title...',
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            Navigator.pop(context, value);
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/message.dart';
import '../../core/theme/app_theme.dart';

class ChatMessage extends StatelessWidget {
  final Message message;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddNote;
  final bool showActions;

  const ChatMessage({
    super.key,
    required this.message,
    this.onFavorite,
    this.onAddNote,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: const FaIcon(
                FontAwesomeIcons.church,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? (isDark ? AppTheme.userMessageDark : AppTheme.userMessageLight)
                        : (isDark ? AppTheme.aiMessageDark : AppTheme.aiMessageLight),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isUser ? Colors.white : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (message.personalNote != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.noteSticky,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  message.personalNote!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (message.status == MessageStatus.sending) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                    if (message.status == MessageStatus.error) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.error_outline,
                        size: 12,
                        color: theme.colorScheme.error,
                      ),
                    ],
                  ],
                ),
                if (showActions && message.type == MessageType.ai) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onFavorite,
                        icon: FaIcon(
                          message.isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                          size: 20,
                          color: message.isFavorite 
                              ? theme.colorScheme.error 
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        tooltip: message.isFavorite ? 'Unfavorite' : 'Favorite',
                      ),
                      IconButton(
                        onPressed: onAddNote,
                        icon: FaIcon(
                          FontAwesomeIcons.noteSticky,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        tooltip: 'Add note',
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: const FaIcon(
                FontAwesomeIcons.user,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
} 
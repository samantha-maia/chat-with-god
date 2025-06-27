import 'package:uuid/uuid.dart';

enum MessageType {
  user,
  ai,
}

enum MessageStatus {
  sending,
  sent,
  error,
}

class Message {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isFavorite;
  final String? personalNote;
  final String? errorMessage;

  const Message({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.isFavorite = false,
    this.personalNote,
    this.errorMessage,
  });

  Message copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    bool? isFavorite,
    String? personalNote,
    String? errorMessage,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      personalNote: personalNote ?? this.personalNote,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory Message.createUserMessage(String content) {
    return Message(
      id: const Uuid().v4(),
      content: content,
      type: MessageType.user,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );
  }

  factory Message.createAiMessage(String content) {
    return Message(
      id: const Uuid().v4(),
      content: content,
      type: MessageType.ai,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'isFavorite': isFavorite,
      'personalNote': personalNote,
      'errorMessage': errorMessage,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      isFavorite: json['isFavorite'] as bool? ?? false,
      personalNote: json['personalNote'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Message(id: $id, content: $content, type: $type, timestamp: $timestamp)';
  }
} 
part of '../ai_search.dart';

/// نماذج الأدوار في محادثة المساعد (موافقة لأدوار OpenAI).
enum ChatRole { user, assistant, tool }

/// رسالة واحدة في محادثة المساعد الذكي.
class ChatMessage {
  final ChatRole role;
  final String content;

  /// اسم الأداة المرتبطة (لرسائل role=tool فقط).
  final String? toolName;

  const ChatMessage({
    required this.role,
    required this.content,
    this.toolName,
  });

  bool get isUser => role == ChatRole.user;
  bool get isAssistant => role == ChatRole.assistant;
  bool get isTool => role == ChatRole.tool;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final roleStr = json['r'] as String? ?? 'user';
    return ChatMessage(
      role: roleStr == 'assistant'
          ? ChatRole.assistant
          : roleStr == 'tool'
              ? ChatRole.tool
              : ChatRole.user,
      content: json['c'] as String? ?? '',
      toolName: json['t'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'r': role.name,
        'c': content,
        if (toolName != null) 't': toolName,
      };
}

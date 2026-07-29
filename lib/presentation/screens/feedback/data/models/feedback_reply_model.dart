/// نموذج رد واحد في محادثة الـ feedback.
///
/// يطابق عناصر مصفوفة `replies` في `GET /feedback/{token}`
/// وحقل `data` في `POST /feedback/{token}/reply`.
class FeedbackReplyModel {
  final String id;
  final String feedbackId;
  final String authorRole; // admin | user
  final String body;
  final String createdAt;
  final List<String> mediaUrls;

  const FeedbackReplyModel({
    required this.id,
    required this.feedbackId,
    required this.authorRole,
    required this.body,
    required this.createdAt,
    this.mediaUrls = const [],
  });

  /// هل الكاتب أدمن؟
  bool get isAdmin => authorRole == 'admin';

  factory FeedbackReplyModel.fromJson(Map<String, dynamic> json) {
    final raw = json['media_urls'] ?? json['media'];
    final List<String> urls = raw is List
        ? raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
        : const [];
    return FeedbackReplyModel(
      id: '${json['id'] ?? ''}',
      feedbackId: '${json['feedback_id'] ?? ''}',
      authorRole: '${json['author_role'] ?? 'user'}',
      body: '${json['body'] ?? ''}',
      createdAt: '${json['created_at'] ?? ''}',
      mediaUrls: urls,
    );
  }
}

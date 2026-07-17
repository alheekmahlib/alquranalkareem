/// نموذج الـ feedback المُرسل من المستخدم.
///
/// يطابق استجابة `data` في `POST /feedback` وحقل `feedback` في `GET /feedback/{token}`.
class FeedbackModel {
  final String id;
  final String token;
  final String message;
  final String status; // planned | in_progress | complete
  final bool published;
  final String? appSource;
  final String? contactEmail;
  final String createdAt;
  final String updatedAt;
  final List<String> mediaUrls;

  const FeedbackModel({
    required this.id,
    required this.token,
    required this.message,
    required this.status,
    required this.published,
    this.appSource,
    this.contactEmail,
    required this.createdAt,
    required this.updatedAt,
    this.mediaUrls = const [],
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: '${json['id'] ?? ''}',
      token: '${json['token'] ?? ''}',
      message: '${json['message'] ?? ''}',
      status: '${json['status'] ?? 'planned'}',
      published: json['published'] is bool ? json['published'] as bool : false,
      appSource: json['app_source']?.toString(),
      contactEmail: json['contact_email']?.toString(),
      createdAt: '${json['created_at'] ?? ''}',
      updatedAt: '${json['updated_at'] ?? ''}',
      mediaUrls: _readUrls(json),
    );
  }

  /// يقرأ قائمة الروابط من `media_urls` أو `media` (للتوافق مع كلا الاسمين).
  static List<String> _readUrls(Map<String, dynamic> json) {
    final raw = json['media_urls'] ?? json['media'];
    if (raw is List) {
      return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return const [];
  }

  FeedbackModel copyWith({
    String? id,
    String? token,
    String? message,
    String? status,
    bool? published,
    String? appSource,
    String? contactEmail,
    String? createdAt,
    String? updatedAt,
    List<String>? mediaUrls,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      token: token ?? this.token,
      message: message ?? this.message,
      status: status ?? this.status,
      published: published ?? this.published,
      appSource: appSource ?? this.appSource,
      contactEmail: contactEmail ?? this.contactEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mediaUrls: mediaUrls ?? this.mediaUrls,
    );
  }
}

import 'feedback_model.dart';
import 'feedback_reply_model.dart';

/// محادثة الـ feedback كاملة: الرسالة الأصلية + قائمة الردود.
///
/// يطابق استجابة `GET /feedback/{token}` بالكامل.
class FeedbackThread {
  final FeedbackModel feedback;
  final List<FeedbackReplyModel> replies;

  const FeedbackThread({required this.feedback, required this.replies});

  factory FeedbackThread.fromJson(Map<String, dynamic> json) {
    final rawReplies = json['replies'];
    final replies = <FeedbackReplyModel>[];
    if (rawReplies is List) {
      for (final item in rawReplies) {
        if (item is Map<String, dynamic>) {
          replies.add(FeedbackReplyModel.fromJson(item));
        }
      }
    }
    final feedbackJson = json['feedback'];
    return FeedbackThread(
      feedback: FeedbackModel.fromJson(
        feedbackJson is Map<String, dynamic>
            ? feedbackJson
            : const <String, dynamic>{},
      ),
      replies: replies,
    );
  }

  FeedbackThread copyWith({
    FeedbackModel? feedback,
    List<FeedbackReplyModel>? replies,
  }) {
    return FeedbackThread(
      feedback: feedback ?? this.feedback,
      replies: replies ?? this.replies,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/extensions/custom_error_snackBar.dart';
import '../../../../core/utils/helpers/app_text_styles.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../controller/feedback_controller.dart';
import '../data/models/feedback_reply_model.dart';
import 'widgets/feedback_media_gallery.dart';

/// شاشة المحادثة الواحدة: الرسالة الأصلية + الردود (admin/user) + شريط الرد.
///
/// تستهلك [FeedbackController.openThread] — لا تملك أي state محلي.
class FeedbackConversationScreen extends StatelessWidget {
  const FeedbackConversationScreen({super.key});

  FeedbackController get _c => FeedbackController.instance;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isBooks: false,
        isTitled: false,
        isNotifi: false,
        isFontSize: false,
        searchButton: const SizedBox.shrink(),
        centerChild: Text(
          'my_feedback'.tr,
          style: AppTextStyles.titleLarge(
            color: colorScheme.inversePrimary,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_c.isLoadingThread.value && _c.openThread.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final thread = _c.openThread.value;
          if (thread == null) {
            return _errorState(context);
          }
          return Column(
            children: [
              _statusChip(thread.feedback.status),
              Expanded(
                child: _conversation(
                  context,
                  thread.feedback.message,
                  thread.replies,
                  thread.feedback.mediaUrls,
                ),
              ),
              _replyBar(context),
            ],
          );
        }),
      ),
    );
  }

  Widget _statusChip(String status) {
    final (label, color) = _statusStyle(status);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Chip(
          label: Text(
            label,
            style: AppTextStyles.titleSmall(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  (String, Color) _statusStyle(String status) {
    switch (status) {
      case 'in_progress':
        return ('feedback_status_in_progress'.tr, Colors.amber.shade700);
      case 'complete':
        return ('feedback_status_complete'.tr, Colors.green.shade700);
      case 'planned':
      default:
        return ('feedback_status_planned'.tr, Colors.blue.shade700);
    }
  }

  Widget _conversation(
    BuildContext context,
    String originalMessage,
    List<FeedbackReplyModel> replies,
    List<String> originalMediaUrls,
  ) {
    final items = <_ChatItem>[
      _ChatItem(
        body: originalMessage,
        isAdmin: false,
        createdAt: '',
        isOriginal: true,
        mediaUrls: originalMediaUrls,
      ),
      ...replies.map(
        (r) => _ChatItem(
          body: r.body,
          isAdmin: r.isAdmin,
          createdAt: r.createdAt,
          mediaUrls: r.mediaUrls,
        ),
      ),
    ];
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      itemCount: items.length,
      itemBuilder: (context, index) => _ChatBubble(item: items[index]),
    );
  }

  Widget _replyBar(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final replyCtrl = TextEditingController();
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.08),
        border: Border(
          top: BorderSide(color: colorScheme.surface.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: replyCtrl,
              minLines: 1,
              maxLines: 4,
              style: AppTextStyles.titleMedium(
                color: colorScheme.inversePrimary,
                fontSize: 15.sp,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                hintText: 'feedback_reply_hint'.tr,
                hintStyle: AppTextStyles.titleMedium(
                  color: colorScheme.inversePrimary.withValues(alpha: 0.5),
                  fontSize: 15.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surface.withValues(alpha: 0.06),
              ),
            ),
          ),
          Gap(8.w),
          Obx(
            () => IconButton(
              onPressed: _c.isReplying.value
                  ? null
                  : () => _sendReply(context, replyCtrl),
              icon: _c.isReplying.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    )
                  : Icon(Icons.send, color: colorScheme.primary, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendReply(
    BuildContext context,
    TextEditingController ctrl,
  ) async {
    final text = ctrl.text;
    if (text.trim().isEmpty) return;
    final result = await _c.sendReply(text);
    if (!context.mounted) return;
    result.fold(
      (failure) => context.showCustomErrorSnackBar('feedback_sent_error'.tr),
      (reply) {
        ctrl.clear();
        // id فارغ = الرد في الطابور وسيُرسل عند عودة الاتصال.
        if (reply.id.isEmpty) {
          context.showCustomErrorSnackBar('feedback_queued'.tr, isDone: true);
        }
      },
    );
  }

  Widget _errorState(BuildContext context) {
    return Center(
      child: TextButton(onPressed: _c.loadAllThreads, child: Text('retry'.tr)),
    );
  }
}

class _ChatItem {
  final String body;
  final bool isAdmin;
  final String createdAt;
  final bool isOriginal;
  final List<String> mediaUrls;
  const _ChatItem({
    required this.body,
    required this.isAdmin,
    required this.createdAt,
    this.isOriginal = false,
    this.mediaUrls = const [],
  });
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.item});
  final _ChatItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final align = item.isAdmin
        ? AlignmentDirectional.centerStart
        : AlignmentDirectional.centerEnd;
    final bg = item.isAdmin
        ? colorScheme.surface.withValues(alpha: 0.2)
        : colorScheme.primary.withValues(alpha: 0.1);
    final roleLabel = item.isAdmin
        ? 'feedback_admin_role'.tr
        : 'feedback_you_role'.tr;
    final time = item.createdAt.isEmpty ? '' : _formatTime(item.createdAt);

    return Align(
      alignment: align,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        constraints: BoxConstraints(maxWidth: 280.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roleLabel,
              style: AppTextStyles.titleSmall(
                color: colorScheme.inversePrimary.withValues(alpha: 0.6),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(4.h),
            if (item.body.isNotEmpty)
              Text(
                item.body,
                style: AppTextStyles.titleMedium(
                  color: colorScheme.inversePrimary,
                  fontSize: 15.sp,
                ),
                textAlign: TextAlign.start,
              ),
            if (item.mediaUrls.isNotEmpty) ...[
              Gap(6.h),
              FeedbackMediaGallery(urls: item.mediaUrls),
            ],
            if (time.isNotEmpty) ...[
              Gap(4.h),
              Text(
                time,
                style: AppTextStyles.titleSmall(
                  color: colorScheme.inversePrimary.withValues(alpha: 0.5),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final local = dt.toLocal();
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(local.hour)}:${two(local.minute)}';
    } catch (_) {
      return '';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/utils/helpers/app_text_styles.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controller/feedback_controller.dart';
import '../data/models/feedback_thread.dart';
import 'feedback_conversation_screen.dart';
import 'widgets/feedback_send_sheet.dart';

/// شاشة "ملاحظاتي": قائمة بطاقات الملاحظات السابقة + زر لإرسال ملاحظة جديدة
/// عبر [customBottomSheet].
///
/// كل اللوجيك في [FeedbackController] — هذه الشاشة مجرد واجهة.
class FeedbackThreadScreen extends StatelessWidget {
  const FeedbackThreadScreen({super.key});

  FeedbackController get _c => FeedbackController.instance;

  @override
  Widget build(BuildContext context) {
    // تأكد من تحميل القائمة عند الفتح (يشمل بعد hot restart).
    WidgetsBinding.instance.addPostFrameCallback((_) => _c.ensureLoaded());
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openSendSheet(context),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.secondary,
        icon: const Icon(Icons.add),
        label: Text(
          'send_feedback'.tr,
          style: AppTextStyles.titleMedium(
            color: colorScheme.secondary,
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_c.isLoadingList.value && _c.threads.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!_c.hasFeedback || _c.threads.isEmpty) {
            return _emptyState(context);
          }
          return RefreshIndicator(
            onRefresh: _c.loadAllThreads,
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                16.w,
                8.h,
                16.w,
                96.h,
              ), // مساحة للـ FAB
              itemCount: _c.threads.length,
              separatorBuilder: (_, __) => Gap(10.h),
              itemBuilder: (context, index) {
                final thread = _c.threads[index];
                return _FeedbackCard(
                  thread: thread,
                  onTap: () => _openConversation(context, thread),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  /// يفتح شاشة المحادثة للبطاقة المضغوطة.
  void _openConversation(BuildContext context, FeedbackThread thread) {
    Get.to(
      () => const FeedbackConversationScreen(),
      transition: Transition.downToUp,
    )?.then((_) {
      // أعد تحميل القائمة عند العودة (قد تكون أضفت رداً).
      _c.loadAllThreads();
    });
    _c.openConversation(thread.feedback.token);
  }

  /// يفتح الـ bottom sheet للإرسال.
  void _openSendSheet(BuildContext context) {
    customBottomSheet(const FeedbackSendSheet());
  }

  Widget _emptyState(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox().customSvgWithColor(
              SvgPath.svgHomeEmail,
              height: 72,
              color: colorScheme.surface.withValues(alpha: 0.4),
            ),
            Gap(16.h),
            Text(
              'no_feedback_yet'.tr,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium(
                color: colorScheme.inversePrimary.withValues(alpha: 0.7),
                fontSize: 16.sp,
              ),
            ),
            Gap(20.h),
            CustomButton(
              onPressed: () => _openSendSheet(context),
              title: 'send_feedback',
              icon: Icons.add,
              iconSize: 22,
              svgColor: colorScheme.secondary,
              backgroundColor: colorScheme.surface,
              titleColor: colorScheme.secondary,
              height: 46,
              width: 200.w,
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة ملاحظة واحدة في القائمة.
class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.thread, required this.onTap});
  final FeedbackThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final f = thread.feedback;
    final (label, color) = _statusStyle(f.status);
    final preview = f.message;
    final adminCount = thread.replies.where((r) => r.isAdmin).length;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      label,
                      style: AppTextStyles.titleSmall(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (adminCount > 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14.sp,
                          color: colorScheme.inversePrimary.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        Gap(4.w),
                        Text(
                          '$adminCount',
                          style: AppTextStyles.titleSmall(
                            color: colorScheme.inversePrimary.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Gap(8.h),
              Text(
                preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium(
                  color: colorScheme.inversePrimary,
                  fontSize: 15.sp,
                ),
              ),
              Gap(6.h),
              Text(
                f.createdAt,
                style: AppTextStyles.titleSmall(
                  color: colorScheme.inversePrimary.withValues(alpha: 0.5),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
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
}

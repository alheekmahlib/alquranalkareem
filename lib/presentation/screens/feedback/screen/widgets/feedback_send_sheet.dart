import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constants/extensions/custom_error_snackBar.dart';
import '../../../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/utils/helpers/app_text_styles.dart';
import '../../../../../core/widgets/container_button.dart';
import '../../controller/feedback_controller.dart';

/// Bottom sheet لإرسال ملاحظة جديدة.
///
/// كل اللوجيك في [FeedbackController] — الـ widget يدير TextEditingControllers
/// المحلية فقط (تنظيف عند الإغلاق). يستخدم نفس ستايل شاشة التطبيق.
class FeedbackSendSheet extends StatefulWidget {
  const FeedbackSendSheet({super.key});

  @override
  State<FeedbackSendSheet> createState() => _FeedbackSendSheetState();
}

class _FeedbackSendSheetState extends State<FeedbackSendSheet> {
  final FeedbackController _c = FeedbackController.instance;
  final TextEditingController _messageCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final ValueNotifier<int> _charCount = ValueNotifier<int>(0);

  static const int _maxChars = 8000;

  @override
  void initState() {
    super.initState();
    _messageCtrl.addListener(() => _charCount.value = _messageCtrl.text.length);
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _emailCtrl.dispose();
    _charCount.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final result = await _c.submitFeedback(
      _messageCtrl.text,
      email: _emailCtrl.text,
      context: context,
    );
    if (!mounted) return;
    result.fold(
      (failure) => context.showCustomErrorSnackBar('feedback_sent_error'.tr),
      (_) {
        _messageCtrl.clear();
        _emailCtrl.clear();
        context.showCustomErrorSnackBar(
          'feedback_sent_success'.tr,
          isDone: true,
        );
        // أغلق الـ sheet ثم أعد تحميل القائمة.
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
        _c.loadAllThreads();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'feedback_subtitle'.tr,
            style: AppTextStyles.titleLarge(
              color: colorScheme.inversePrimary,
              fontSize: 18.sp,
            ),
          ),
          Gap(12.h),
          _messageField(context),
          ValueListenableBuilder<int>(
            valueListenable: _charCount,
            builder: (context, used, _) {
              final remaining = _maxChars - used;
              return Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  '$remaining ${'characters_remaining'.tr}',
                  style: AppTextStyles.titleSmall(
                    color: colorScheme.inversePrimary.withValues(alpha: 0.6),
                    fontSize: 12.sp,
                  ),
                ),
              );
            },
          ),
          Gap(12.h),
          _emailField(context),
          Gap(12.h),
          _mediaSection(context),
          Gap(16.h),
          ValueListenableBuilder<int>(
            valueListenable: _charCount,
            builder: (context, used, _) {
              final hasText = used > 0;
              return Obx(() {
                final busy = _c.isSubmitting.value;
                final uploading = _c.isUploading.value;
                final hasFiles = _c.selectedFiles.isNotEmpty;
                // مفعّل إن وُجد نص أو ملفات، ولسنا مشغولين.
                final enabled = (hasText || hasFiles) && !busy && !uploading;
                return Opacity(
                  opacity: enabled ? 1.0 : 0.5,
                  child: ContainerButton(
                    onPressed: enabled ? _submit : null,
                    title: 'send_feedback',
                    isButton: true,
                    width: double.infinity,
                    horizontalPadding: 8.0,
                    verticalPadding: 12.0,
                    backgroundColor: colorScheme.primary,
                    titleColor: colorScheme.secondary,
                    titleStyle: AppTextStyles.titleMedium(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                    child: busy
                        ? Padding(
                            padding: EdgeInsetsDirectional.only(start: 8.w),
                            child: SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.secondary,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                );
              });
            },
          ),
          Gap(16.h),
        ],
      ),
    );
  }

  Widget _mediaSection(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Obx(() {
      final files = _c.selectedFiles;
      final uploading = _c.isUploading.value;
      final progress = _c.uploadProgress.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صف الأزرار: + صور + فيديو + عدّاد.
          Row(
            children: [
              _pickerButton(
                context: context,
                icon: Icons.add_photo_alternate_outlined,
                label: 'feedback_pick_images',
                onPressed: uploading ? null : () => _pickImages(context),
              ),
              Gap(8.w),
              _pickerButton(
                context: context,
                icon: Icons.videocam_outlined,
                label: 'feedback_pick_video',
                onPressed: uploading ? null : () => _pickVideo(context),
              ),
              const Spacer(),
              Text(
                '${files.length}/${FeedbackController.maxFiles}',
                style: AppTextStyles.titleSmall(
                  color: colorScheme.inversePrimary.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          // شريط تقدّم الرفع.
          if (uploading) ...[
            Gap(8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor: colorScheme.surface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            Gap(4.h),
            Text(
              '${'feedback_uploading'.tr} ${(progress * 100).toInt()}%',
              style: AppTextStyles.titleSmall(
                color: colorScheme.inversePrimary.withValues(alpha: 0.6),
                fontSize: 11.sp,
              ),
            ),
          ],
          // شبكة المصغّرات.
          if (files.isNotEmpty) ...[
            Gap(8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(files.length, (i) {
                return _thumb(context, files[i], i);
              }),
            ),
          ],
        ],
      );
    });
  }

  Widget _pickerButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    final colorScheme = context.theme.colorScheme;
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18.sp, color: colorScheme.primary),
              Gap(4.w),
              Text(
                label.tr,
                style: AppTextStyles.titleSmall(
                  color: colorScheme.inversePrimary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// مصغّرة ملف واحد مع زر إزالة وشارة نوع.
  Widget _thumb(BuildContext context, File file, int index) {
    final isVideo = _c.isVideoFile(file);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: SizedBox(
            width: 72.w,
            height: 72.w,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(file, fit: BoxFit.cover),
                if (isVideo)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _c.removeFileAt(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 14.sp),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages(BuildContext context) async {
    final err = await _c.pickImages();
    if (err != null && context.mounted) {
      context.showCustomErrorSnackBar(err.tr);
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    final err = await _c.pickVideo();
    if (err != null && context.mounted) {
      context.showCustomErrorSnackBar(err.tr);
    }
  }

  Widget _messageField(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: _messageCtrl,
        maxLines: 8,
        minLines: 5,
        maxLength: _maxChars,
        // أخفِ الكيبورد عند الضغط خارج الحقل.
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: AppTextStyles.titleMedium(
          color: colorScheme.inversePrimary,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: 'feedback_message_hint'.tr,
          hintStyle: AppTextStyles.titleMedium(
            color: colorScheme.inversePrimary.withValues(alpha: 0.5),
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        // أخفِ الكيبورد عند الضغط خارج الحقل.
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        style: AppTextStyles.titleMedium(
          color: colorScheme.inversePrimary,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'feedback_contact_optional'.tr,
          hintStyle: AppTextStyles.titleMedium(
            color: colorScheme.inversePrimary.withValues(alpha: 0.5),
            fontSize: 16.sp,
          ),
          icon: const SizedBox().customSvgWithColor(
            SvgPath.svgHomeEmail,
            height: 22,
            color: colorScheme.surface,
          ),
        ),
      ),
    );
  }
}

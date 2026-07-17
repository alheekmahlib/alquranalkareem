import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/local_notification/widgets/notification_video_player.dart';

/// معرض وسائط رسالة feedback (صور + فيديو) — يُعرض داخل bubble المحادثة.
///
/// يعيد استخدام [NotificationVideoPlayer] الموجود لعرض الفيديو،
/// ويعرض الصور عبر `Image.network` مع عارض ملء الشاشة عند الضغط.
class FeedbackMediaGallery extends StatelessWidget {
  const FeedbackMediaGallery({super.key, required this.urls});

  /// قائمة روابط الوسائط.
  final List<String> urls;

  bool _isVideo(String url) {
    final lower = url.toLowerCase().split('?').first;
    return lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov');
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: urls.map((url) => _mediaThumb(context, url)).toList(),
    );
  }

  Widget _mediaThumb(BuildContext context, String url) {
    final isVideo = _isVideo(url);
    return GestureDetector(
      onTap: () => _openViewer(context, url, isVideo),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 120.w,
          height: 120.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return ColoredBox(
                    color: Theme.of(context).colorScheme.surface.withValues(
                      alpha: 0.1,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stack) => ColoredBox(
                  color: Theme.of(context).colorScheme.surface.withValues(
                    alpha: 0.1,
                  ),
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              if (isVideo)
                Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 36.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openViewer(BuildContext context, String url, bool isVideo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenMedia(url: url, isVideo: isVideo),
      ),
    );
  }
}

/// عارض ملء الشاشة للوسائط: فيديو عبر [NotificationVideoPlayer]،
/// صورة عبر `InteractiveViewer` للتكبير/التصغير.
class _FullScreenMedia extends StatelessWidget {
  const _FullScreenMedia({required this.url, required this.isVideo});
  final String url;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: isVideo
            ? Center(child: NotificationVideoPlayer(url: url))
            : InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    url,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stack) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

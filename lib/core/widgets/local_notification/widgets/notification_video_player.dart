import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:video_player/video_player.dart';

class NotificationVideoPlayer extends StatefulWidget {
  final String url;
  const NotificationVideoPlayer({super.key, required this.url});

  @override
  State<NotificationVideoPlayer> createState() => _NotificationVideoPlayerState();
}

class _NotificationVideoPlayerState extends State<NotificationVideoPlayer> {
  bool get _isGif {
    final lower = widget.url.toLowerCase();
    return lower.endsWith('.gif') || lower.contains('.gif?');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor.withValues(alpha: .15),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      child: _isGif ? _buildGif(context) : _buildVideo(context),
    );
  }

  Widget _buildGif(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.url,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.error_outline, color: Colors.grey, size: 40),
          ),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideo(BuildContext context) {
    return _VideoPlayer(url: widget.url);
  }
}

class _VideoPlayer extends StatefulWidget {
  final String url;
  const _VideoPlayer({required this.url});

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late final VideoPlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.setLooping(true);
    _controller.initialize().then((_) {
      if (mounted) {
        _controller.play();
        setState(() {});
      }
    }).catchError((e) {
      if (mounted) setState(() => _hasError = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.error_outline, color: Colors.grey, size: 40),
        ),
      );
    }
    if (!_controller.value.isInitialized) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        const Gap(8),
      ],
    );
  }
}

import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';

class AnimatedCounterButton extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int? min;
  final int? max;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? iconColor;
  final TextStyle? valueTextStyle;
  final double height;
  final Duration animationDuration;

  const AnimatedCounterButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
    this.backgroundColor,
    this.indicatorColor,
    this.iconColor,
    this.valueTextStyle,
    this.height = 36,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedCounterButton> createState() => _AnimatedCounterButtonState();
}

class _AnimatedCounterButtonState extends State<AnimatedCounterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  /// +1 = toward plus button, -1 = toward minus button
  double _direction = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Go out (0→peak) then bounce back (peak→0)
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 65,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canIncrease => widget.max == null || widget.value < widget.max!;
  bool get _canDecrease => widget.min == null || widget.value > widget.min!;

  void _onTap(int delta) {
    if (delta > 0 && !_canIncrease) return;
    if (delta < 0 && !_canDecrease) return;

    setState(() => _direction = delta.toDouble());
    _controller.forward(from: 0);
    widget.onChanged(widget.value + delta);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        widget.backgroundColor ?? theme.primaryColorLight.withValues(alpha: .2);
    final indicatorColor =
        widget.indicatorColor ??
        theme.colorScheme.primary.withValues(alpha: .25);
    final iconColor = widget.iconColor ?? theme.canvasColor;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Max horizontal offset the indicator can travel (in logical pixels)
    const double maxSlide = 14.0;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Plus button ──
          _CounterIconButton(
            icon: Icons.add_rounded,
            enabled: _canIncrease,
            color: iconColor,
            height: widget.height,
            onTap: () => _onTap(1),
          ),

          // ── Value with animated indicator ──
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              // Compute directional offset; flip sign for RTL so the
              // indicator always moves toward the physical button pressed.
              final visualDirection = isRtl ? _direction : -_direction;
              final dx = visualDirection * _animation.value * maxSlide;

              return SizedBox(
                width: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(dx, 0),
                      child: Container(
                        width: 32,
                        height: widget.height - 8,
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    child!,
                  ],
                ),
              );
            },
            child: Text(
              '${widget.value}',
              style:
                  widget.valueTextStyle ??
                  AppTextStyles.titleSmall(color: iconColor, height: .1),
            ),
          ),

          // ── Minus button ──
          _CounterIconButton(
            icon: Icons.remove_rounded,
            enabled: _canDecrease,
            color: iconColor,
            height: widget.height,
            onTap: () => _onTap(-1),
          ),
        ],
      ),
    );
  }
}

/// Small stateless button used for + and −.
class _CounterIconButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color color;
  final double height;
  final VoidCallback onTap;

  const _CounterIconButton({
    required this.icon,
    required this.enabled,
    required this.color,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: height,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: enabled ? onTap : null,
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: enabled ? color : color.withValues(alpha: .3),
            ),
          ),
        ),
      ),
    );
  }
}

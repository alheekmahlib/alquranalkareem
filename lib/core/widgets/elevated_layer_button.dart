import 'package:flutter/material.dart';

///
/// [ElevatedLayerButton] Renders Button layers in 3D perspective
///
class ElevatedLayerButton extends StatefulWidget {
  final double? buttonHeight;
  final double? buttonWidth;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final VoidCallback? onClick;
  final BoxDecoration? baseDecoration;
  final BoxDecoration? topDecoration;
  final Widget? topLayerChild;
  final BorderRadius? borderRadius;

  // Add index to each button
  final int index;

  const ElevatedLayerButton({
    Key? key,
    required this.buttonHeight,
    this.buttonWidth,
    required this.animationDuration,
    required this.animationCurve,
    required this.onClick,
    this.baseDecoration,
    this.topDecoration,
    this.topLayerChild,
    this.borderRadius,
    required this.index,
  }) : super(key: key);

  @override
  State<ElevatedLayerButton> createState() => _ElevatedLayerButtonState();
}

class _ElevatedLayerButtonState extends State<ElevatedLayerButton> {
  bool buttonPressed = false;
  bool animationCompleted = true;
  bool isClicked = false;

  bool get _enabled => widget.onClick != null;
  bool get _disabled => !_enabled;

  @override
  void initState() {
    super.initState();
    // Delay animation start based on index to create sequential effect
    Future.delayed(const Duration(seconds: 1)).then((_) =>
        Future.delayed(Duration(milliseconds: widget.index * 300)).then((_) {
          if (mounted) {
            setState(() {
              buttonPressed = true;
              animationCompleted = false;
            });
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _disabled ? 0.5 : 1,
      child: GestureDetector(
        onTap: () {
          if (!_disabled) {
            setState(() {
              buttonPressed = true;
              animationCompleted = false;
              isClicked = true;
            });
          }
        },
        child: SizedBox(
          height: widget.buttonHeight,
          width: widget.buttonWidth,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: (widget.buttonWidth ?? 100) - 10,
                  height: (widget.buttonHeight ?? 40) - 10,
                  decoration: widget.baseDecoration?.copyWith(
                        borderRadius: widget.borderRadius,
                      ) ??
                      BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black),
                      ),
                ),
              ),
              AnimatedPositioned(
                bottom: _enabled ? (buttonPressed ? 0 : 4) : 4,
                right: _enabled ? (buttonPressed ? 0 : 4) : 4,
                duration: widget.animationDuration ??
                    const Duration(milliseconds: 300),
                curve: widget.animationCurve ?? Curves.ease,
                onEnd: () {
                  if (!animationCompleted) {
                    animationCompleted = true;
                    setState(() => buttonPressed = false);
                    if (isClicked) {
                      widget.onClick!();
                    }
                  }
                },
                child: Container(
                  width: (widget.buttonWidth ?? 100) - 10,
                  height: (widget.buttonHeight ?? 100) - 10,
                  alignment: Alignment.center,
                  decoration: widget.topDecoration?.copyWith(
                        borderRadius: widget.borderRadius,
                      ) ??
                      BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black),
                      ),
                  child: widget.topLayerChild,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

library animated_stack;

import 'package:alquranalkareem/shared/widgets/settings_list.dart';
import 'package:alquranalkareem/shared/widgets/settings_popUp.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../custom_rect_tween.dart';
import '../hero_dialog_route.dart';



class AnimatedStack extends StatefulWidget {
  final double scaleWidth;
  final double scaleHeight;
  final Widget foregroundWidget;
  final Widget columnWidget;
  final Widget bottomWidget;
  final Color fabBackgroundColor;
  final Color? fabIconColor;
  final Color backgroundColor;
  final Duration buttonAnimationDuration;
  final Duration slideAnimationDuration;
  final Curve openAnimationCurve;
  final Curve closeAnimationCurve;
  final IconData buttonIcon;
  final bool animateButton;

  const AnimatedStack({
    Key? key,
    this.scaleWidth = 60,
    this.scaleHeight = 60,
    required this.fabBackgroundColor,
    required this.backgroundColor,
    required this.columnWidget,
    required this.bottomWidget,
    required this.foregroundWidget,
    this.slideAnimationDuration = const Duration(milliseconds: 800),
    this.buttonAnimationDuration = const Duration(milliseconds: 240),
    this.openAnimationCurve = const ElasticOutCurve(0.9),
    this.closeAnimationCurve = const ElasticInCurve(0.9),
    this.buttonIcon = Icons.add,
    this.animateButton = true,
    this.fabIconColor,
  })  : assert(scaleHeight >= 40),
        super(key: key);

  @override
  _AnimatedStackState createState() => _AnimatedStackState();
}

class _AnimatedStackState extends State<AnimatedStack> {
  // bool opened = false;

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    final double _fabPosition = 16;
    final double _fabSize = 56;

    final double _xScale =
        (widget.scaleWidth + _fabPosition * 5) * 100 / _width;
    final double _yScale =
        (widget.scaleHeight + _fabPosition * 2) * 100 / _height;
    return BlocConsumer<QuranCubit, QuranState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: Visibility(
            visible: QuranCubit.get(context).isShowControl,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 32.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => QuranCubit.get(context).opened = !QuranCubit.get(context).opened),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(8)
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 1.0,
                            spreadRadius: 0.0,
                            offset: Offset(0.0, 0.0), // shadow direction: bottom right
                          )
                        ],
                      ),

                      child: RotateAnimation(
                        opened: widget.animateButton ? QuranCubit.get(context).opened : false,
                        duration: widget.buttonAnimationDuration,
                        child: Icon(
                          widget.buttonIcon,
                          color: widget.fabIconColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          HeroDialogRoute(
                              builder: (context) {
                        return settingsPopupCard(
                            child: const SettingsList(),
                          height: orientation(context,
                              400.0,
                              MediaQuery.of(context).size.height * 1/2 * 1.6),
                          alignment: Alignment.topCenter,
                        );
                      }));
                    },
                    child: Hero(
                      tag: heroAddTodo,
                      createRectTween: (begin, end) {
                        return CustomRectTween(begin: begin!, end: end!);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(8)
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1.0,
                              spreadRadius: 0.0,
                              offset: Offset(0.0, 0.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.settings,
                          size: 28,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                color: widget.backgroundColor,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: _fabSize + _fabPosition * 4,
                      right: _fabPosition,
                      // width is used as max width to prevent overlap
                      child: SizedBox(
                          height: 600,
                          width: 120,
                          child: widget.columnWidget),
                    ),
                    Positioned(
                      right: widget.scaleWidth + _fabPosition * 2,
                      bottom: _fabPosition * 1.5,
                      // height is used as max height to prevent overlap
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: widget.scaleHeight - _fabPosition,
                        ),
                        child: widget.bottomWidget,
                      ),
                    ),
                  ],
                ),
              ),
              SlideAnimation(
                opened: QuranCubit.get(context).opened,
                xScale: _xScale,
                yScale: _yScale,
                // xScale: orientation(context, 40.0, 20.0),
                // yScale: orientation(context, 10.0, 25.0),
                duration: widget.slideAnimationDuration,
                child: widget.foregroundWidget,
              ),
            ],
          ),
        ),
      ),
    );
  },
);
  }
}

/// [opened] is a flag for forwarding or reversing the animation.
/// you can change the animation curves as you like, but you might need to
/// pay a close attention to [xScale] and [yScale], as they're setting
/// the end values of the animation tween.
class SlideAnimation extends StatefulWidget {
  final Widget child;
  final bool opened;
  final double xScale;
  final double yScale;
  final Duration duration;
  final Curve openAnimationCurve;
  final Curve closeAnimationCurve;

  const SlideAnimation({
    Key? key,
    required this.child,
    this.opened = false,
    required this.xScale,
    required this.yScale,
    required this.duration,
    this.openAnimationCurve = const ElasticOutCurve(0.9),
    this.closeAnimationCurve = const ElasticInCurve(0.9),
  }) : super(key: key);

  @override
  _SlideState createState() => _SlideState();
}

class _SlideState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> offset;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    offset = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: Offset(-widget.xScale * 0.01, -widget.yScale * 0.01),
    ).animate(
      CurvedAnimation(
        curve: Interval(
          0,
          1,
          curve: widget.openAnimationCurve,
        ),
        reverseCurve: Interval(
          0,
          1,
          curve: widget.closeAnimationCurve,
        ),
        parent: _animationController,
      ),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(SlideAnimation oldWidget) {
    widget.opened
        ? _animationController.forward()
        : _animationController.reverse();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offset,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// Used to rotate the [FAB], it will not be called when [animateButton] is false
/// [opened] is a flag for forwarding or reversing the animation.
class RotateAnimation extends StatefulWidget {
  final Widget child;
  final bool opened;
  final Duration duration;

  const RotateAnimation({
    Key? key,
    required this.child,
    this.opened = false,
    required this.duration,
  }) : super(key: key);

  @override
  _RotateState createState() => _RotateState();
}

class _RotateState extends State<RotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> rotate;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    rotate = Tween(
      begin: 0.0,
      end: 0.12,
    ).animate(
      CurvedAnimation(
        curve: const Interval(
          0,
          1,
          curve: Curves.easeIn,
        ),
        reverseCurve: Interval(
          0,
          1,
          curve: Curves.easeIn.flipped,
        ),
        parent: _animationController,
      ),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(RotateAnimation oldWidget) {
    widget.opened
        ? _animationController.forward()
        : _animationController.reverse();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: rotate,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

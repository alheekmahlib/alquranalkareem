import 'package:alquranalkareem/core/services/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/general_controller.dart';
import '../services/services_locator.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';
import 'settings_list.dart';
import 'settings_popUp.dart';
import 'widgets.dart';

class AnimatedStack extends StatelessWidget {
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

  // bool opened = false;

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.sizeOf(context).width;

    return GetBuilder<GeneralController>(builder: (controller) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: Obx(() {
              return Visibility(
                visible: sl<GeneralController>().isShowControl.value,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Semantics(
                        button: true,
                        enabled: true,
                        label: AppLocalizations.of(context)!.menu,
                        child: GestureDetector(
                          onTap: () {
                            sl<GeneralController>().opened.value =
                                !sl<GeneralController>().opened.value;
                            sl<GeneralController>().showSettings.value =
                                !sl<GeneralController>().showSettings.value;
                            sl<GeneralController>().update();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 1.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(0.0,
                                      0.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            child: RotateAnimation(
                              opened: animateButton
                                  ? sl<GeneralController>().opened.value
                                  : false,
                              duration: buttonAnimationDuration,
                              child: Icon(
                                buttonIcon,
                                color: fabIconColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // AnimatedPositioned(
                      //     width:
                      //         sl<SettingsController>().settingsSelected.value == false
                      //             ? 100
                      //             : MediaQuery.sizeOf(context).width,
                      //     height:
                      //         sl<SettingsController>().settingsSelected.value == false
                      //             ? 100.0
                      //             : 700.0,
                      //     // top: 50.0,
                      //     duration: const Duration(seconds: 1),
                      //     curve: Curves.fastOutSlowIn,
                      //     child: SettingsList()),
                      Semantics(
                        button: true,
                        enabled: true,
                        label: AppLocalizations.of(context)!.setting,
                        child: GestureDetector(
                          onTap: () {
                            sl<GeneralController>().showSettings.value = true;
                            Navigator.of(context)
                                .push(HeroDialogRoute(builder: (context) {
                              return settingsPopupCard(
                                child: const SettingsList(),
                                height: orientation(
                                    context,
                                    400.0,
                                    MediaQuery.sizeOf(context).height *
                                        1 /
                                        2 *
                                        1.6),
                                alignment: Alignment.topCenter,
                                padding: orientation(
                                    context,
                                    const EdgeInsets.only(
                                        right: 16.0, left: 16.0),
                                    EdgeInsets.only(
                                        top: 70.0,
                                        right: controller.scr_width * .5,
                                        left: 16.0)),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0,
                                        0.0), // shadow direction: bottom right
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
                      ),
                    ],
                  ),
                ),
              );
            }),
            body: Stack(
              children: <Widget>[
                Container(
                  color: backgroundColor,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: sl<GeneralController>().positionBottom,
                        right: sl<GeneralController>().positionRight,
                        // width is used as max width to prevent overlap
                        child: SizedBox(
                            height: 600, width: 120, child: columnWidget),
                      ),
                      Positioned(
                        right: 60 + sl<GeneralController>().positionRight * 2,
                        bottom: sl<GeneralController>().positionRight * 1.5,
                        // height is used as max height to prevent overlap
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: scaleHeight -
                                sl<GeneralController>().positionRight,
                          ),
                          child: bottomWidget,
                        ),
                      ),
                    ],
                  ),
                ),
                // Obx(
                //   () =>
                SlideAnimation(
                  opened: sl<GeneralController>().opened.value,
                  xScale: sl<GeneralController>().xScale!,
                  yScale: sl<GeneralController>().yScale!,
                  // xScale:
                  //     orientation(context, sl<GeneralController>().scr_width, 20.0),
                  // yScale: orientation(context, 10.0, 25.0),
                  duration: slideAnimationDuration,
                  child: GestureDetector(
                      onTap: () {
                        sl<GeneralController>().opened.value = false;
                        sl<GeneralController>().update();
                      },
                      child: foregroundWidget),
                ),
                // ),
              ],
            ),
          ),
        ),
      );
    });
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

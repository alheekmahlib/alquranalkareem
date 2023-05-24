import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';

import '../../shared/widgets/widgets.dart';

class Sliding extends StatefulWidget {
  final Widget? myWidget1;
  final Widget? myWidget2;
  final Widget? myWidget3;
  final Widget? myWidget4;
  final Widget? myWidget5;
  final double? cHeight;
  Sliding(
      {Key? key,
      required this.myWidget1,
      required this.myWidget2,
      required this.myWidget3,
      required this.myWidget4,
      required this.myWidget5,
      required this.cHeight})
      : super(key: key);

  @override
  State<Sliding> createState() => _SlidingState();
}

class _SlidingState extends State<Sliding> with SingleTickerProviderStateMixin {
  var mScaffoldKey = GlobalKey<ScaffoldState>();
  late SlidingUpPanelController _panelController;
  // late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    QuranCubit.get(context).panelController = SlidingUpPanelController();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 5),
    // );
  }

  @override
  void dispose() {
    // QuranCubit.get(context).panelController.dispose();
    // _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuranCubit>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: orientation(context,
            MediaQuery.of(context).size.height * 3 / 4 * 1.15,
            platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
        child: SlidingUpPanelWidget(
          controlHeight: widget.cHeight!,
          anchor: 7.0,
          panelController: cubit.panelController,
          // animationController: _animationController,
          onTap: () {
            if (SlidingUpPanelStatus.anchored == cubit.panelController.status) {
              cubit.panelController.collapse();
            } else {
              cubit.panelController.anchor();
            }
          },
          enableOnTap: false,
          child: Container(
            // margin: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: const ShapeDecoration(
              shadows: [
                BoxShadow(
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    color: Color(0x11000000))
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),

            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (SlidingUpPanelStatus.anchored == cubit.panelController.status) {
                      cubit.panelController.collapse();
                    } else {
                      cubit.panelController.anchor();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        )
                    ),
                    height: 65.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.drag_handle_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.myWidget1!,
                              widget.myWidget2!,
                              widget.myWidget3!,
                              widget.myWidget4!,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 0.5,
                ),
                Flexible(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: widget.myWidget5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextSliding extends StatefulWidget {
  final Widget? myWidget1;
  final double? cHeight;
  TextSliding(
      {Key? key,
      required this.myWidget1,
      required this.cHeight})
      : super(key: key);

  @override
  State<TextSliding> createState() => _TextSlidingState();
}

class _TextSlidingState extends State<TextSliding> with SingleTickerProviderStateMixin {
  var mScaffoldKey = GlobalKey<ScaffoldState>();
  late SlidingUpPanelController _panelController;
  // late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    QuranCubit.get(context).panelTextController = SlidingUpPanelController();
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 5),
    // );
  }

  @override
  void dispose() {
    // QuranCubit.get(context).panelTextController.dispose();
    // _animationController.dispose();
    super.dispose();
  }
  cancel() {
    final cubit = context.read<QuranCubit>();
    if (SlidingUpPanelStatus.hidden == cubit.panelTextController.status) {
      cubit.panelTextController.expand();
    } else {
      cubit.panelTextController.hide();
    }
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuranCubit>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: orientation(context,
            MediaQuery.of(context).size.height * 3 / 4 * 1.15,
            platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
        child: SlidingUpPanelWidget(
          controlHeight: widget.cHeight!,
          // anchor: 0.0,
          panelStatus: SlidingUpPanelStatus.hidden,
          panelController: cubit.panelTextController,
          // animationController: cubit.animationController,
          onTap: () {
            if (SlidingUpPanelStatus.hidden == cubit.panelTextController.status) {
              cubit.panelTextController.expand();
            } else {
              cubit.panelTextController.hide();
            }
          },
          enableOnTap: false,
          child: Container(
            // margin: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: const ShapeDecoration(
              shadows: [
                BoxShadow(
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    color: Color(0x11000000))
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),

            ),
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: widget.myWidget1),
          ),
        ),
      ),
    );
  }
}

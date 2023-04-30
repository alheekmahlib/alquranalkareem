import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:flutter/material.dart';
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

class _SlidingState extends State<Sliding> {
  var mScaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void dispose() {
  //   QuranCubit.get(context).panelController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    QuranCubit cubit = QuranCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: orientation(context,
            MediaQuery.of(context).size.height * 3 / 4,
            platformView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.height * 3/4)),
        child: SlidingUpPanelWidget(
          controlHeight: widget.cHeight!,
          anchor: 7.0,
          panelController: cubit.panelController,
          onTap: () {
            if (SlidingUpPanelStatus.anchored == cubit.panelController.status) {
              cubit.panelController.collapse();
            } else {
              cubit.panelController.anchor();
            }
          },
          enableOnTap: true,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
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
                Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).colorScheme.background,
                  height: 65.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

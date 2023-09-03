import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:get/get.dart';

import '../../shared/controller/general_controller.dart';
import '../../shared/widgets/widgets.dart';

class Sliding extends StatelessWidget {
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

  var mScaffoldKey = GlobalKey<ScaffoldState>();
  late final GeneralController generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: orientation(
            context,
            MediaQuery.of(context).size.height * 3 / 4 * 1.15,
            platformView(MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.height * 3 / 4)),
        child: SlidingUpPanelWidget(
          controlHeight: cHeight!,
          anchor: 7.0,
          panelController: generalController.panelController,
          onTap: () {
            if (SlidingUpPanelStatus.anchored ==
                generalController.panelController.status) {
              generalController.panelController.collapse();
            } else {
              generalController.panelController.anchor();
            }
          },
          enableOnTap: false,
          child: Container(
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
                    if (SlidingUpPanelStatus.anchored ==
                        generalController.panelController.status) {
                      generalController.panelController.collapse();
                    } else {
                      generalController.panelController.anchor();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        )),
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
                              myWidget1!,
                              myWidget2!,
                              myWidget3!,
                              myWidget4!,
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
                      child: myWidget5),
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
  const TextSliding({Key? key, required this.myWidget1, required this.cHeight})
      : super(key: key);

  @override
  State<TextSliding> createState() => _TextSlidingState();
}

class _TextSlidingState extends State<TextSliding>
    with SingleTickerProviderStateMixin {
  var mScaffoldKey = GlobalKey<ScaffoldState>();
  late final GeneralController generalController = Get.put(GeneralController());

  @override
  void initState() {
    super.initState();
    generalController.panelTextController = SlidingUpPanelController();
  }

  cancel() {
    if (SlidingUpPanelStatus.hidden ==
        generalController.panelTextController.status) {
      generalController.panelTextController.expand();
    } else {
      generalController.panelTextController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: orientation(
            context,
            MediaQuery.of(context).size.height * 3 / 4 * 1.15,
            platformView(MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.height * 3 / 4)),
        child: SlidingUpPanelWidget(
          controlHeight: widget.cHeight!,
          panelStatus: SlidingUpPanelStatus.hidden,
          panelController: generalController.panelTextController,
          onTap: () {
            if (SlidingUpPanelStatus.hidden ==
                generalController.panelTextController.status) {
              generalController.panelTextController.expand();
            } else {
              generalController.panelTextController.hide();
            }
          },
          enableOnTap: false,
          child: Container(
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

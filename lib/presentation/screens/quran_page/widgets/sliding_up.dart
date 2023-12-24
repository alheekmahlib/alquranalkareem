import 'package:alquranalkareem/presentation/screens/quran_page/widgets/audio_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:gap/gap.dart';

import '/core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!sl<GeneralController>().isPanelControllerDisposed) {
        // Your initialization logic if needed
      }
    });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: orientation(
            context,
            MediaQuery.sizeOf(context).height * .94,
            // 610.0,
            platformView(MediaQuery.sizeOf(context).height,
                MediaQuery.sizeOf(context).height * .9)),
        width: platformView(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).width * .6),
        child: SlidingUpPanelWidget(
          controlHeight: cHeight!,
          anchor: 7.0,
          panelController: sl<GeneralController>().panelController,
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
                Semantics(
                  button: true,
                  enabled: true,
                  label: AppLocalizations.of(context)!.onboardTitle2,
                  child: GestureDetector(
                    onTap: () {
                      sl<GeneralController>().slideWidgetSwitch(0);
                      if (!sl<GeneralController>().isPanelControllerDisposed) {
                        sl<GeneralController>().slideHandle();
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
                      // height: 65.0,
                      child: Column(
                        children: [
                          platformView(
                              orientation(context, AudioWidget(),
                                  const SizedBox.shrink()),
                              AudioWidget()),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                          const Gap(8)
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
                      height: MediaQuery.sizeOf(context).height,
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

class TextSliding extends StatelessWidget {
  final Widget? myWidget1;
  final double? cHeight;
  const TextSliding({Key? key, required this.myWidget1, required this.cHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: orientation(
            context,
            MediaQuery.sizeOf(context).height * 3 / 4 * 1.15,
            platformView(MediaQuery.sizeOf(context).height,
                MediaQuery.sizeOf(context).height * 3 / 4)),
        child: SlidingUpPanelWidget(
          controlHeight: cHeight!,
          panelStatus: SlidingUpPanelStatus.hidden,
          panelController: sl<GeneralController>().panelTextController,
          onTap: () {
            if (SlidingUpPanelStatus.hidden ==
                sl<GeneralController>().panelTextController.status) {
              sl<GeneralController>().panelTextController.expand();
            } else {
              sl<GeneralController>().panelTextController.hide();
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
                height: MediaQuery.sizeOf(context).height, child: myWidget1),
          ),
        ),
      ),
    );
  }
}

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

extension CustomErrorSnackBarExtension on BuildContext {
  void showCustomErrorSnackBar(String text) {
    BotToast.showCustomNotification(
      enableSlideOff: false,
      toastBuilder: (cancelFunc) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(this).colorScheme.primary, // Adapted to use context
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  'assets/svg/snackBar_zakh.svg',
                ),
              ),
              Expanded(
                flex: 7,
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Opacity(
                          opacity: .8,
                          child: SvgPicture.asset(
                            'assets/svg/alert.svg',
                            height: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          text,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'kufi',
                              fontStyle: FontStyle.italic,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset(
                    'assets/svg/snackBar_zakh.svg',
                  ),
                ),
              ),
            ],
          ),
        );
      },
      duration: const Duration(milliseconds: 3000),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';

class ArabicSlideCountdown extends StatelessWidget {
  final Duration duration;

  ArabicSlideCountdown({required this.duration});

  String _formatNumber(int number) {
    final formatter = NumberFormat.decimalPattern("ar");
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return SlideCountdownSeparated(
      duration: duration,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      slideDirection: SlideDirection.up,
      style: TextStyle(
        color: Theme.of(context).canvasColor,
        fontFamily: 'kufi',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      separatorType: SeparatorType.symbol,
      separator: ":",
      onChanged: (remainingTime) {
        // تحويل القيم لكل جزء من الوقت إلى أرقام عربية
        print(
          "${_formatNumber(remainingTime.inHours.remainder(24))}:${_formatNumber(remainingTime.inMinutes.remainder(60))}:${_formatNumber(remainingTime.inSeconds.remainder(60))}",
        );
      },
    );
  }
}

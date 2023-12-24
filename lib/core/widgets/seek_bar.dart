import 'dart:math';

import 'package:flutter/material.dart';

class SeekBar extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? valueIndicatorColor;
  final Color? textColor;
  final bool? timeShow;
  double? dragValue;
  final ValueChanged<double>? onDragValueChanged;
  final double? padding;

  SeekBar(
      {Key? key,
      required this.duration,
      required this.position,
      required this.bufferedPosition,
      this.onChanged,
      this.onChangeEnd,
      this.activeTrackColor,
      this.inactiveTrackColor,
      this.valueIndicatorColor,
      this.textColor,
      this.timeShow,
      this.dragValue,
      this.onDragValueChanged,
      this.padding})
      : super(key: key);

  late final SliderThemeData sliderThemeData;

  @override
  Widget build(BuildContext context) {
    // sl<SurahAudioController>().lastPosition.value = remaining.inSeconds.toDouble();
    final SliderThemeData sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
    return SizedBox(
      width: 250,
      child: Stack(
        children: [
          SizedBox(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                timeShow == true
                    ? Padding(
                        padding: EdgeInsets.only(top: padding ?? 36.0),
                        child: Text(
                            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                    .firstMatch("$remaining")
                                    ?.group(1) ??
                                '$remaining',
                            style: TextStyle(
                                color: textColor ??
                                    Theme.of(context).canvasColor)),
                      )
                    : const SizedBox.shrink(),
                timeShow == true
                    ? Padding(
                        padding: EdgeInsets.only(top: padding ?? 36.0),
                        child: Text(
                            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                    .firstMatch("$total")
                                    ?.group(1) ??
                                '$total',
                            style: TextStyle(
                                color: textColor ??
                                    Theme.of(context).canvasColor)),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Stack(
            children: [
              SliderTheme(
                data: sliderThemeData.copyWith(
                  thumbShape: HiddenThumbComponentShape(),
                  activeTrackColor:
                      activeTrackColor ?? Theme.of(context).canvasColor,
                  inactiveTrackColor:
                      inactiveTrackColor ?? Theme.of(context).dividerColor,
                  valueIndicatorColor:
                      inactiveTrackColor ?? Theme.of(context).canvasColor,
                ),
                child: ExcludeSemantics(
                  child: Slider(
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    value: min(bufferedPosition.inMilliseconds.toDouble(),
                        duration.inMilliseconds.toDouble()),
                    onChanged: (value) {
                      onDragValueChanged?.call(value);
                      if (onChanged != null) {
                        onChanged!(Duration(milliseconds: value.round()));
                      }
                    },
                    onChangeEnd: (value) {
                      if (onChangeEnd != null) {
                        onChangeEnd!(Duration(milliseconds: value.round()));
                      }
                      dragValue = null;
                    },
                  ),
                ),
              ),
              SliderTheme(
                data: sliderThemeData.copyWith(
                  inactiveTrackColor: Colors.transparent,
                ),
                child: Slider(
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble(),
                  value: min(dragValue ?? position.inMilliseconds.toDouble(),
                      duration.inMilliseconds.toDouble()),
                  onChanged: (value) {
                    onDragValueChanged?.call(value);
                    if (onChanged != null) {
                      onChanged!(Duration(milliseconds: value.round()));
                    }
                  },
                  onChangeEnd: (value) {
                    if (onChangeEnd != null) {
                      onChangeEnd!(Duration(milliseconds: value.round()));
                    }
                    dragValue = null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Duration get remaining => position;
  Duration get total => duration;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class pagePositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  pagePositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

T? ambiguate<T>(T? value) => value;

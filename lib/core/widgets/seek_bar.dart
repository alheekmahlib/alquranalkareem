import 'package:alquranalkareem/core/utils/constants/extensions/convert_number_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_paint/custom_slider.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class SliderWidget extends StatefulWidget {
  final Duration? duration;
  final Duration? position;
  // final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? valueIndicatorColor;
  final Color? textColor;
  final bool? timeShow;
  final double? padding;
  final double sliderHeight;
  final int min;
  final int max;
  final bool fullWidth;
  final double horizontalPadding;
  final double? currentPosition;
  final double? filesCount;

  factory SliderWidget.downloading({
    required int currentPosition,
    required int filesCount,
    required double horizontalPadding,
  }) {
    return SliderWidget(
      currentPosition: currentPosition.toDouble(),
      filesCount: filesCount.toDouble(),
      horizontalPadding: horizontalPadding,
    );
  }
  factory SliderWidget.player({
    required Duration position,
    required Duration duration,
    required double horizontalPadding,
    ValueChanged<Duration>? onChanged,
    ValueChanged<Duration>? onChangeEnd,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? valueIndicatorColor,
    Color? textColor,
    bool? timeShow,
    double? padding,
    double sliderHeight = 48,
    int max = 10,
    int min = 0,
    bool fullWidth = false,
  }) {
    return SliderWidget(
      position: position,
      duration: duration,
      horizontalPadding: horizontalPadding,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
      valueIndicatorColor: valueIndicatorColor,
      textColor: textColor,
      timeShow: timeShow,
      padding: padding,
      sliderHeight: sliderHeight,
      max: max,
      min: min,
      fullWidth: fullWidth,
    );
  }

  SliderWidget({
    this.currentPosition = 0,
    this.filesCount,
    this.duration,
    this.position,
    // required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.valueIndicatorColor,
    this.textColor,
    this.timeShow,
    this.padding,
    this.sliderHeight = 48,
    this.max = 10,
    this.min = 0,
    this.fullWidth = false,
    required this.horizontalPadding,
  });

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _sliderValue = 0;
  @override
  void initState() {
    super.initState();
    _sliderValue =
        widget.position?.inMilliseconds.toDouble() ?? widget.currentPosition!;
  }

  @override
  Widget build(BuildContext context) {
    _sliderValue = (widget.position?.inMilliseconds.toDouble() ??
            widget.currentPosition!)
        .clamp(0.0,
            widget.duration?.inMilliseconds.toDouble() ?? widget.filesCount!);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: widget.activeTrackColor ??
                    Theme.of(context).colorScheme.primary,
                inactiveTrackColor: widget.inactiveTrackColor ??
                    Theme.of(context).colorScheme.surface,
                thumbShape: CustomSliderThumbRect(
                  thumbRadius: 20,
                  thumbHeight: 15.0,
                  min: widget.min,
                  max: widget.max,
                ),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 10.0),
              ),
              child: Slider(
                min: 0.0,
                max: widget.duration?.inMilliseconds.toDouble() ??
                    widget.filesCount!,
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                },
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -8),
            child: widget.filesCount != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      'downloading'.tr,
                      style: TextStyle(
                        color:
                            widget.textColor ?? Theme.of(context).canvasColor,
                        fontSize: 16,
                        fontFamily: 'kufi',
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          (RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                      .firstMatch("$remaining")
                                      ?.group(1) ??
                                  '$remaining')
                              .convertNumbers(),
                          style: TextStyle(
                            color: widget.textColor ??
                                Theme.of(context).canvasColor,
                            fontSize: 16,
                            fontFamily: 'kufi',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          (RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                      .firstMatch("$total")
                                      ?.group(1) ??
                                  '$total')
                              .convertNumbers(),
                          style: TextStyle(
                            color: widget.textColor ??
                                Theme.of(context).canvasColor,
                            fontSize: 16,
                            fontFamily: 'kufi',
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Duration? get remaining => widget.position;
  Duration? get total => widget.duration;
}

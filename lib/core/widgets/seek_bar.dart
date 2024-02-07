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
  final double? padding;
  final double sliderHeight;
  final int min;
  final int max;
  final bool fullWidth;
  final double horizontalPadding;

  SliderWidget({
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
    _sliderValue = widget.position.inMilliseconds.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    _sliderValue = widget.position.inMilliseconds
        .toDouble()
        .clamp(0.0, widget.duration.inMilliseconds.toDouble());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor:
                      widget.activeTrackColor ?? Get.theme.colorScheme.primary,
                  inactiveTrackColor: widget.inactiveTrackColor ??
                      Theme.of(context).dividerColor,
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
                  max: widget.duration.inMilliseconds.toDouble(),
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
                      widget
                          .onChangeEnd!(Duration(milliseconds: value.round()));
                    }
                  },
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                        RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                .firstMatch("$remaining")
                                ?.group(1) ??
                            '$remaining',
                        style: TextStyle(
                            color: widget.textColor ??
                                Theme.of(context).canvasColor)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                        RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                .firstMatch("$total")
                                ?.group(1) ??
                            '$total',
                        style: TextStyle(
                            color: widget.textColor ??
                                Theme.of(context).canvasColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Duration get remaining => widget.position;
  Duration get total => widget.duration;
}

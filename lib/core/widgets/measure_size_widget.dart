import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final Function(Size) onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child!.size;
    if (oldSize == newSize) return;
    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSizeWidget extends SingleChildRenderObjectWidget {
  final Function(Size) onChange;

  const MeasureSizeWidget({
    super.key,
    required this.onChange,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}

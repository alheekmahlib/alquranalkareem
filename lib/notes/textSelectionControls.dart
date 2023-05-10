import 'package:flutter/material.dart';

class MyTextSelectionControls extends TextSelectionControls {
  final TextEditingController textEditingController;
  final VoidCallback addNote;

  MyTextSelectionControls({required this.textEditingController, required this.addNote});

  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type,
      double textLineHeight, [void Function()? onTap]) {
    final ThemeData theme = Theme.of(context);
    final Color handleColor = theme.textSelectionTheme.selectionHandleColor ?? Colors.blue;

    switch (type) {
      case TextSelectionHandleType.left:
        return _buildHandle(context, Icons.arrow_left, handleColor);
      case TextSelectionHandleType.right:
        return _buildHandle(context, Icons.arrow_right, handleColor);
      case TextSelectionHandleType.collapsed:
        return _buildHandle(context, Icons.circle, handleColor);
    }
  }

  Widget _buildHandle(
      BuildContext context, IconData icon, Color handleColor) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: handleColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset selectionMidpoint,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier? clipboardStatus,
      Offset? globalSelectionOffset) {
    return Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(7.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () => handleCopy(delegate, clipboardStatus),
          ),
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: () => handleSelectAll(delegate),
          ),
          IconButton(
            icon: const Icon(Icons.note_add),
            onPressed: addNote,
          ),
        ],
      ),
    );
  }




  @override
  Widget buildSelectionHandle(BuildContext context,
      {required TextSelectionHandleType type,
        required double textLineHeight,
        required double selectionHandleWidth,
        required void Function()? onTap}) {
    // TODO: Implement this method
    throw UnimplementedError('buildSelectionHandle() has not been implemented');
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return const Size(22, 22);
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight, [void Function()? onTap]) {
    final Size handleSize = getHandleSize(textLineHeight);
    switch (type) {
      case TextSelectionHandleType.collapsed:
        return Offset(handleSize.width / 2, handleSize.height / 2);
      case TextSelectionHandleType.left:
        return Offset(handleSize.width / 2, handleSize.height);
      case TextSelectionHandleType.right:
        return Offset(handleSize.width / 2, handleSize.height);
    }
  }
}

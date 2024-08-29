import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../../core/utils/constants/svg_constants.dart';

class TextFieldBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final void Function()? onPressed;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final double? horizontalPadding;
  TextFieldBarWidget(
      {super.key,
      this.controller,
      this.hintText,
      this.prefixIcon,
      this.onPressed,
      this.onChanged,
      this.onSubmitted,
      this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
          vertical: 8.0, horizontal: horizontalPadding ?? 32.0),
      child: SizedBox(
        height: 50,
        width: context.customOrientation(MediaQuery.sizeOf(context).width * .7,
            MediaQuery.sizeOf(context).width * .5),
        child: TextField(
          controller: controller,
          maxLines: 1,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'naskh',
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor.withOpacity(.7),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: hintText ?? 'search_word'.tr,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'kufi',
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.surface.withOpacity(.3),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.primaryContainer,
            prefixIcon: prefixIcon ??
                Container(
                  height: 20,
                  padding: const EdgeInsets.all(10.0),
                  child: customSvg(
                    SvgPath.svgSearchIcon,
                    height: 35,
                  ),
                ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).hintColor,
              ),
              onPressed: onPressed,
            ),
            labelText: hintText ?? 'search_word'.tr,
            labelStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'kufi',
              color: Theme.of(context).hintColor.withOpacity(.7),
            ),
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ),
    );
  }
}

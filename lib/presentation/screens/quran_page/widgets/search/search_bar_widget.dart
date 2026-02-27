part of '../../quran.dart';

class TextFieldBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final void Function()? onPressed;
  final void Function()? onButtonPressed;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final double? horizontalPadding;
  TextFieldBarWidget({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.onPressed,
    this.onChanged,
    this.onSubmitted,
    this.horizontalPadding,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: horizontalPadding ?? 32.0,
      ),
      child: SizedBox(
        height: 40,
        width: Get.width,
        child: TextField(
          controller: controller,
          maxLines: 1,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'naskh',
            fontWeight: FontWeight.w600,
            color: context.theme.hintColor.withValues(alpha: .7),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: hintText ?? 'search_word'.tr,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.theme.primaryColorLight,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'kufi',
              fontWeight: FontWeight.w600,
              color: context.theme.colorScheme.surface.withValues(alpha: .3),
            ),
            filled: true,
            fillColor: context.theme.primaryColorDark.withValues(alpha: 0.3),
            prefixIcon:
                prefixIcon ??
                Container(
                  height: 20,
                  padding: const EdgeInsets.all(10.0),
                  child: customSvgWithCustomColor(
                    SvgPath.svgSearchIcon,
                    height: 35,
                  ),
                ),
            suffixIcon: IconButton(
              icon: Icon(Icons.close, color: context.theme.hintColor),
              onPressed: onButtonPressed,
            ),
            labelText: hintText ?? 'search_word'.tr,
            labelStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'kufi',
              color: context.theme.hintColor.withValues(alpha: .7),
            ),
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onPressed,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ),
    );
  }
}

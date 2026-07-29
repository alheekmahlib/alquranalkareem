part of '../books.dart';

class IslamicLibraryLogo extends StatelessWidget {
  final double logoHeight;
  const IslamicLibraryLogo({super.key, this.logoHeight = 40.0});

  @override
  Widget build(BuildContext context) {
    return Get.locale!.languageCode == 'ar'
        ? customSvgWithCustomColor(
            SvgPath.svgBooksIslamicLibrary,
            height: logoHeight,
            color: context.theme.colorScheme.surface,
          )
        : Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'islamicLibrary'.tr.replaceAll(' ', '\n'),
                style: AppTextStyles.titleMedium(
                  color: context.theme.colorScheme.surface,
                  fontSize: logoHeight - 20,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}

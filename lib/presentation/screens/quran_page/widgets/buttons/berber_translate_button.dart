part of '../../quran.dart';

/// زر الترجمة الأمازيغية — يفتح نافذة مخصصة للترجمة
/// Berber Translation Button — opens a custom bottom sheet for Berber translation
class BerberTranslateButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final String ayahText;
  final int pageIndex;
  final String ayahTextNormal;
  final int ayahUQNum;
  final Function? cancel;

  const BerberTranslateButton({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahText,
    required this.pageIndex,
    required this.ayahTextNormal,
    required this.ayahUQNum,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      width: 90,
      iconWidget: Text(
        'ⵣ ' + 'amazigh'.tr,
        style: TextStyle(
          fontSize: 12,
          color: context.theme.hintColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      svgColor: context.theme.hintColor,
      onPressed: () {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          enableDrag: true,
          isDismissible: true,
          constraints: BoxConstraints(
            maxHeight: Responsive.isDesktop(context)
                ? Get.height * .9
                : context.customOrientation(Get.height * .9, Get.height),
            maxWidth: MediaQuery.of(context).size.width,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => BerberTranslateSheet(
            surahNum: surahNum,
            ayahNum: ayahNum,
            ayahTextNormal: ayahTextNormal,
          ),
        );
        QuranController.instance.state.isPages.value == 1
            ? null
            : cancel?.call();
      },
    );
  }
}

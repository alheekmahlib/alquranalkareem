part of '../quran.dart';

/// نافذة سفلية مخصصة للترجمة الأمازيغية
/// Custom bottom sheet for Berber translation
class BerberTranslateSheet extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final String ayahTextNormal;

  const BerberTranslateSheet({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahTextNormal,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeController.instance.isDarkMode;

    final primary = Get.theme.colorScheme.primary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 8),
              // خط فاصل جمالي (Decorative Handle)
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              // شريط علوي (Top Header Bar)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasuqilt Tamaziɣt', // Berber title
                      style: QuranLibrary().cairoStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 8),
                        const SizedBox()
                            .fontSizeDropDownWidget(), // Ensure we use the extension on a Widget
                      ],
                    ),
                  ],
                ),
              ),
              // محتوى الترجمة (Translation Content)
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF151515)
                        : Get.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: GetBuilder<TafsirCtrl>(
                      id: 'change_font_size',
                      builder: (tafsirCtrl) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Ayah Arabic text rendered exactly like ActualTafsirWidget
                            GetSingleAyah(
                              surahNumber: surahNum,
                              ayahNumber: ayahNum,
                              fontSize:
                                  tafsirCtrl.fontSizeArabic.value +
                                  2, // Slight bump to match usual proportions
                              isBold: false,
                              isSingleAyah: true,
                              isDark: isDark,
                              textColor: isDark ? Colors.white : Colors.black87,
                              useDefaultFont: true,
                            ),
                            const SizedBox(height: 16),
                            // Divider exactly matching quran_library styling
                            Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  WidgetSpan(
                                    child: context.horizontalDivider(
                                      color: isDark
                                          ? Colors.grey.shade800
                                          : Colors.grey.withValues(alpha: 0.3),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 16),
                            // Placeholder for Berber translation
                            Text(
                              'Aḥric n tsuqilt tamaziɣt dagi...\n\n(Berber Translation will go here)',
                              style: TextStyle(
                                fontFamily: 'kufi',
                                color: isDark ? Colors.white : Colors.black87,
                                // Translation font size is typically slightly smaller than Arabic
                                fontSize: tafsirCtrl.fontSizeArabic.value - 2,
                                height: 1.6,
                              ),
                              textAlign: TextAlign
                                  .right, // RTL for Berber in Arabic script or simply right-aligned
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

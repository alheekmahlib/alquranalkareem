part of '../quran.dart';

class _TajweedAyaTab extends StatelessWidget {
  const _TajweedAyaTab({
    required this.ayahUQNumber,
    required this.ayahNumber,
    required this.quranCtrl,
    required this.tajweedCtrl,
    required this.isDark,
    required this.tafsirStyle,
  });

  final int ayahUQNumber;
  final int ayahNumber;
  final QuranCtrl quranCtrl;
  final TajweedAyaCtrl tajweedCtrl;
  final bool isDark;
  final TafsirStyle tafsirStyle;

  @override
  Widget build(BuildContext context) {
    final ayah = quranCtrl.getAyahByUq(ayahUQNumber);

    // ملاحظة: عند استخدام بيانات الخطوط المنزلة قد يكون surahNumber = null.
    // لذلك نستخدم fallback عبر فهرس السور في QuranCtrl.
    int surahNumber = ayah.surahNumber ?? 0;
    if (surahNumber == 0 && ayahUQNumber != 0) {
      try {
        surahNumber = quranCtrl.getSurahDataByAyahUQ(ayahUQNumber).surahNumber;
      } catch (_) {
        surahNumber = 0;
      }
    }

    if (surahNumber == 0) {
      return Center(
        child: Text(
          tafsirStyle.tajweedSurahNumberErrorText ?? 'تعذّر تحديد رقم السورة',
          style:
              tafsirStyle.tajweedStatusTextStyle ??
              TextStyle(
                fontSize: 14,
                color: tafsirStyle.textColor,
                fontFamily: 'cairo',
                package: 'quran_library',
              ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (tajweedCtrl.isAvailable) {
      Future(() => tajweedCtrl.prewarmSurah(surahNumber));
    }
    final surahs = quranCtrl.getCurrentSurahByPageNumber(ayah.page);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: tafsirStyle.verticalMargin ?? 8,
        horizontal: tafsirStyle.horizontalMargin ?? 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tafsirStyle.tafsirBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
        border: Border.symmetric(
          horizontal: BorderSide(
            color:
                tafsirStyle.unSelectedTafsirBorderColor ??
                (tafsirStyle.dividerColor ??
                    Colors.grey.withValues(alpha: 0.3)),
            width: 1.2,
          ),
        ),
      ),
      child: GetBuilder<TajweedAyaCtrl>(
        id: 'tajweed_download',
        builder: (_) {
          final isAvailable = tajweedCtrl.isAvailable;

          if (!isAvailable) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tafsirStyle.tajweedUnavailableText ??
                        'بيانات أحكام التجويد غير محمّلة.',
                    style:
                        tafsirStyle.tajweedStatusTextStyle ??
                        TextStyle(
                          fontSize: 14,
                          color: context.theme.colorScheme.inversePrimary,
                          fontFamily: 'cairo',
                          package: 'quran_library',
                        ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),
                  tafsirStyle.tajweedDownloadButtonWidget!,
                ],
              ),
            );
          }

          return GetBuilder<TajweedAyaCtrl>(
            id: 'tajweed_data',
            builder: (_) {
              final f = tajweedCtrl.getAyahInfo(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
              );

              return FutureBuilder<TajweedAyahInfo?>(
                future: f,
                builder: (ctx, snap) {
                  // if (snap.connectionState == ConnectionState.waiting) {
                  //   return const Center(
                  //       child: CircularProgressIndicator.adaptive());
                  // }

                  if (snap.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '${tafsirStyle.tajweedLoadErrorText ?? 'تعذّر تحميل أحكام التجويد.'}\n${snap.error}',
                        style:
                            tafsirStyle.tajweedStatusTextStyle ??
                            TextStyle(
                              fontSize: 14,
                              color: context.theme.colorScheme.inversePrimary,
                              fontFamily: 'cairo',
                              package: 'quran_library',
                            ),
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  }

                  final data = snap.data;
                  if (data == null || data.content.trim().isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        tafsirStyle.tajweedNoDataText ??
                            'لا توجد بيانات تجويد لهذه الآية.',
                        style:
                            tafsirStyle.tajweedStatusTextStyle ??
                            TextStyle(
                              fontSize: 14,
                              color: context.theme.colorScheme.inversePrimary,
                              fontFamily: 'cairo',
                              package: 'quran_library',
                            ),
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    // padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        GetSingleAyah(
                          surahNumber: surahs.surahNumber,
                          ayahNumber: data.ayaNumber,
                          fontSize: 24,
                          isBold: false,
                          isSingleAyah: false,
                          isDark: isDark,
                          textColor: tafsirStyle.textColor,
                          textAlign: TextAlign.center,
                          enabledTajweed:
                              QuranCtrl.instance.state.isTajweedEnabled.value,
                        ),
                        const SizedBox(height: 6),
                        context.horizontalDivider(
                          color: tafsirStyle.dividerColor,
                          height: 1.5,
                        ),
                        const SizedBox(height: 6),
                        SelectableText.rich(
                          buildMarkedContentSpan(
                            content: data.content,
                            baseStyle:
                                tafsirStyle.tajweedContentTextStyle ??
                                TextStyle(
                                  fontSize: 22,
                                  height: 1.7,
                                  color:
                                      context.theme.colorScheme.inversePrimary,
                                  fontFamily: 'naskh',
                                  package: 'quran_library',
                                ),
                            markedStyle:
                                tafsirStyle.tajweedMarkedTextStyle ??
                                const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

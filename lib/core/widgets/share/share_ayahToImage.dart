import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';
import 'package:screenshot/screenshot.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../presentation/screens/quran_page/quran.dart';
import '../../utils/constants/extensions/extensions.dart';
import '../../utils/constants/svg_constants.dart';
import '../../utils/helpers/app_text_styles.dart';

class VerseImageCreator extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;

  /// آيات إضافية لعرضها بعد [ayah] في نفس الصورة.
  /// عند `null` أو فارغة يُعرض آية واحدة فقط.
  final List<AyahModel>? extraAyahs;

  /// إظهار أحكام التجويد أسفل نص الآية (آية مفردة فقط).
  final bool showTajweedRules;

  /// متحكم التقاط خاص بهذه المعاينة. لا يُستخدم متحكم مشترك هنا حتى لا
  /// تتضارب الـ GlobalKey إذا ظهرت أكثر من معاينة في الشجرة في نفس الوقت
  /// (مثل تكديس صفحات family_bottom_sheet).
  final ScreenshotController controller;

  VerseImageCreator({
    super.key,
    required this.ayah,
    required this.surah,
    this.extraAyahs,
    this.showTajweedRules = false,
    ScreenshotController? controller,
  }) : controller = controller ?? ScreenshotController();

  /// كل الآيات المعروضة (الأولى + الإضافية)
  List<AyahModel> get _allAyahs => extraAyahs == null || extraAyahs!.isEmpty
      ? [ayah]
      : [ayah, ...extraAyahs!];

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller,
      child: buildVerseImageWidget(context: context),
    );
  }

  Widget buildVerseImageWidget({required BuildContext context}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 960.0,
        decoration: BoxDecoration(color: context.theme.colorScheme.primary),
        child: Column(
          children: [
            const Gap(8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const Gap(8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        customSvgWithColor(
                          SvgPath.svgQuranSurahBanner,
                          color: context.theme.colorScheme.primary,
                        ),
                        surahNameWidget(
                          height: 30,
                          '${surah.surahNumber}',
                          context.theme.colorScheme.inversePrimary,
                        ),
                      ],
                    ),
                    const Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 928.0,
                        child: _buildAyahsText(context),
                      ),
                    ),
                    if (showTajweedRules) _buildTajweedRules(context),
                    const Gap(4),
                  ],
                ),
              ),
            ),
            const Gap(4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customSvg(SvgPath.svgHomeQuranLogo, height: 30),
                  context.vDivider(),
                  Text(
                    'القرآن الكريـم - مكتبة الحكمة',
                    style: AppTextStyles.titleSmall(
                      fontSize: 10,
                      color: context.theme.canvasColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const Gap(4),
          ],
        ),
      ),
    );
  }

  /// أحكام التجويد أسفل نص الآية — تُعرض للآية المفردة فقط عند تفعيل الخيار.
  /// غياب البيانات أو فشل تحميلها يخفي القسم ولا يعطل المشاركة.
  Widget _buildTajweedRules(BuildContext context) {
    return FutureBuilder<TajweedAyahInfo?>(
      future: TajweedAyaCtrl.instance.getAyahInfo(
        surahNumber: surah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      ),
      builder: (context, snap) {
        final data = snap.data;
        if (snap.hasError || data == null || data.content.trim().isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const Gap(4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface.withValues(
                    alpha: .2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  'tajweedRules'.tr,
                  style: AppTextStyles.titleMedium(
                    fontSize: 16,
                    color: context.theme.colorScheme.inversePrimary.withValues(
                      alpha: .7,
                    ),
                  ),
                ),
              ),
              const Gap(4),
              Text.rich(
                buildMarkedContentSpan(
                  content: data.content,
                  baseStyle: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: context.theme.colorScheme.inversePrimary,
                    fontFamily: 'naskh',
                    package: 'quran_library',
                  ),
                  markedStyle: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: context.theme.colorScheme.surface,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'naskh',
                    package: 'quran_library',
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
  }

  /// يبني نص الآية/الآيات — مفردة أو متعددة
  Widget _buildAyahsText(BuildContext context) {
    final ayahs = _allAyahs;
    final textColor = context.theme.colorScheme.inversePrimary;
    final isTajweed = QuranCtrl.instance.state.isTajweedEnabled.value;

    // آية واحدة: استخدم GetSingleAyah كما كان
    if (ayahs.length == 1) {
      return GetSingleAyah(
        surahNumber: surah.surahNumber,
        ayahNumber: ayahs.first.ayahNumber,
        fontSize: 22,
        isDark: themeCtrl.isDarkMode,
        textColor: textColor,
        enabledTajweed: isTajweed,
        textAlign: TextAlign.center,
      );
    }

    // عدة آيات: اجمع segments لكل الآيات في نص متصل واحد
    final quranModel = QuranCtrl.instance;
    final List<QpcV4WordSegment> allSegments = [];
    final Map<int, int> ayahPageMap = {};

    for (final a in ayahs) {
      final ayahData = quranModel.getSingleAyahByAyahAndSurahNumber(
        a.ayahNumber,
        surah.surahNumber,
      );
      ayahPageMap[a.ayahNumber] = ayahData.page;
      final blocks = quranModel.getQpcLayoutBlocksForPageSync(ayahData.page);
      for (final block in blocks) {
        if (block is QpcV4AyahLineBlock) {
          for (final seg in block.segments) {
            if (seg.surahNumber == surah.surahNumber &&
                seg.ayahNumber == a.ayahNumber) {
              allSegments.add(seg);
            }
          }
        }
      }
    }

    // fallback إذا لم يتم العثور على segments
    if (allSegments.isEmpty) {
      return Text(
        ayahs.map((a) => a.text).join(' '),
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: textColor,
          fontFamily: 'uthmanic2',
          fontSize: 22,
        ),
      );
    }

    // نص متصل واحد — الآيات تتدفق بشكل طبيعي
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      softWrap: true,
      text: TextSpan(
        children: allSegments.expand((seg) {
          final segPageIndex = (ayahPageMap[seg.ayahNumber] ?? 1) - 1;
          final spans = <InlineSpan>[
            TextSpan(
              text: seg.glyphs,
              style: TextStyle(
                fontFamily: quranModel.getFontPath(segPageIndex),
                fontSize: 16.sp,
                height: 2.0,
                color: const Color(0xff161f07),
              ),
            ),
          ];
          if (seg.isAyahEnd) {
            spans.add(
              TextSpan(
                text: '${seg.ayahNumber}'.convertEnglishNumbersToArabic(
                  '${seg.ayahNumber}\u202F\u202F',
                ),
                style: TextStyle(
                  fontFamily: 'ayahNumber',
                  package: 'quran_library',
                  fontSize: 18.sp,
                  height: 2.0,
                ),
              ),
            );
          }
          return spans;
        }).toList(),
      ),
    );
  }
}

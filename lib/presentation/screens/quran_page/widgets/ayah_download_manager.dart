part of '../quran.dart';

/// إدارة تحميل/حذف آيات السور حسب القارئ الحالي — بنمط تصميم التطبيق
///
/// تعتمد على [QuranSurahList] في تصميم الصفوف، و[ContainerButton] في
/// الأزرار وحالة التحميل، و[AyahChangeReader] لتغيير القارئ كما في المكتبة.
class AyahDownloadManager extends StatelessWidget {
  const AyahDownloadManager({
    super.key,
    required this.onRequestDownload,
    required this.onRequestDelete,
    this.isDark = false,
    this.ayahStyle,
  });

  final Future<void> Function(int surahNumber) onRequestDownload;
  final Future<void> Function(int surahNumber) onRequestDelete;
  final bool? isDark;
  final AyahAudioStyle? ayahStyle;

  @override
  Widget build(BuildContext context) {
    final surahs = QuranCtrl.instance.surahs;
    return SizedBox(
      height: context.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16.0),
                itemCount: surahs.length,
                itemBuilder: (_, index) =>
                    _buildSurahRow(context, surahs[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// رأس الشيت: العنوان + الفاصل + تغيير القارئ (كما في المكتبة)
  Widget _buildHeader(BuildContext context) {
    final bool dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    final AyahAudioStyle effectiveAyahStyle =
        ayahStyle ?? AyahAudioStyle.defaults(isDark: dark, context: context);
    return Column(
      children: [
        Center(
          child: Text(
            'manager_ayah_downloads'.tr,
            style: AppTextStyles.titleMedium(),
          ),
        ),
        const Gap(4),
        Divider(
          thickness: 1.0,
          height: 1.0,
          endIndent: 32.0,
          indent: 32.0,
          color: Theme.of(context).primaryColorLight.withValues(alpha: .5),
        ),
        const Gap(10),
        AyahChangeReader(style: effectiveAyahStyle, isDark: isDark),
        const Gap(8),
      ],
    );
  }

  /// صف سورة بنمط [QuranSurahList] مع حالة التحميل وزر الإجراء
  Widget _buildSurahRow(BuildContext context, SurahModel surah) {
    return GetBuilder<AudioCtrl>(
      id: 'ayahDownloadManager',
      builder: (audioCtrl) {
        int downloaded = 0;
        for (final ayah in surah.ayahs) {
          if (audioCtrl.state.ayahsDownloadStatus[ayah.ayahUQNumber] == true) {
            downloaded++;
          }
        }
        final total = surah.ayahs.length;
        final progress = total == 0 ? 0.0 : downloaded / total;
        final fullyDownloaded = total > 0 && downloaded == total;
        final isBusy = audioCtrl.state.isDownloading.value;
        final isThisDownloading =
            isBusy &&
            audioCtrl.state.currentDownloadingAyahSurahNumber.value ==
                surah.surahNumber;

        return IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 8,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: fullyDownloaded
                      ? context.theme.colorScheme.surface
                      : context.theme.primaryColorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColorLight.withValues(
                      alpha: fullyDownloaded ? .3 : .1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              _buildSurahNumber(context, surah.surahNumber),
                              const Gap(12),
                              Expanded(
                                child: _buildSurahInfo(
                                  context,
                                  surahNumber: surah.surahNumber,
                                  downloaded: downloaded,
                                  total: total,
                                  progress: progress,
                                ),
                              ),
                              _buildActionButton(
                                context,
                                surah: surah,
                                fullyDownloaded: fullyDownloaded,
                                isThisDownloading: isThisDownloading,
                                downloaded: downloaded,
                                isBusy: isBusy,
                                progress: progress,
                              ),
                            ],
                          ),
                        ),
                        const Gap(4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 4,
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: context.theme.primaryColorLight
                                  .withValues(alpha: .3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.theme.colorScheme.primary.withValues(
                                  alpha: .6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// زخرفة رقم السورة: svg الزخرفة + الرقم فوقها بنمط قائمة السور
  Widget _buildSurahNumber(BuildContext context, int surahNumber) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RepaintBoundary(
          child: const SizedBox().customSvgWithColor(
            SvgPath.svgQuranSurahNumberZakhrafa,
            height: 56,
            width: 56,
            color: context.theme.colorScheme.primaryContainer,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              '$surahNumber'.convertNumbersToCurrentLang(),
              style: AppTextStyles.titleMedium(),
            ),
          ),
        ),
      ],
    );
  }

  /// اسم السورة + عدّاد الآيات المحمّلة + شريط تقدم رفيع
  Widget _buildSurahInfo(
    BuildContext context, {
    required int surahNumber,
    required int downloaded,
    required int total,
    required double progress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          child: const SizedBox().customSvgWithColor(
            'assets/svg/surah_name/00$surahNumber.svg',
            color: Theme.of(context).hintColor,
            width: 90,
          ),
        ),
        const Gap(4),
        Text(
          '$downloaded/$total'.convertNumbersToCurrentLang() + ' ' + 'ayahs'.tr,
          style: AppTextStyles.titleSmall(
            height: .9,
            color: context.theme.colorScheme.surface,
          ),
        ),
        const Gap(4),
      ],
    );
  }

  /// زر الإجراء: تحميل / حذف / جارٍ التحميل مع النسبة وإلغاء
  Widget _buildActionButton(
    BuildContext context, {
    required SurahModel surah,
    required bool fullyDownloaded,
    required bool isThisDownloading,
    required bool isBusy,
    required double progress,
    required int downloaded,
  }) {
    if (isThisDownloading) {
      return Column(
        children: [
          CustomButton(
            onPressed: () {
              AudioCtrl.instance.state.cancelRequested.value = true;
              AudioCtrl.instance.cancelDownload();
            },
            height: 45,
            width: 45,
            isCustomSvgColor: true,
            svgPath: SvgPath.svgHomeClose,
            svgColor: context.theme.hintColor,
          ),
          Text(
            '${'downloading'.tr}${(progress * 100).round()}%'
                .convertNumbersToCurrentLang(),
            style: AppTextStyles.titleSmall(),
          ),
        ],
      );
    }
    return Row(
      children: [
        CustomButton(
          onPressed: () => isBusy
              ? null
              : fullyDownloaded
              ? onRequestDelete(surah.surahNumber)
              : onRequestDownload(surah.surahNumber),
          height: 45,
          width: 45,
          isCustomSvgColor: true,
          svgPath: fullyDownloaded
              ? SvgPath.svgHomeRemove
              : SvgPath.svgAudioDownload,
          svgColor: context.theme.hintColor,
        ),
        downloaded > 0
            ? CustomButton(
                onPressed: () => onRequestDelete(surah.surahNumber),
                height: 45,
                width: 45,
                isCustomSvgColor: true,
                svgPath: SvgPath.svgHomeRemove,
                svgColor: context.theme.colorScheme.inverseSurface,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

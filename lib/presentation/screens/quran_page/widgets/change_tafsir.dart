part of '../../quran_page/quran.dart';

// Widget to display Tafsir and Translation selection dialog
// عنصر لعرض حوار اختيار التفسير والترجمة
class ChangeTafsir extends StatelessWidget {
  final int? pageNumber;

  ChangeTafsir({
    super.key,
    this.pageNumber,
  });

  final ayatCtrl = TafsirCtrl.instance;
  final tafsirList = QuranLibrary().tafsirAndTraslationCollection;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TafsirCtrl>(
      id: 'change_tafsir',
      builder: (tafsirCtrl) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () => _showTafsirDialog(context, tafsirCtrl),
          child: Semantics(
            button: true,
            enabled: true,
            label: 'Change Tafsir',
            child: Text(
              tafsirList[tafsirCtrl.radioValue.value].name,
              style: TextStyle(
                color: context.theme.colorScheme.inversePrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'kufi',
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Show the tafsir selection dialog
  // عرض حوار اختيار التفسير
  void _showTafsirDialog(BuildContext context, TafsirCtrl tafsirCtrl) {
    // Get.dialog(
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: Get.width,
          height: Get.height * 0.6,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tafsir section
                // قسم التفاسير
                _buildTafsirSection(context, tafsirCtrl),

                // Translation section
                // قسم الترجمات
                _buildTranslationSection(context, tafsirCtrl),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }

  // Build tafsir section
  // بناء قسم التفاسير
  Widget _buildTafsirSection(BuildContext context, TafsirCtrl tafsirCtrl) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        // عنوان القسم
        Text(
          'tafseer'.tr,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'kufi',
            fontWeight: FontWeight.bold,
            color: context.theme.canvasColor,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(6),

        // Tafsir options
        // خيارات التفسير
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildTafsirOption(context, tafsirCtrl, index);
          },
        ),
        const Gap(20), // Space between sections - مسافة بين الأقسام
      ],
    );
  }

  // Build translation section
  // بناء قسم الترجمات
  Widget _buildTranslationSection(BuildContext context, TafsirCtrl tafsirCtrl) {
    // Translation items start from index 6 in tafsirList
    // عناصر الترجمة تبدأ من الفهرس 6 في tafsirList
    int translationStartIndex = 5;
    int translationCount = tafsirList.length - translationStartIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        // عنوان القسم
        Text(
          'translation'.tr,
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'kufi',
            fontWeight: FontWeight.bold,
            color: context.theme.canvasColor,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(6),

        // Translation options
        // خيارات الترجمة
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: translationCount,
          itemBuilder: (context, index) {
            int actualIndex = translationStartIndex + index;
            return _buildTafsirOption(context, tafsirCtrl, actualIndex);
          },
        ),
      ],
    );
  }

  // Build individual tafsir/translation option
  // بناء خيار تفسير/ترجمة فردي
  Widget _buildTafsirOption(
      BuildContext context, TafsirCtrl tafsirCtrl, int index) {
    return Obx(
      () {
        // Check if this option is downloaded using the conversion function
        // التحقق من تحميل هذا الخيار باستخدام دالة التحويل
        bool isDownloaded = _isDownloaded(index, tafsirCtrl);
        bool isSelected = tafsirCtrl.radioValue.value == index;

        return Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(5),
          ),
          child: GestureDetector(
            onTap: () async {
              await tafsirCtrl.handleRadioValueChanged(
                index,
                pageNumber: pageNumber! + 1 ??
                    QuranCtrl.instance.state.currentPageNumber.value + 1,
              );
              GetStorage().write('radioValue', index);
              tafsirCtrl.update(['change_tafsir']);
              Get.back();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tafsirList[index].name,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.w500,
                      color: context.theme.colorScheme.inversePrimary,
                    ),
                  ),
                ),

                // Download status/button
                // حالة التحميل/زر التحميل
                !isDownloaded
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Obx(
                            () => CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.transparent,
                              color: index == tafsirCtrl.downloadIndex.value
                                  ? tafsirCtrl.onDownloading.value
                                      ? const Color(0xffCDAD80)
                                      : Colors.transparent
                                  : Colors.transparent,
                              value: tafsirCtrl.progress.value,
                            ),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.cloud_download_outlined,
                              size: 22,
                              color: context.theme.colorScheme.inversePrimary,
                            ),
                            onTap: () async {
                              // Convert display index to library index for download
                              // تحويل فهرس العرض إلى فهرس المكتبة للتحميل

                              index >=
                                      4 // Adjust the threshold (was 5, now 4 due to shift)
                                  ? tafsirCtrl.isTafsir.value = false
                                  : tafsirCtrl.isTafsir.value = true;
                              tafsirCtrl.downloadIndex.value = index;
                              await tafsirCtrl.tafsirDownload(index);
                            },
                          ),
                        ],
                      )
                    : Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black
                              : context.theme.colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Check if a tafsir/translation is downloaded
  // التحقق من تحميل تفسير/ترجمة
  bool _isDownloaded(int displayIndex, TafsirCtrl tafsirCtrl) {
    if (displayIndex == 0) return true;
    return tafsirCtrl.tafsirDownloadIndexList.contains(displayIndex);
  }
}

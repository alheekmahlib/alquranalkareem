part of '../../quran_page/quran.dart';

// Widget to display Tafsir and Translation selection dialog
// عنصر لعرض حوار اختيار التفسير والترجمة
class ChangeTafsir extends StatelessWidget {
  final int? pageNumber;
  final bool? isInPageMode;
  final Color? titleColor;

  const ChangeTafsir({
    super.key,
    this.pageNumber,
    this.isInPageMode = false,
    this.titleColor,
  });

  List<TafsirNameModel> get _tafsirAndTranslationsList =>
      tafsirAndTranslateNames;
  int get translationStartIndex => tafsirList.length;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TafsirCtrl>(
      id: 'change_tafsir',
      builder: (tafsirCtrl) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: isInPageMode!
            ? GestureDetector(
                onTap: () => _showTafsirDialog(context, tafsirCtrl),
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Change Tafsir',
                  child: Row(
                    children: [
                      Obx(() => Text(
                            _tafsirAndTranslationsList[
                                    tafsirCtrl.radioValue.value]
                                .name,
                            style: TextStyle(
                              color: titleColor ??
                                  context.theme.colorScheme.inversePrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'kufi',
                            ),
                          )),
                      const Gap(4),
                      Icon(
                        Icons.arrow_drop_down,
                        color: titleColor ??
                            context.theme.colorScheme.inversePrimary,
                      ),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => _showTafsirDialog(context, tafsirCtrl),
                child: customSvgWithCustomColor(
                  SvgPath.svgTafseer,
                  width: 25,
                  color: context.theme.colorScheme.primary,
                ),
              ),
      ),
    );
  }

  // Show the tafsir selection dialog
  // عرض حوار اختيار التفسير
  void _showTafsirDialog(BuildContext context, TafsirCtrl tafsirCtrl) {
    Get.dialog(
      SizedBox(
        height: 347,
        width: Get.width,
        child: Dialog(
          alignment: Alignment.center,
          // insetPadding: const EdgeInsets.all(8.0),
          backgroundColor: Get.context!.theme.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tafsir section
                  // قسم التفاسير
                  _buildTafsirSection(context, tafsirCtrl),
                  const Gap(20),

                  // Translation section
                  // قسم الترجمات
                  _buildTranslationSection(context, tafsirCtrl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build tafsir section
  // بناء قسم التفاسير
  Widget _buildTafsirSection(BuildContext context, TafsirCtrl tafsirCtrl) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section title
          // عنوان القسم
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'tafsir'.tr,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
                color: context.theme.canvasColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(6),

          // Tafsir options
          // خيارات التفسير
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: tafsirList.length,
            itemBuilder: (context, index) {
              return _buildTafsirOption(context, tafsirCtrl, index);
            },
          ), // Space between sections - مسافة بين الأقسام
          const Gap(8),
        ],
      ),
    );
  }

  // Build translation section
  // بناء قسم الترجمات
  Widget _buildTranslationSection(BuildContext context, TafsirCtrl tafsirCtrl) {
    // Translation items start from index 6 in tafsirAndTranslationsList
    // عناصر الترجمة تبدأ من الفهرس 6 في tafsirAndTranslationsList

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section title
          // عنوان القسم
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'translation'.tr,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
                color: context.theme.canvasColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(6),

          // Translation options
          // خيارات الترجمة
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: translationsList.length,
            itemBuilder: (context, index) {
              return _buildTafsirOption(
                  context, tafsirCtrl, translationStartIndex + index);
            },
          ),
          const Gap(8),
        ],
      ),
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
        // bool isNothingOption = index == 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: SizedBox(
            height: 40,
            child: CustomButton(
              backgroundColor: isSelected
                  ? context.theme.colorScheme.surface.withValues(alpha: .2)
                  : context.theme.colorScheme.primaryContainer,
              horizontalPadding: 12.0,
              onPressed: () async {
                log('radioValue: ${tafsirCtrl.radioValue.value}',
                    name: 'Tafsir');
                log('index: $index', name: 'Tafsir');
                // Allow "Nothing" option to be selected without download check
                // السماح باختيار خيار "لا شيء" بدون فحص التحميل
                // if (!isDownloaded && !isNothingOption) return;

                await tafsirCtrl.handleRadioValueChanged(index,
                    pageNumber: (pageNumber! + 1));
                GetStorage().write('radioValue', index);
                tafsirCtrl.update(
                    ['change_tafsir', 'TafsirViewer', 'actualTafsirContent']);
                Get.back();
              },
              iconWidget: Row(
                children: [
                  Expanded(
                    child: Text(
                      _tafsirAndTranslationsList[index].name,
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
                            CustomButton(
                              iconWidget: Icon(
                                Icons.cloud_download_outlined,
                                size: 22,
                                color: context.theme.colorScheme.inversePrimary,
                              ),
                              onPressed: () async {
                                // Convert display index to library index for download
                                // تحويل فهرس العرض إلى فهرس المكتبة للتحميل
                                // int libraryIndex =
                                //     _convertToLibraryIndex(index);

                                // Adjust the threshold (was 5, now 4 due to shift)
                                tafsirCtrl.isTafsir.value =
                                    index < tafsirList.length;

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
          ),
        );
      },
    );
  }

  // Convert new index (with "Nothing" option) to old index (library format)
  // تحويل الفهرس الجديد (مع خيار "لا شيء") إلى الفهرس القديم (تنسيق المكتبة)
  // int _convertToLibraryIndex(int displayIndex) {
  //   if (showNothingOption) {
  //     if (displayIndex == 0)
  //       return -1; // "Nothing" option doesn't exist in library
  //     return displayIndex -
  //         1; // Shift by 1 because we added "Nothing" at index 0
  //   } else {
  //     return displayIndex;
  //   }
  // }

  // Check if a tafsir/translation is downloaded
  // التحقق من تحميل تفسير/ترجمة
  bool _isDownloaded(int displayIndex, TafsirCtrl tafsirCtrl) {
    // int libraryIndex = _convertToLibraryIndex(displayIndex);
    return tafsirCtrl.tafsirDownloadIndexList.contains(displayIndex);
  }
}

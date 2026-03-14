part of '../books.dart';

class BooksChapterBuild extends StatelessWidget {
  final int bookNumber;

  BooksChapterBuild({super.key, required this.bookNumber});

  final booksCtrl = BooksController.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BooksController>(
      id: 'downloadedBooks',
      builder: (booksCtrl) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              // margin:
              //     EdgeInsets.only(top: context.definePlatform(0.0, 100.0)),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface.withValues(alpha: .15),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<List<dynamic>>(
                    future: Future.wait([
                      booksCtrl.getVolumes(bookNumber).then((v) {
                        ChaptersController.instance
                          ..currentChapterName = v.firstOrNull?.name
                          ..volumes = v;

                        return v;
                      }),
                      booksCtrl.getTocs(bookNumber).then((tocs) {
                        ChaptersController.instance
                          ..currentChapterItem = tocs.firstOrNull
                          ..chapters = tocs
                          ..currentChapterName = tocs.firstOrNull?.text;

                        return tocs;
                      }),
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      if (snapshot.hasError) {
                        return _errorBuild(context, snapshot);
                      }

                      final volumes = snapshot.data?[0] as List<Volume>? ?? [];
                      final toc = snapshot.data?[1] as List<TocItem>? ?? [];

                      return _juzBuild(volumes, context, toc);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _juzBuild(
    List<Volume> volumes,
    BuildContext context,
    List<TocItem> toc,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // عرض الأجزاء مع الأبواب - Display volumes with chapters
        if (volumes.isNotEmpty) ...[
          Container(
            width: Get.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              'bookJuz'.tr,
              style: AppTextStyles.titleMedium(
                color: context.theme.canvasColor,
              ),
            ),
          ),
          const Gap(12),
          ...volumes.map(
            (volume) => _buildVolumeExpansionTile(context, volume, toc),
          ),
        ],

        // عرض جدول المحتويات منفصل إذا لم توجد أجزاء - Display separate TOC if no volumes
        if (volumes.isEmpty && toc.isNotEmpty) ...[
          Container(
            width: Get.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              'chapterBook'.tr,
              style: AppTextStyles.titleMedium(
                color: context.theme.canvasColor,
              ),
            ),
          ),
          const Gap(12),
          ...toc.map((item) => _buildTocItem(context, item)),
        ],

        // إذا لم تكن هناك بيانات، اعرض رسالة - If no data, show message
        if (volumes.isEmpty && toc.isEmpty) ...[
          Container(
            width: Get.width,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                customSvgWithColor(
                  SvgPath.svgBooksOpenBook,
                  height: 64,
                  color: context.theme.colorScheme.inversePrimary.withValues(
                    alpha: 0.6,
                  ),
                ),
                const Gap(16),
                Text(
                  'downloadBookFirstToSeeTheContents'.tr,
                  style: AppTextStyles.titleMedium(
                    color: context.theme.colorScheme.inversePrimary.withValues(
                      alpha: 0.6,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _errorBuild(
    BuildContext context,
    AsyncSnapshot<List<dynamic>> snapshot,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'errorLoadingData'.tr,
            style: AppTextStyles.titleMedium(
              color: context.theme.colorScheme.inversePrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'التفاصيل: ${snapshot.error}',
            style: AppTextStyles.bodyMedium(
              color: context.theme.colorScheme.inversePrimary.withValues(
                alpha: 0.6,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // بناء ExpansionTile للجزء مع الأبواب - Build volume ExpansionTile with chapters
  Widget _buildVolumeExpansionTile(
    BuildContext context,
    Volume volume,
    List<TocItem> allToc,
  ) {
    // الحصول على الأبواب التي تنتمي لهذا الجزء - Get chapters belonging to this volume
    List<TocItem> volumeChapters = allToc.where((tocItem) {
      return tocItem.page >= volume.startPage && tocItem.page <= volume.endPage;
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        backgroundColor: context.theme.colorScheme.primaryContainer,
        collapsedBackgroundColor: context.theme.colorScheme.primaryContainer,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: Icon(
          Icons.menu_book_outlined,
          color: context.theme.colorScheme.surface,
          size: 24,
        ),
        title: Text(
          volume.name.convertNumbersToCurrentLang(),
          style: AppTextStyles.titleMedium(),
        ),
        subtitle: Text(
          '${'pages'.tr} ${volume.startPage} - ${volume.endPage} • ${volumeChapters.length} ${'chapter'.tr}'
              .convertNumbersToCurrentLang(),
          style: AppTextStyles.bodySmall(
            color: context.theme.colorScheme.inversePrimary.withValues(
              alpha: 0.7,
            ),
          ),
        ),
        iconColor: context.theme.colorScheme.primary,
        collapsedIconColor: context.theme.colorScheme.inversePrimary,
        children: [
          // زر الذهاب إلى بداية الجزء - Button to go to volume start
          ContainerButton(
            onPressed: () async => await booksCtrl.moveToBookPageByNumber(
              volume.startPage,
              bookNumber,
            ),
            height: 55,
            width: Get.width,
            value: true.obs,
            withArrow: true,
            verticalMargin: 2.0,
            horizontalMargin: 8.0,
            title: 'goToStartOfJuz',
            backgroundColor: context.theme.primaryColorLight.withValues(
              alpha: .1,
            ),
            svgColor: Theme.of(context).colorScheme.secondaryContainer,
          ),

          // عرض الأبواب الخاصة بهذا الجزء - Display chapters for this volume
          if (volumeChapters.isNotEmpty) ...[
            Container(
              height: 32,
              width: Get.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
              ),
              child: Text(
                'chapterBook'.tr,
                style: AppTextStyles.titleMedium(
                  color: context.theme.canvasColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(8.0),
            ...volumeChapters.map(
              (chapter) => _buildChapterListTile(context, chapter),
            ),
          ],

          // إذا لم توجد أبواب في هذا الجزء - If no chapters in this volume
          if (volumeChapters.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'noChaptersInThisJuz'.tr,
                style: AppTextStyles.titleMedium(
                  color: context.theme.colorScheme.inversePrimary.withValues(
                    alpha: 0.6,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  // بناء عنصر الفصل داخل القائمة - Build chapter list tile
  Widget _buildChapterListTile(BuildContext context, TocItem item) {
    return ContainerButton(
      onPressed: () async {
        await booksCtrl.moveToBookPageByNumber(
          item.page - 1,
          bookNumber,
          chapterName: item.text,
        );
      },
      width: Get.width,
      value: true.obs,
      withArrow: true,
      verticalMargin: 2.0,
      horizontalMargin: 8.0,
      title: item.text,
      subtitle: item.page > 0
          ? '${'page'.tr} ${item.page}'.convertNumbersToCurrentLang()
          : '',
      backgroundColor: context.theme.primaryColorLight.withValues(alpha: .1),
      svgColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }

  // بناء عنصر جدول المحتويات - Build table of contents item
  Widget _buildTocItem(BuildContext context, TocItem item) {
    return ContainerButton(
      onPressed: () async => await booksCtrl.moveToBookPageByNumber(
        item.page - 1,
        bookNumber,
        chapterName: item.text,
      ),
      width: Get.width,
      value: true.obs,
      withArrow: true,
      verticalMargin: 2.0,
      horizontalMargin: 8.0,
      title: item.text,
      subtitle: item.page > 0
          ? '${'page'.tr} ${item.page}'.convertNumbersToCurrentLang()
          : '',
      backgroundColor: context.theme.primaryColorLight.withValues(alpha: .1),
      svgColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}

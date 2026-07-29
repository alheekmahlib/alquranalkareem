part of '../books.dart';

/// قائمة منسدلة للفصول / Chapters dropdown
class ChaptersDropdownWidget extends StatelessWidget {
  final int bookNumber;
  final int pageIndex;

  const ChaptersDropdownWidget({
    super.key,
    required this.bookNumber,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final booksCtrl = BooksController.instance;
    return GetBuilder<ChaptersController>(
      init: ChaptersController.instance,
      builder: (controller) {
        if (controller.isLoading || controller.chapters.isEmpty) {
          return const SizedBox.shrink();
        }

        // العثور على الفصل الحالي في القائمة / Find current chapter in the list
        final currentChapterIndex = controller.chapters.indexWhere(
          (chapter) =>
              controller.currentChapterName
                  ?.split(',')
                  .contains(chapter.text) ==
              true,
        );

        // تحديد الفصل الحالي كعنصر أولي / Set current chapter as initial item
        final initialItem = currentChapterIndex >= 0
            ? controller.chapters[currentChapterIndex]
            : null;

        return CustomDropdown<TocItem>(
          excludeSelected: false,
          itemsScrollController: controller.itemsScrollController,
          decoration: CustomDropdownDecoration(
            closedFillColor: Colors.transparent,
            expandedFillColor: booksCtrl.backgroundColor,
            closedBorderRadius: const BorderRadius.all(Radius.circular(8)),
            expandedBorderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          closedHeaderPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          itemsListPadding: EdgeInsets.zero,
          listItemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          hideSelectedFieldWhenExpanded: false,
          hintBuilder: (context, text, select) => Text(
            controller.currentChapterName ?? 'اختر فصلاً',
            style: AppTextStyles.titleSmall(),
          ),
          headerBuilder: (context, value, select) =>
              GetBuilder<ChaptersController>(
                id: 'ChapterName',
                builder: (ctrl) {
                  return Text(
                    ctrl.currentChapterName ?? 'اختر فصلاً',
                    style: AppTextStyles.titleSmall(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
          items: controller.chapters,
          listItemBuilder: (context, item, select, _) => Container(
            key: ValueKey(item.text),
            height: 40.0, // ارتفاع ثابت لكل عنصر / Fixed height for each item
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:
                  controller.currentChapterName
                          ?.split(',')
                          .contains(item.text) ==
                      true
                  ? context.theme.colorScheme.surface.withValues(alpha: .5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: GetBuilder<ChaptersController>(
              id: 'ChapterName',
              builder: (ctrl) {
                final isSelected =
                    controller.currentChapterName
                        ?.split(',')
                        .contains(item.text) ==
                    true;
                return Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item.text,
                    style: AppTextStyles.titleSmall().copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          initialItem:
              initialItem, // سيتم التمرير تلقائياً للفصل الحالي / Will auto-scroll to current chapter
          visibility: (isVisible) {
            // السكرول للفصل الحالي عند فتح القائمة / Scroll to current chapter when dropdown opens
            if (isVisible) {
              controller.scrollToCurrentChapterOnOpen();
            }
          },
          onChanged: (selectedChapter) async {
            if (selectedChapter != null) {
              // إضافة تأخير قصير لضمان انغلاق القائمة بسلاسة / Add short delay to ensure smooth dropdown closure
              await Future.delayed(const Duration(milliseconds: 550));
              booksCtrl.moveToPage(selectedChapter.text, bookNumber);
            }
          },
        );
      },
    );
  }
}

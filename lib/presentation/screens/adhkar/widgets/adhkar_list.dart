import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran_library.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/core/utils/helpers/app_text_styles.dart';
import '/core/widgets/container_button.dart';
import '../../../../database/bookmark_db/bookmark_database.dart';
import '../../../../presentation/screens/quran_page/widgets/search/search_extensions/highlight_extension.dart';
import '../controller/adhkar_controller.dart';
import '../screens/adhkar_item.dart';

class AdhkarList extends StatelessWidget {
  AdhkarList({super.key});

  final azkarCtrl = AzkarController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _searchField(context),
          Expanded(child: _body(context)),
        ],
      ),
    );
  }

  /// حقل البحث المدمج في أعلى قائمة الأقسام.
  Widget _searchField(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Obx(() {
          final hasText = azkarCtrl.state.searchQuery.value.isNotEmpty;
          return SizedBox(
            height: 44,
            child: TextField(
              controller: azkarCtrl.state.searchController,
              textAlign: TextAlign.right,
              style: AppTextStyles.titleSmall(
                color: context.theme.colorScheme.inversePrimary,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                hintText: 'searchAzkar'.tr,
                hintStyle: AppTextStyles.titleSmall(
                  color: context.theme.colorScheme.inversePrimary.withValues(
                    alpha: .6,
                  ),
                ),
                filled: true,
                fillColor: context.theme.colorScheme.surface.withValues(
                  alpha: 0.3,
                ),
                prefixIcon: Container(
                  height: 20,
                  padding: const EdgeInsets.all(10.0),
                  child: customSvgWithColor(
                    SvgPath.svgHomeSearch,
                    height: 35,
                    color: context.theme.colorScheme.inversePrimary.withValues(
                      alpha: .5,
                    ),
                  ),
                ),
                suffixIcon: hasText
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: context.theme.colorScheme.primary,
                        ),
                        onPressed: azkarCtrl.clearSearch,
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: context.theme.primaryColorLight,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: azkarCtrl.searchDhekr,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
            ),
          );
        }),
      ),
    );
  }

  /// يبدّل المحتوى بين: قائمة الأقسام / نتائج البحث / حالة "لا نتائج".
  Widget _body(BuildContext context) {
    return Obx(() {
      if (azkarCtrl.state.searchQuery.value.isEmpty) {
        return _categoriesListView();
      }
      if (azkarCtrl.state.searchResults.isEmpty) {
        return _emptyState(context);
      }
      return _searchResultsListView(context);
    });
  }

  /// قائمة الأقسام الأصلية (الموجودة قبل التعديل).
  Widget _categoriesListView() {
    return AnimationLimiter(
      child: Obx(() {
        return ListView.builder(
          controller: azkarCtrl.state.listController,
          itemCount: azkarCtrl.state.categories.length,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 450),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: ContainerButton(
                    onPressed: () {
                      azkarCtrl.filterByCategory(
                        azkarCtrl.state.categories[index],
                      );
                      Get.to(
                        () => const AdhkarItem(),
                        transition: Transition.downToUp,
                      );
                      log('filterByCategory: $index');
                    },
                    value: true.obs,
                    width: Get.width,
                    withArrow: true,
                    verticalPadding: 12.0,
                    horizontalPadding: 8.0,
                    verticalMargin: 4.0,
                    horizontalMargin: 16.0,
                    selectedValueMargin: 0.0,
                    backgroundColor: Get.theme.primaryColorLight.withValues(
                      alpha: .2,
                    ),
                    title: azkarCtrl.state.categories[index].toString(),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// قائمة نتائج البحث — كل عنصر قابل للضغط للانتقال إلى الذكر داخل قسمه.
  Widget _searchResultsListView(BuildContext context) {
    final query = azkarCtrl.state.searchQuery.value;
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: azkarCtrl.state.searchResults.length,
        itemBuilder: (context, index) {
          final zekr = azkarCtrl.state.searchResults[index];
          return _searchResultCard(context, zekr, query);
        },
      );
    });
  }

  Widget _searchResultCard(
    BuildContext context,
    AdhkarData zekr,
    String query,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () => azkarCtrl.navigateToZekr(zekr),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .05),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Theme.of(context).primaryColorLight.withValues(alpha: .3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نص الذكر مع تظليل كلمات البحث
              RichText(
                text: TextSpan(
                  children: zekr.zekr.highlightLine(query),
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    height: 1.5,
                    fontFamily: 'naskh',
                    fontSize: TafsirCtrl.instance.fontSizeArabic.value - 2,
                  ),
                ),
                textAlign: TextAlign.justify,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(8),
              // شريط التصنيف + التكرار
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        zekr.category,
                        style: AppTextStyles.titleSmall(
                          fontSize: 12,
                          color: Theme.of(context).canvasColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (zekr.count.isNotEmpty) ...[
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        zekr.count,
                        style: AppTextStyles.titleSmall(
                          fontSize: 12,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// حالة "لا توجد نتائج".
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: context.theme.colorScheme.surface.withValues(alpha: .4),
          ),
          const Gap(12),
          Text(
            'noAzkarResults'.tr,
            style: AppTextStyles.titleSmall(
              color: context.theme.colorScheme.surface.withValues(alpha: .5),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/controllers/general/general_controller.dart';
import '/presentation/screens/ai_search/ai_search.dart';
import '/presentation/screens/home/widgets/hijri_widget.dart';
import '../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../core/utils/constants/svg_constants.dart';
import '../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/theme_controller.dart';
import 'widgets/books_section.dart';
import 'widgets/daily_zeker.dart';
import 'widgets/quran_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) {
        return ScreenUtilInit(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: SafeArea(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Stack(
                  children: [
                    context.customOrientation(
                      ListView(
                        padding: const EdgeInsets.only(top: 80),
                        children: [
                          HijriWidget(),
                          const Gap(16),
                          QuranSection(),
                          const Gap(16),
                          DailyZeker(),
                          const Gap(16),
                          const BooksSection(),
                          const Gap(16),
                        ],
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      HijriWidget(),
                                      const Gap(8),
                                      DailyZeker(),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(children: [QuranSection()]),
                                ),
                              ],
                            ),
                            const Gap(16),
                            const BooksSection(),
                            const Gap(16),
                          ],
                        ),
                      ),
                    ),
                    TopBarWidget(
                      isHomeChild: false,
                      isQuranSetting: false,
                      isNotification: true,
                      tabBarController:
                          GeneralController.instance.state.tabBarController,
                      centerChild: GestureDetector(
                        onTap: () => Get.to(
                          () => const AiSearchResults(),
                          transition: Transition.fadeIn,
                        ),
                        child: Container(
                          height: 45,
                          width: Get.width,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8.0,
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.surface.withValues(
                              alpha: .2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: context.theme.colorScheme.primary
                                  .withValues(alpha: .3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                'askMidad'.tr,
                                style: AppTextStyles.titleSmall(),
                              ),
                              customSvgWithCustomColor(
                                SvgPath.svgHomeMidadIcon,
                                height: 20,
                                color: context.theme.primaryColorLight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

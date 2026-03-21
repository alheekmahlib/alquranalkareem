import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../core/utils/constants/extensions/extensions.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/animated_drawing_widget.dart';
import '../../../../core/widgets/app_bar_widget.dart';
import '../controller/ourApps_controller.dart';
import '../data/models/ourApp_model.dart';
import 'widgets/app_card_widget.dart';
import 'widgets/apps_grid_skeleton_widget.dart';

class OurApps extends StatelessWidget {
  const OurApps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBarWidget(
        isBooks: false,
        isTitled: false,
        isNotifi: false,
        isFontSize: false,
        searchButton: const SizedBox.shrink(),
        centerChild: customSvgWithCustomColor(
          SvgPath.svgHomeQuranLogo,
          height: 35,
          color: context.theme.primaryColorLight,
        ),
      ),
      body: context.customOrientation(
        ListView(
          children: [
            Gap(16.h),
            AnimatedDrawingWidget(
              opacity: 1,
              svgPath: SvgPath.svgHomeQuranLogo,
              width: 130,
              height: 110,
              customColor: context.theme.colorScheme.surface,
            ),
            Gap(16.h),
            _appsBuild(),
            Gap(16.h),

            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: customSvgWithColor(
                SvgPath.svgAlheekmahLogo,
                width: 80.0.w,
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  AnimatedDrawingWidget(
                    opacity: 1,
                    svgPath: SvgPath.svgHomeQuranLogo,
                    width: 130,
                    height: 110,
                    customColor: context.theme.colorScheme.surface,
                  ),
                  const Spacer(),
                  Padding(
                    padding: context.customOrientation(
                      const EdgeInsets.symmetric(vertical: 40.0).r,
                      const EdgeInsets.symmetric(vertical: 32.0).r,
                    ),
                    child: customSvgWithColor(
                      SvgPath.svgAlheekmahLogo,
                      width: 80.0.w,
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(child: _appsBuild()),
            ),
          ],
        ),
      ),
    );
  }

  LayoutBuilder _appsBuild() {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        int crossAxisCount = 2;
        if (w >= 1100) {
          crossAxisCount = 3;
        } else if (w >= 700) {
          crossAxisCount = 2;
        }
        return FutureBuilder<List<OurAppInfo>>(
          future: OurAppsController.instance.fetchApps(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppsGridSkeleton(crossAxisCount: crossAxisCount);
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontFamily: 'cairo',
                    fontSize: 12,
                  ),
                ),
              );
            }
            final apps = snapshot.data;
            if (apps == null || apps.isEmpty) {
              return Center(
                child: Text(
                  '—',
                  style: TextStyle(
                    color: context.theme.colorScheme.inversePrimary,
                  ),
                ),
              );
            }
            return MasonryGridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return AppCard(app);
              },
            );
          },
        );
      },
    );
  }
}

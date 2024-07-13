import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '../../splashScreen/controller/controller.dart';

class PageViewBuild extends StatelessWidget {
  final PageController controller;
  final List<Map<String, dynamic>> newFeatures;
  PageViewBuild(
      {super.key, required this.controller, required this.newFeatures});

  final splashCtrl = SplashScreenController.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Flexible(
      child: PageView.builder(
          controller: controller,
          itemCount: newFeatures.length,
          onPageChanged: (page) {
            splashCtrl.state.onboardingPageNumber.value = page;
            splashCtrl.state.currentPageIndex.value = page;
          },
          itemBuilder: (context, index) {
            // splashCtrl.onboardingPageNumber.value =
            //     newFeatures[index]['index'] + index;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  newFeatures[index]['title'] == ''
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Text(
                            '${newFeatures[index]['title']}'.tr,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 16.0.sp,
                              fontFamily: 'kufi',
                            ),
                          ),
                        ),
                  const Gap(8),
                  newFeatures[index]['imagePath'] == ''
                      ? const SizedBox.shrink()
                      : Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0))),
                            child: Image.asset(
                              newFeatures[index]['imagePath'],
                              width: context.customOrientation(
                                  MediaQuery.of(context).size.width * 3 / 4,
                                  MediaQuery.of(context).size.width),
                            ),
                          ),
                        ),
                  const Gap(8),
                  newFeatures[index]['details'] == ''
                      ? const SizedBox.shrink()
                      : Container(
                          width: size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Text(
                            '${newFeatures[index]['details']}'.tr,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 14.0.sp,
                              fontFamily: 'kufi',
                            ),
                          ),
                        ),
                ],
              ),
            );
          }),
    );
  }
}

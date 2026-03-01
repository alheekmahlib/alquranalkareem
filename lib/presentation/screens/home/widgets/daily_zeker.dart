import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/screens/adhkar/controller/extensions/adhkar_getters.dart';
import '../../../../database/bookmark_db/bookmark_database.dart';
import '../../adhkar/controller/adhkar_controller.dart';

class DailyZeker extends StatelessWidget {
  DailyZeker({super.key});
  final azkarCtrl = AzkarController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: .08),
              Theme.of(context).colorScheme.primary.withValues(alpha: .04),
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FutureBuilder<AdhkarData>(
          future: azkarCtrl.getDailyDhekr(),
          builder: (context, snapshot) {
            return snapshot.data != null &&
                    azkarCtrl.state.dhekrOfTheDay != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Modern header badge
                      Container(
                        height: 34,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: .5),
                              Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: .3),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          'dailyZeker'.tr,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(8),
                      context.hDivider(
                        width: Get.width,
                        color: context.theme.colorScheme.surface,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text(
                          '${azkarCtrl.state.dhekrOfTheDay!.zekr}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'naskh',
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).hintColor,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      context.hDivider(
                        width: Get.width,
                        color: context.theme.colorScheme.surface,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          azkarCtrl.state.dhekrOfTheDay!.category,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.w500,
                            color: Theme.of(
                              context,
                            ).hintColor.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(8),
                    ],
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../athkar/models/zeker_model.dart';
import '/presentation/controllers/azkar_controller.dart';

class DailyZeker extends StatelessWidget {
  const DailyZeker({super.key});

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = sl<AzkarController>();
    return Container(
      width: 380,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Container(
        width: 380,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(.15),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: Column(
          children: [
            Container(
              height: 32,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Text(
                'dailyZeker'.tr,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 1)),
              child: FutureBuilder<Zekr>(
                  future: azkarCtrl.getDailyZeker(),
                  builder: (context, snapshot) {
                    return snapshot.data != null &&
                            azkarCtrl.zekerOfTheDay != null
                        ? Text(
                            '${azkarCtrl.zekerOfTheDay!.zekr}',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'naskh',
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.5),
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          )
                        : const CircularProgressIndicator();
                  }),
            ),
            Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: FutureBuilder<Zekr>(
                  future: azkarCtrl.getDailyZeker(),
                  builder: (context, snapshot) {
                    return snapshot.data != null &&
                            azkarCtrl.zekerOfTheDay != null
                        ? Text(
                            azkarCtrl.zekerOfTheDay!.category,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const CircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

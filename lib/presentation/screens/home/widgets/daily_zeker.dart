import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../athkar/models/zeker_model.dart';
import '/presentation/controllers/azkar_controller.dart';

class DailyZeker extends StatelessWidget {
  DailyZeker({super.key});
  final azkarCtrl = sl<AzkarController>();
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 380,
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Container(
          width: 380,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(.1),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: FutureBuilder<Zekr>(
              future: azkarCtrl.getDailyZeker(),
              builder: (context, snapshot) {
                return snapshot.data != null && azkarCtrl.zekerOfTheDay != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 32,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
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
                            width: MediaQuery.sizeOf(context).width,
                            margin: const EdgeInsets.all(16.0),
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1)),
                            child: Text(
                              '${azkarCtrl.zekerOfTheDay!.zekr}',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'naskh',
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hintColor,
                                  height: 1.5),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              azkarCtrl.zekerOfTheDay!.category,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).hintColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Gap(8)
                        ],
                      )
                    : const CircularProgressIndicator();
              }),
        ));
  }
}

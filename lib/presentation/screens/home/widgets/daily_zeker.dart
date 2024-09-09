import 'package:alquranalkareem/core/utils/constants/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/screens/adhkar/controller/extensions/adhkar_getters.dart';
import '../../adhkar/controller/adhkar_controller.dart';
import '../../adhkar/models/dheker_model.dart';

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
              color: Theme.of(context).colorScheme.primary.withOpacity(.1),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: FutureBuilder<Dhekr>(
              future: azkarCtrl.getDailyDhekr(),
              builder: (context, snapshot) {
                return snapshot.data != null &&
                        azkarCtrl.state.dhekrOfTheDay != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 37,
                                width: 170,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    )),
                              ),
                              Container(
                                height: 32,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.4),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    )),
                                child: Text(
                                  'dailyZeker'.tr,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'kufi',
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const Gap(4),
                          context.hDivider(
                              width: Get.width,
                              color: context.theme.colorScheme.surface),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              '${azkarCtrl.state.dhekrOfTheDay!.zekr}',
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
                          context.hDivider(
                              width: Get.width,
                              color: context.theme.colorScheme.surface),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              azkarCtrl.state.dhekrOfTheDay!.category,
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
                    : const SizedBox.shrink();
              }),
        ));
  }
}

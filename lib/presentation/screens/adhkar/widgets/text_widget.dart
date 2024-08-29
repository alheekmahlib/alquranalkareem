import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/services/services_locator.dart';
import '../../../controllers/general/general_controller.dart';
import '../controller/adhkar_controller.dart';
import '../models/dheker_model.dart';

class TextWidget extends StatelessWidget {
  final Dhekr zekr;
  TextWidget({super.key, required this.zekr});

  @override
  Widget build(BuildContext context) {
    final azkarCtrl = AzkarController.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            width: double.infinity,
            child: Obx(() {
              return RichText(
                text: TextSpan(
                  children: azkarCtrl.buildTextSpans(zekr.zekr),
                  style: TextStyle(
                      color: Theme.of(context).hintColor,
                      height: 1.4,
                      fontFamily: 'naskh',
                      fontSize:
                          sl<GeneralController>().state.fontSizeArabic.value),
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.15),
                          width: 1)),
                  child: Text(
                    zekr.reference,
                    style: TextStyle(
                      color: Theme.of(context).hintColor.withOpacity(.6),
                      fontSize: 14,
                      fontFamily: 'naskh',
                    ),
                  ))),
        ),
        zekr.description.isEmpty
            ? const SizedBox.shrink()
            : Align(
                alignment: Alignment.center,
                child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.15),
                            width: 1)),
                    child: Text(
                      zekr.description,
                      style: TextStyle(
                          color: Theme.of(context).hintColor.withOpacity(.8),
                          fontSize: 16,
                          fontFamily: 'naskh',
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ))),
      ],
    );
  }
}

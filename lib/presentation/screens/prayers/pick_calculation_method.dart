import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/adhan/adhan_controller.dart';

class pickCalculationMethod extends StatelessWidget {
  pickCalculationMethod({super.key});

  final adhanCtrl = AdhanController.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: adhanCtrl.state.countryListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PopupMenuButton(
              position: PopupMenuPosition.under,
              child: Semantics(
                button: true,
                enabled: true,
                label: 'Change Font Size',
                child: Container(
                  height: 50,
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor.withOpacity(.1),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        adhanCtrl.state.selectedCountry.value,
                        style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'kufi'),
                      ),
                      Semantics(
                        button: true,
                        enabled: true,
                        label: 'Change Reader',
                        child: Icon(Icons.keyboard_arrow_down_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              color: Theme.of(context).colorScheme.primaryContainer,
              itemBuilder: (context) => List.generate(
                  adhanCtrl.state.countries.length,
                  (index) => PopupMenuItem(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                adhanCtrl.state.countries[index],
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    fontSize: 14,
                                    fontFamily: 'kufi'),
                              ),
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      )),
            );
          } else if (snapshot.hasError) {
            return Text('Error loading countries: ${snapshot.error}');
          } else {
            return CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
            );
          }
        });
  }
}

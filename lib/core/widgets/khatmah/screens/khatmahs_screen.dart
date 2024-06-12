import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../presentation/controllers/khatmah_controller.dart';
import '../../delete_widget.dart';
import '../widgets/khatmah_widget.dart';

class KhatmasScreen extends StatelessWidget {
  KhatmasScreen({super.key});

  final khatmahCtrl = KhatmahController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: khatmahCtrl.nameController,
                      decoration: InputDecoration(
                        labelText: 'Khatmah Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: khatmahCtrl.daysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Days to Complete',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        String name = khatmahCtrl.nameController.text;
                        int days =
                            int.tryParse(khatmahCtrl.daysController.text) ?? 30;
                        khatmahCtrl.addKhatmah(name: name, daysCount: days);
                      },
                      child: Text('Add Khatmah'),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Obx(() {
                  if (khatmahCtrl.khatmas.isEmpty) {
                    return Center(
                      child: Text('No Khatmas added yet'),
                    );
                  }
                  return ListView.builder(
                    itemCount: khatmahCtrl.khatmas.length,
                    itemBuilder: (context, index) {
                      final khatmah = khatmahCtrl.khatmas[index];
                      return Dismissible(
                        background: const DeleteWidget(),
                        key: ValueKey<int>(index),
                        onDismissed: (DismissDirection direction) {
                          khatmahCtrl.deleteKhatmah(khatmah.id);
                        },
                        child: KhatmahWidget(
                          khatmah: khatmah,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/widgets/widgets.dart';
import '../../database/databaseHelper.dart';
import '../screens/athkar/models/azkar.dart';

class AzkarController extends GetxController {
  final RxList<Azkar> azkarList = <Azkar>[].obs;

  Future<int?> addAzkar(Azkar? azkar) {
    return DatabaseHelper.addAzkar(azkar!);
  }

  Future<void> getAzkar() async {
    final List<Map<String, dynamic>> azkar = await DatabaseHelper.queryC();
    azkarList.assignAll(azkar.map((data) => Azkar.fromJson(data)).toList());
  }

  void deleteAzkar(Azkar? azkar, BuildContext context) async {
    await DatabaseHelper.deleteAzkar(azkar!)
        .then((value) => customSnackBar(context, 'deletedZekrBookmark'.tr));
    getAzkar();
  }

  void updateAzkar(Azkar? azkar) async {
    await DatabaseHelper.updateAzkar(azkar!);
    getAzkar();
  }
}

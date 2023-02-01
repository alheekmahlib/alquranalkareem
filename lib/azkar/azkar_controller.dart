import 'package:alquranalkareem/azkar/models/azkar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
<<<<<<< HEAD
import '../bookmarks_notes_db/databaseHelper.dart';
=======
import '../../../notes/db/databaseHelper.dart';
>>>>>>> e96a46eb4c68152ef511d7b809d9f7b4a4171eee
import '../../../shared/widgets/widgets.dart';



class AzkarController extends GetxController {
  final RxList<Azkar> azkarList = <Azkar>[].obs;

  Future<int?> addAzkar(Azkar? azkar) {
    return DatabaseHelper.addAzkar(azkar!);
  }

  Future<void> getAzkar() async{
    final List<Map<String, dynamic>> azkar = await DatabaseHelper.queryC();
    azkarList.assignAll(azkar.map((data) => Azkar.fromJson(data)).toList());
  }

  void deleteAzkar(Azkar? azkar, BuildContext context) async{
    await DatabaseHelper.deleteAzkar(azkar!).then((value) => customSnackBar(
        context,
        AppLocalizations.of(context)!.deletedZekrBookmark
    ));
    getAzkar();
  }

  void updateAzkar(Azkar? azkar) async{
    await DatabaseHelper.updateAzkar(azkar!);
    getAzkar();
  }
}
import 'package:get/get.dart';
import 'db/databaseHelper.dart';
import 'model/Notes.dart';


class NoteController extends GetxController {
  final RxList<Notes> noteList = <Notes>[].obs;

  Future<int?> addNote(Notes? notes) {
    return DatabaseHelper.saveNote(notes!);
  }

  Future<void> getNotes() async{
    final List<Map<String, dynamic>> notes = await DatabaseHelper.queryN();
    noteList.assignAll(notes.map((data) => Notes.fromJson(data)).toList());
  }

  void deleteNotes(Notes? notes) async{
    await DatabaseHelper.deleteNote(notes!);
    getNotes();
  }

  void updateNotes(Notes? notes) async{
    await DatabaseHelper.updateNote(notes!);
    getNotes();
  }
}
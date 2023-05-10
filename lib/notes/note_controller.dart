import 'package:get/get.dart';
import '../database/databaseHelper.dart';
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

  Future<int?> addSelectedTextAsNote(String selectedText, String selectedTitle) async {
    Notes note = Notes(
      null, // You can assign a unique ID or let the database generate it for you.
      selectedTitle,
      selectedText,
    );

    print('Adding Note: $note'); // Debugging: Print the note object before saving it.

    int? result = await addNote(note);
    getNotes(); // Fetch the notes after adding a new note.

    print('Save result: $result'); // Debugging: Print the result of the saving operation.

    return result;
  }


  @override
  void onInit() {
    super.onInit();
    getNotes();
  }

}
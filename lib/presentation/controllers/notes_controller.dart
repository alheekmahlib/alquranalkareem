import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/l10n/app_localizations.dart';
import '../../core/widgets/widgets.dart';
import '../../database/databaseHelper.dart';
import '../screens/notes/model/Notes.dart';
import '../screens/quran_page/widgets/show_tafseer.dart';
import '../screens/quran_text/screens/text_page_view.dart';

class NotesController extends GetxController {
  final RxList<Notes> notes = <Notes>[].obs;
  bool isShowBottomSheet = false;
  IconData notesFabIcon = Icons.add_comment_outlined;
  int? id;
  String? title;
  String? description;
  late final Notes note;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> addNote(Notes note) async {
    await DatabaseHelper.saveNote(note);
    getNotes();
  }

  Future<void> getNotes() async {
    final List<Map<String, dynamic>> noteMaps = await DatabaseHelper.queryN();
    notes.assignAll(noteMaps.map((data) => Notes.fromJson(data)).toList());
    print('Note List: ${notes}');
  }

  Future<void> deleteNotes(int noteNumber) async {
    int result = await DatabaseHelper.deleteNote(noteNumber);
    print('Delete result: $result');
    getNotes();
  }

  Future<void> updateNotes(Notes note) async {
    await DatabaseHelper.updateNote(note);
    getNotes();
  }

  Future<void> addSelectedTextAsNote(
      String selectedText, String selectedTitle) async {
    Notes note = Notes(
      id,
      selectedTitle,
      selectedText,
    );
    await addNote(note);
  }

  void validate(BuildContext context) {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      addNoteMethod(context);
    } else {
      customSnackBar(context, AppLocalizations.of(context)!.fillAllFields);
    }
  }

  void addNoteMethod(BuildContext context) {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      addNote(
        Notes(
          id,
          titleController.text,
          descriptionController.text,
        ),
      );
    } else {
      customSnackBar(context, AppLocalizations.of(context)!.fillAllFields);
    }
  }

  void addTafseerToNote() {
    if (selectedTextED != null && selectedTextED!.isNotEmpty) {
      addSelectedTextAsNote(selectedTextED!, allTitle);
      selectedTextED = null;
    }
  }

  void addTafseerTextToNote() {
    if (selectedTextT != null && selectedTextT!.isNotEmpty) {
      addSelectedTextAsNote(selectedTextT!, textTitle);
      selectedTextT = null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../database/databaseHelper.dart';
import '../../l10n/app_localizations.dart';
import '../../notes/model/Notes.dart';
import '../../quran_text/text_page_view.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/widgets.dart';

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
    final noteId = await DatabaseHelper.saveNote(note);
    getNotes();
  }

  Future<void> getNotes() async {
    final List<Map<String, dynamic>> noteMaps = await DatabaseHelper.queryN();
    notes.assignAll(noteMaps.map((data) => Notes.fromJson(data)).toList());
    print('Note List: ${notes.value}');
  }

  Future<void> deleteNotes(String description) async {
    int result = await DatabaseHelper.deleteNote(description);
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

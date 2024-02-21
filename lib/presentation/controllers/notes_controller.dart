import 'package:alquranalkareem/core/utils/constants/extensions/custom_error_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../database/databaseHelper.dart';
import '../screens/notes/model/Notes.dart';
import '../screens/quran_page/widgets/show_tafseer.dart';

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
      context.showCustomErrorSnackBar('fillAllFields'.tr);
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
      context.showCustomErrorSnackBar('fillAllFields'.tr);
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

String textText = '';
String textTitle = '';
String? selectedTextT;

void handleSelectionChangedText(
    TextSelection selection, SelectionChangedCause? cause) {
  if (cause == SelectionChangedCause.longPress) {
    final characters = textText.characters;
    final start = characters.take(selection.start).length;
    final end = characters.take(selection.end).length;
    final selectedText = textText.substring(start - 1, end - 1);

    // setState(() {
    selectedTextT = selectedText;
    // });
    print(selectedText);
  }
}

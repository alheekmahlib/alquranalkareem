import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/databaseHelper.dart';
import '../../l10n/app_localizations.dart';
import '../../quran_text/text_page_view.dart';
import '../../shared/widgets/show_tafseer.dart';
import '../../shared/widgets/widgets.dart';
import '../model/Notes.dart';
import 'note_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesState(notes: []));

  static NotesCubit get(context) => BlocProvider.of(context);
  bool isShowBottomSheet = false;
  IconData notesFabIcon = Icons.add_comment_outlined;
  int? id;
  String? title;
  String? description;
  late final Notes notes;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  var note;

  Future<void> addNote(Notes notes) async {
    // ignore: unused_local_variable
    final noteId = await DatabaseHelper.saveNote(notes);
    getNotes(); // Fetch the notes after adding a new note.
  }

  Future<void> getNotes() async {
    final List<Map<String, dynamic>> notes = await DatabaseHelper.queryN();
    List<Notes> noteList = notes.map((data) => Notes.fromJson(data)).toList();
    print('Note List: $noteList'); // Print the note list
    emit(NotesState(notes: noteList));
  }

  Future<void> deleteNotes(String description) async {
    int result = await DatabaseHelper.deleteNote(description);
    print('Delete result: $result'); // Print the result
    getNotes();
  }

  Future<void> updateNotes(Notes notes) async {
    await DatabaseHelper.updateNote(notes);
    getNotes(); // Fetch the notes after updating a note.
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

  validate(BuildContext context) {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      addNotes(context);
    } else if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      customSnackBar(context, AppLocalizations.of(context)!.fillAllFields);
    }
  }

  addNotes(BuildContext context) {
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
      // Assuming you have a NoteError state that accepts a custom message
      customSnackBar(context, AppLocalizations.of(context)!.fillAllFields);
    }
  }

  /// Add Tafseer To Note
  void addTafseerToNote(BuildContext context) {
    if (selectedTextED != null && selectedTextED!.isNotEmpty) {
      context
          .read<NotesCubit>()
          .addSelectedTextAsNote(selectedTextED!, allTitle);
      // Clear the selected text after saving it as a note
      selectedTextED = null;
    }
  }

  void addTafseerTextToNote(BuildContext context) {
    if (selectedTextT != null && selectedTextT!.isNotEmpty) {
      context
          .read<NotesCubit>()
          .addSelectedTextAsNote(selectedTextT!, textTitle);
      // Clear the selected text after saving it as a note
      selectedTextT = null;
    }
  }
}

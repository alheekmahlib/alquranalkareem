import 'package:alquranalkareem/notes/model/Notes.dart';
import 'package:alquranalkareem/notes/note_controller.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../l10n/app_localizations.dart';



class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  int? id;
  String? title;
  String? description;
  late final Notes notes;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late final NoteController _noteController = Get.put(NoteController());

  @override
  void initState() {
    _noteController.getNotes();
    super.initState();
  }


  _validate() {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      _addNotes();
    } else if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      customSnackBar(context, AppLocalizations.of(context)!.fillAllFields);
    }
  }

  _addNotes() async {
    try {
      int? note = await _noteController.addNote(
        Notes(
          id,
          titleController.text,
          descriptionController.text,
        ),
      );
      print('$note');
    } catch (e) {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
            child: Column(
              children: [
                topBar(context),
                const Divider(),
              ],
            )),
        Padding(
          padding: EdgeInsets.only(top: orientation(context, 150.0, 32.0), right: 16.0, left: 16.0),
          child: Obx(() {
            if (_noteController.noteList.isEmpty) {
              return Lottie.asset('assets/lottie/notes.json',
                  width: 150, height: 150);
            } else {
              return AnimationLimiter(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      ExpansionTile(
                        iconColor: Theme.of(context).secondaryHeaderColor,
                        trailing: Icon(
                          Icons.add,
                          color: Theme.of(context).secondaryHeaderColor,
                          size: 20,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.add_new_note,
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 14,
                              fontFamily: 'kufi'),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextFormField(
                                  textAlign: TextAlign.start,
                                  controller: titleController,
                                  autofocus: true,
                                  cursorHeight: 18,
                                  cursorWidth: 3,
                                  cursorColor: Theme.of(context).dividerColor,
                                  onChanged: (value) {
                                    setState(() {
                                      title = value.trim();
                                    });
                                  },
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.surface,
                                      fontFamily: 'kufi',
                                      fontSize: 12),
                                  decoration: InputDecoration(
                                    icon: IconButton(
                                      onPressed: () => titleController.clear(),
                                      icon: Icon(
                                        Icons.clear,
                                        color: Theme.of(context).colorScheme.surface,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.surface),
                                    ),
                                    hintText: AppLocalizations.of(context)!.note_title,
                                    label: Text(
                                      AppLocalizations.of(context)!.note_title,
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.surface),
                                    ),
                                    hintStyle: TextStyle(
                                      // height: 1.5,
                                        color: Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(0.5),
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.normal,
                                        decorationColor: Theme.of(context).primaryColor,
                                        fontSize: 12),
                                    contentPadding:
                                    const EdgeInsets.only(right: 16, left: 16),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  textAlign: TextAlign.start,
                                  controller: descriptionController,
                                  autofocus: true,
                                  cursorHeight: 18,
                                  cursorWidth: 3,
                                  cursorColor: Theme.of(context).dividerColor,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (value) {
                                    setState(() {
                                      description = value.trim();
                                    });
                                  },
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.surface,
                                      fontFamily: 'kufi',
                                      fontSize: 12),
                                  decoration: InputDecoration(
                                    icon: IconButton(
                                      onPressed: () => descriptionController.clear(),
                                      icon: Icon(
                                        Icons.clear,
                                        color: Theme.of(context).colorScheme.surface,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.surface),
                                    ),
                                    hintText: AppLocalizations.of(context)!.note_details,
                                    label: Text(
                                      AppLocalizations.of(context)!.note_details,
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.surface),
                                    ),
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(0.5),
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.normal,
                                        decorationColor: Theme.of(context).primaryColor,
                                        fontSize: 12),
                                    contentPadding:
                                    const EdgeInsets.only(right: 16, left: 16),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                          side: BorderSide(
                                            width: 1.0,
                                            color: Theme.of(context).dividerColor,
                                          )),
                                      onPressed: () {
                                        _validate();
                                        _noteController.getNotes();
                                        titleController.clear();
                                        descriptionController.clear();
                                      },
                                      child: Text(AppLocalizations.of(context)!.save)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _noteController.noteList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var note = _noteController.noteList[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 450),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Dismissible(
                                        background: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.all(Radius.circular(8))),
                                          child: delete(context),
                                        ),
                                        key: ValueKey<int>(note.id!),
                                        onDismissed: (DismissDirection direction) {
                                          _noteController.deleteNotes(note);
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            _noteController.updateNotes(note);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme.surface
                                                    .withOpacity(.2),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    note.title!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'kufi',
                                                      color:
                                                          ThemeProvider.themeOf(context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Colors.white
                                                              : Theme.of(context)
                                                                  .primaryColorDark,
                                                    ),
                                                  ),
                                                  const Divider(
                                                    endIndent: 64,
                                                    height: 1,
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    note.description!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'kufi',
                                                      color:
                                                          ThemeProvider.themeOf(context)
                                                                      .id ==
                                                                  'dark'
                                                              ? Colors.white
                                                              : Theme.of(context)
                                                                  .primaryColorDark,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/lottie.dart';
import '../../../core/widgets/delete_widget.dart';
import '../../../core/widgets/hero_dialog_route.dart';
import '../../../core/widgets/settings_popUp.dart';
import '../../controllers/notes_controller.dart';
import '/core/utils/constants/extensions.dart';
import '/presentation/screens/notes/model/Notes.dart';

class NotesList extends StatelessWidget {
  NotesList({Key? key}) : super(key: key);

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    sl<NotesController>().getNotes();
    double paddingHeight = MediaQuery.sizeOf(context).height;
    return ListView(
      children: [
        ExpansionTile(
          iconColor: Get.theme.secondaryHeaderColor,
          trailing: Icon(
            Icons.add,
            color: Get.theme.secondaryHeaderColor,
            size: 20,
          ),
          title: Text(
            'add_new_note'.tr,
            style: TextStyle(
                color: Get.theme.secondaryHeaderColor,
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
                    controller: sl<NotesController>().titleController,
                    autofocus: true,
                    cursorHeight: 18,
                    cursorWidth: 3,
                    cursorColor: Get.theme.dividerColor,
                    onChanged: (value) {
                      sl<NotesController>().title = value.trim();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: TextStyle(
                        color: Get.theme.colorScheme.surface,
                        fontFamily: 'kufi',
                        fontSize: 12),
                    decoration: InputDecoration(
                      icon: IconButton(
                        onPressed: () =>
                            sl<NotesController>().titleController.clear(),
                        icon: Icon(
                          Icons.clear,
                          color: Get.theme.colorScheme.surface,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Get.theme.colorScheme.surface),
                      ),
                      hintText: 'note_title'.tr,
                      label: Text(
                        'note_title'.tr,
                        style: TextStyle(color: Get.theme.colorScheme.surface),
                      ),
                      hintStyle: TextStyle(
                          // height: 1.5,
                          color: Get.theme.primaryColorLight.withOpacity(0.5),
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.normal,
                          decorationColor: Get.theme.primaryColor,
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
                    controller: sl<NotesController>().descriptionController,
                    autofocus: true,
                    cursorHeight: 18,
                    cursorWidth: 3,
                    cursorColor: Get.theme.dividerColor,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      sl<NotesController>().description = value.trim();
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: TextStyle(
                        color: Get.theme.colorScheme.surface,
                        fontFamily: 'kufi',
                        fontSize: 12),
                    decoration: InputDecoration(
                      icon: IconButton(
                        onPressed: () =>
                            sl<NotesController>().descriptionController.clear(),
                        icon: Icon(
                          Icons.clear,
                          color: Get.theme.colorScheme.surface,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Get.theme.colorScheme.surface),
                      ),
                      hintText: 'note_details'.tr,
                      label: Text(
                        'note_details'.tr,
                        style: TextStyle(color: Get.theme.colorScheme.surface),
                      ),
                      hintStyle: TextStyle(
                          color: Get.theme.primaryColorLight.withOpacity(0.5),
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.normal,
                          decorationColor: Get.theme.primaryColor,
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
                          backgroundColor: Get.theme.colorScheme.surface,
                          side: BorderSide(
                            width: 1.0,
                            color: Get.theme.dividerColor,
                          )),
                      onPressed: () {
                        sl<NotesController>().validate(context);
                        sl<NotesController>().getNotes();
                        sl<NotesController>().titleController.clear();
                        sl<NotesController>().descriptionController.clear();
                      },
                      child: Text(
                        'save'.tr,
                        style:
                            TextStyle(color: Get.theme.colorScheme.background),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Obx(
          () => AnimationLimiter(
            child: sl<NotesController>().notes.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: sl<NotesController>().notes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final note = sl<NotesController>().notes[index];
                      return Column(
                        children: [
                          AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 450),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Dismissible(
                                    background: DeleteWidget(),
                                    key: UniqueKey(),
                                    onDismissed:
                                        (DismissDirection direction) async {
                                      await sl<NotesController>()
                                          .deleteNotes(note.id!);
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        // Get the note at the current index
                                        var note =
                                            sl<NotesController>().notes[index];

                                        // Set the text fields to the current note's values
                                        sl<NotesController>()
                                            .titleController
                                            .text = note.title!;
                                        sl<NotesController>()
                                            .descriptionController
                                            .text = note.description!;

                                        // Navigate to the noteUpdate widget for this note
                                        Navigator.of(context).push(
                                            HeroDialogRoute(builder: (context) {
                                          return settingsPopupCard(
                                            child: noteUpdate(context, note),
                                            height: context.customOrientation(
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    1 /
                                                    2,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    1 /
                                                    2 *
                                                    1.6),
                                            alignment: Alignment.topCenter,
                                            padding: context.customOrientation(
                                                EdgeInsets.only(
                                                    top: paddingHeight * .08,
                                                    right: 16.0,
                                                    left: 16.0),
                                                const EdgeInsets.only(
                                                    top: 70.0,
                                                    right: 16.0,
                                                    left: 16.0)),
                                          );
                                        }));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Get.theme.colorScheme.surface
                                                .withOpacity(.2),
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                  fontSize: 18,
                                                  fontFamily: 'uthmanic2',
                                                  color: Get.isDarkMode
                                                      ? Colors.white
                                                      : Get.theme
                                                          .primaryColorDark,
                                                ),
                                                textAlign: TextAlign.justify,
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
                                                  fontSize: 18,
                                                  fontFamily: 'naskh',
                                                  color: Get.isDarkMode
                                                      ? Colors.white
                                                      : Get.theme
                                                          .primaryColorDark,
                                                ),
                                                textAlign: TextAlign.justify,
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
                          ),
                        ],
                      );
                    })
                : noteLottie(150.0, 150.0),
          ),
        ),
      ],
    );
  }

  Widget noteUpdate(BuildContext context, Notes note) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface.withOpacity(.2),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              TextFormField(
                textAlign: TextAlign.start,
                controller: sl<NotesController>().titleController,
                autofocus: true,
                cursorHeight: 18,
                cursorWidth: 3,
                maxLines: null,
                cursorColor: Get.theme.dividerColor,
                onChanged: (value) {
                  sl<NotesController>().title = value.trim();
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: TextStyle(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Get.theme.primaryColorLight,
                    fontFamily: 'uthmanic2',
                    fontSize: 18),
                decoration: InputDecoration(
                  icon: IconButton(
                    onPressed: () =>
                        sl<NotesController>().titleController.clear(),
                    icon: Icon(
                      Icons.clear,
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Get.theme.colorScheme.surface),
                  ),
                  hintText: 'note_title'.tr,
                  label: Text(
                    'note_title'.tr,
                    style: TextStyle(color: Get.theme.colorScheme.surface),
                  ),
                  hintStyle: TextStyle(
                      // height: 1.5,
                      color: Get.theme.primaryColorLight.withOpacity(0.5),
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.normal,
                      decorationColor: Get.theme.primaryColor,
                      fontSize: 12),
                  contentPadding: const EdgeInsets.only(right: 16, left: 16),
                ),
              ),
              const Divider(
                endIndent: 64,
                height: 1,
              ),
              Container(
                height: 10,
              ),
              TextFormField(
                textAlign: TextAlign.start,
                controller: sl<NotesController>().descriptionController,
                autofocus: true,
                cursorHeight: 18,
                cursorWidth: 3,
                maxLines: null,
                cursorColor: Get.theme.dividerColor,
                onChanged: (value) {
                  sl<NotesController>().description = value.trim();
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: TextStyle(
                    color: Get.isDarkMode
                        ? Colors.white
                        : Get.theme.primaryColorLight,
                    fontFamily: 'naskh',
                    fontSize: 18),
                decoration: InputDecoration(
                  icon: IconButton(
                    onPressed: () =>
                        sl<NotesController>().descriptionController.clear(),
                    icon: Icon(
                      Icons.clear,
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Get.theme.colorScheme.surface),
                  ),
                  hintText: 'note_details'.tr,
                  label: Text(
                    'note_details'.tr,
                    style: TextStyle(color: Get.theme.colorScheme.surface),
                  ),
                  hintStyle: TextStyle(
                      // height: 1.5,
                      color: Get.theme.primaryColorLight.withOpacity(0.5),
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.normal,
                      decorationColor: Get.theme.primaryColor,
                      fontSize: 12),
                  contentPadding: const EdgeInsets.only(right: 16, left: 16),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.surface,
                    side: BorderSide(
                      width: 1.0,
                      color: Get.theme.dividerColor,
                    )),
                onPressed: () {
                  note.title =
                      sl<NotesController>().titleController.text.trim();
                  note.description =
                      sl<NotesController>().descriptionController.text.trim();
                  sl<NotesController>().updateNotes(note);
                  sl<NotesController>().titleController.clear();
                  sl<NotesController>().descriptionController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'save'.tr,
                  style: TextStyle(color: Get.theme.colorScheme.background),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:alquranalkareem/core/widgets/settings_list.dart';
import 'package:alquranalkareem/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../presentation/controllers/general_controller.dart';
import '../../presentation/controllers/notes_controller.dart';
import '../services/services_locator.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class settingsButton extends StatelessWidget {
  final Widget child;
  const settingsButton({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddingHeight = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => GestureDetector(
          onTap: () {
            sl<GeneralController>().showSettings.value = true;
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return settingsPopupCard(
                child: const SettingsList(),
                height: orientation(
                    context,
                    MediaQuery.sizeOf(context).height * 1 / 2,
                    MediaQuery.sizeOf(context).height * 1 / 2 * 1.6),
                alignment: Alignment.topCenter,
                padding: orientation(
                    context,
                    EdgeInsets.only(
                        top: paddingHeight * .08, right: 16.0, left: 16.0),
                    EdgeInsets.only(top: 70.0, right: width * .5, left: 16.0)),
              );
            }));
          },
          child: Container(
            height: 100,
            width: 100,
            color: Theme.of(context).colorScheme.surface,
            child: Hero(
              tag: heroAddTodo,
              createRectTween: (begin, end) {
                return CustomRectTween(begin: begin!, end: end!);
              },
              child: const Icon(
                Icons.settings,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String heroAddTodo = 'add-todo-hero';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class settingsPopupCard extends StatelessWidget {
  final Widget child;
  final double height;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  settingsPopupCard(
      {Key? key,
      required this.child,
      required this.height,
      required this.alignment,
      required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: padding,
          child: SizedBox(
            height: height,
            width: 450,
            child: Hero(
              tag: heroAddTodo,
              createRectTween: (begin, end) {
                return CustomRectTween(begin: begin!, end: end!);
              },
              child: Material(
                color: Theme.of(context).colorScheme.background,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: child,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.close_outlined,
                                size: 40,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(.5)),
                            Icon(Icons.close_outlined,
                                size: 24,
                                color:
                                    ThemeProvider.themeOf(context).id == 'dark'
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).primaryColorDark),
                          ],
                        ),
                        onTap: () {
                          sl<GeneralController>().showSettings.value = false;
                          Navigator.of(context).pop();
                          // setState(() {
                          // TODO:
                          // cubit.isShowSettings = !cubit.isShowSettings;
                          sl<NotesController>().descriptionController.clear();
                          sl<NotesController>().titleController.clear();
                          // });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

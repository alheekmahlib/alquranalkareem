import 'dart:io';

import 'package:alquranalkareem/shared/widgets/settings_list.dart';
import 'package:alquranalkareem/shared/widgets/theme_change.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';
import '../../home_page.dart';
import '../../l10n/app_localizations.dart';
import '../custom_rect_tween.dart';
import '../hero_dialog_route.dart';



/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class settingsButton extends StatelessWidget {
  Widget child;
  settingsButton({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return settingsPopupCard(
              child: const SettingsList(),
              height: orientation(context,
                  MediaQuery.of(context).size.height * 1/2,
                  MediaQuery.of(context).size.height * 1/2 * 1.6),
              alignment: Alignment.topCenter,
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
  Widget child;
  double height;
  Alignment alignment;
  settingsPopupCard({Key? key, required this.child, required this.height, required this.alignment}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0, right: 16.0, left: 16.0),
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
              shape:
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: customClose(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import '/core/services/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../presentation/controllers/playList_controller.dart';
import '../../services/services_locator.dart';

class PlayListSaveWidget extends StatelessWidget {
  const PlayListSaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playList = sl<PlayListController>();
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: Theme.of(context).dividerColor.withOpacity(.4),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(width: 1, color: Theme.of(context).dividerColor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                // key: playListTextFieldKeys[index],
                controller: playList.controller,
                // focusNode: _textFocusNode,
                autofocus: false,
                cursorHeight: 18,
                cursorWidth: 3,
                cursorColor: Theme.of(context).dividerColor,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontFamily: 'kufi',
                    fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  labelText: AppLocalizations.of(context)!.playListName,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: 'kufi',
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.white.withOpacity(.7)
                        : Theme.of(context).primaryColorLight.withOpacity(.7),
                  ),
                  hintText: AppLocalizations.of(context)!.playListName,
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: 'kufi',
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.white.withOpacity(.5)
                        : Theme.of(context).primaryColor.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                playList.saveList();
                playList.reset();
                playList.saveCard.currentState?.expand();
              },
              child: Container(
                height: 35,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    width: 1.0,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontSize: 14,
                      fontFamily: 'kufi',
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

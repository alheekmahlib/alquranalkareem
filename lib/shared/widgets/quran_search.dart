import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../l10n/app_localizations.dart';
import '../../quran_page/data/model/aya.dart';
import 'controllers_put.dart';
import 'lottie.dart';

class QuranSearch extends StatelessWidget {
  QuranSearch({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        topBar(context),
        Container(
          height: 60,
          padding:
              const EdgeInsets.only(top: 8, right: 30, left: 30, bottom: 8),
          child: TextField(
            textAlign: TextAlign.start,
            controller: _controller,
            autofocus: true,
            cursorHeight: 18,
            cursorWidth: 3,
            cursorColor: Theme.of(context).dividerColor,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              ayaController.search(value);
            },
            onChanged: (value) {
              ayaController.search(value);
            },
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontFamily: 'kufi',
                fontSize: 15),
            decoration: InputDecoration(
              icon: IconButton(
                onPressed: () => _controller.clear(),
                icon: Icon(
                  Icons.clear,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.surface),
              ),
              hintText: AppLocalizations.of(context)!.search_word,
              label: Text(
                AppLocalizations.of(context)!.search_word,
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
              hintStyle: TextStyle(
                  // height: 1.5,
                  color: Theme.of(context).primaryColorLight.withOpacity(0.5),
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.normal,
                  decorationColor: Theme.of(context).primaryColor,
                  fontSize: 14),
              contentPadding: const EdgeInsets.only(right: 16, left: 16),
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () {
              if (ayaController.isLoading.value) {
                return search(200.0, 200.0);
              } else if (ayaController.ayahList.isNotEmpty) {
                return ListView.builder(
                  itemCount: ayaController.ayahList.length,
                  itemBuilder: (context, index) {
                    final List<Aya> ayahList = ayaController.ayahList;
                    final aya = ayahList[index];
                    return Container(
                        child: Column(
                      children: <Widget>[
                        Container(
                          color: (index % 2 == 0
                              ? Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.05)
                              : Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.1)),
                          child: ListTile(
                            onTap: () {
                              generalController.dPageController?.animateToPage(
                                aya.pageNum - 1,
                                // 19,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                              Navigator.pop(context);
                            },
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                aya.text,
                                style: TextStyle(
                                  fontFamily: "uthmanic2",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22,
                                  color: ThemeProvider.themeOf(context).id ==
                                          'dark'
                                      ? Theme.of(context).canvasColor
                                      : Theme.of(context).primaryColorDark,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            subtitle: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(4),
                                            bottomRight: Radius.circular(4),
                                          )),
                                      child: Text(
                                        aya.sorahName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Theme.of(context)
                                                        .canvasColor
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        child: Text(
                                          " ${AppLocalizations.of(context)!.part}: ${aya.partNum}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Theme.of(context)
                                                          .canvasColor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                              fontSize: 12),
                                        )),
                                  ),
                                  Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              bottomLeft: Radius.circular(4),
                                            )),
                                        child: Text(
                                          " ${AppLocalizations.of(context)!.page}: ${aya.pageNum}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          'dark'
                                                      ? Theme.of(context)
                                                          .canvasColor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                              fontSize: 12),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider()
                      ],
                    ));
                  },
                );
              } else if (ayaController.errorMessage.value.isNotEmpty) {
                return notFound();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

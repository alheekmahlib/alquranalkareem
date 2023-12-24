import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../../core/services/l10n/app_localizations.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/azkar_controller.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/quranText_controller.dart';
import '../models/azkar.dart';
import '../models/azkar_by_category.dart';

class AzkarItem extends StatefulWidget {
  const AzkarItem({Key? key, required this.azkar}) : super(key: key);
  final String azkar;

  @override
  State<AzkarItem> createState() => _AzkarItemState();
}

class _AzkarItemState extends State<AzkarItem> {
  AzkarByCategory azkarByCategory = AzkarByCategory();

  @override
  void initState() {
    azkarByCategory.getAzkarByCategory(widget.azkar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: customContainer(
              context,
              Text(
                azkarByCategory.azkarList.first.category!,
                style: TextStyle(
                  color: ThemeProvider.themeOf(context).id == 'dark'
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  fontSize: orientation(context, 12.0, 16.0),
                  fontFamily: 'kufi',
                ),
              ),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  sl<GeneralController>().textWidgetPosition.value = -240.0;
                  sl<QuranTextController>().selected.value = false;
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: Theme.of(context).colorScheme.surface,
                )),
            actions: [
              fontSizeDropDown(context),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: orientation(context, const EdgeInsets.all(0),
                    const EdgeInsets.symmetric(horizontal: 64.0)),
                child: SingleChildScrollView(
                  child: Column(
                    children: azkarByCategory.azkarList.map((azkar) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                    vertical: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Obx(() {
                                    return SelectableText(
                                      azkar.zekr!,
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Colors.black,
                                          height: 1.4,
                                          fontFamily: 'naskh',
                                          fontSize: sl<GeneralController>()
                                              .fontSizeArabic
                                              .value),
                                      showCursor: true,
                                      cursorWidth: 3,
                                      cursorColor:
                                          Theme.of(context).dividerColor,
                                      cursorRadius: const Radius.circular(5),
                                      scrollPhysics:
                                          const ClampingScrollPhysics(),
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.justify,
                                    );
                                  }),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(.2),
                                          border: Border.symmetric(
                                              vertical: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  width: 2))),
                                      child: Text(
                                        azkar.reference!,
                                        style: TextStyle(
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColorDark,
                                            fontSize: 12,
                                            fontFamily: 'kufi',
                                            fontStyle: FontStyle.italic),
                                      ))),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withOpacity(.2),
                                        border: Border.symmetric(
                                            vertical: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                width: 2))),
                                    child: Text(
                                      azkar.description!,
                                      style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  'dark'
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .primaryColorDark,
                                          fontSize: 16,
                                          fontFamily: 'kufi',
                                          fontStyle: FontStyle.italic),
                                    ))),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.2),
                                    border: Border.symmetric(
                                        vertical: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            width: 2))),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Share.share('${azkar.category}\n\n'
                                                '${azkar.zekr}\n\n'
                                                '| ${azkar.description}. | (التكرار: ${azkar.count})');
                                          },
                                          icon: Semantics(
                                            button: true,
                                            enabled: true,
                                            label: AppLocalizations.of(context)!
                                                .share,
                                            child: Icon(
                                              Icons.share,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(ClipboardData(
                                                    text:
                                                        '${azkar.category}\n\n${azkar.zekr}\n\n| ${azkar.description}. | (التكرار: ${azkar.count})'))
                                                .then((value) => customSnackBar(
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .copyAzkarText));
                                          },
                                          icon: Semantics(
                                            button: true,
                                            enabled: true,
                                            label: AppLocalizations.of(context)!
                                                .copy,
                                            child: Icon(
                                              Icons.copy,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await sl<AzkarController>()
                                                .addAzkar(Azkar(
                                                    azkar.id,
                                                    azkar.category,
                                                    azkar.count,
                                                    azkar.description,
                                                    azkar.reference,
                                                    azkar.zekr))
                                                .then((value) => customSnackBar(
                                                    context,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .addZekrBookmark));
                                          },
                                          icon: Semantics(
                                            button: true,
                                            enabled: true,
                                            label: AppLocalizations.of(context)!
                                                .addToBookmark,
                                            child: Icon(
                                              Icons.bookmark_add,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            azkar.count!,
                                            style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'kufi',
                                                fontStyle: FontStyle.italic),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.repeat,
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        'dark'
                                                    ? Colors.white
                                                    : Colors.black,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

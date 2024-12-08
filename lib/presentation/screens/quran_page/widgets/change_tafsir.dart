part of '../quran.dart';

class ChangeTafsir extends StatelessWidget {
  const ChangeTafsir({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TafsirCtrl>(
      id: 'change_tafsir',
      builder: (tafsirCtrl) => PopupMenuButton(
        position: PopupMenuPosition.under,
        child: Semantics(
          button: true,
          enabled: true,
          label: 'Change Font Size',
          child: SizedBox(
            width: 120,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    tafsirName[tafsirCtrl.radioValue.value]['name'],
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'kufi'),
                  ),
                  Semantics(
                    button: true,
                    enabled: true,
                    label: 'Change Reader',
                    child: Icon(Icons.keyboard_arrow_down_outlined,
                        size: 20, color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
        itemBuilder: (context) => List.generate(
            tafsirName.length,
            (index) => PopupMenuItem(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          tafsirName[index]['name'],
                          style: TextStyle(
                              color: tafsirCtrl.radioValue.value == index
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : const Color(0xffCDAD80),
                              fontSize: 14,
                              fontFamily: 'kufi'),
                        ),
                        subtitle: Text(
                          tafsirName[index]['bookName'],
                          style: TextStyle(
                              color: tafsirCtrl.radioValue.value == index
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : const Color(0xffCDAD80),
                              fontSize: 12,
                              fontFamily: 'kufi'),
                        ),
                        trailing: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: tafsirCtrl.radioValue.value == index
                                    ? Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                    : const Color(0xffCDAD80),
                                width: 2),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: tafsirCtrl.radioValue.value == index
                              ? Icon(Icons.done,
                                  size: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary)
                              : null,
                        ),
                        onTap: () async {
                          await tafsirCtrl.handleRadioValueChanged(index);
                          GetStorage().write(TAFSEER_VAL, index);
                          sl<TranslateDataController>().fetchTranslate();
                          tafsirCtrl.update(['change_tafsir']);
                          Get.back();
                        },
                        leading: Container(
                            height: 85.0,
                            width: 41.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                                border: Border.all(
                                    color: Theme.of(context).cardColor,
                                    width: 2)),
                            child: Opacity(
                              child: SvgPicture.asset(
                                'assets/svg/tafseer_book.svg',
                              ),
                              opacity:
                                  tafsirCtrl.radioValue.value == index ? 1 : .4,
                            )),
                      ),
                      index == 4
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: context.hDivider(width: 70)),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'translation'.tr,
                                      style: TextStyle(
                                          color: tafsirCtrl.radioValue.value ==
                                                  index
                                              ? Theme.of(context)
                                                  .primaryColorLight
                                              : const Color(0xffCDAD80),
                                          fontSize: 14,
                                          fontFamily: 'kufi'),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: context.hDivider(width: 200)),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                )),
      ),
    );
  }
}

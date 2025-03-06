part of '../../../quran.dart';

class KhatmahBuildWidget extends StatelessWidget {
  KhatmahBuildWidget({super.key});

  final khatmahCtrl = KhatmahController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (khatmahCtrl.khatmas.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(khatmahCtrl.khatmas.length, (index) {
          final khatmah = khatmahCtrl.khatmas[index];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Dismissible(
                background: const DeleteWidget(),
                key: ValueKey<int>(khatmah.id),
                onDismissed: (DismissDirection direction) {
                  khatmahCtrl.deleteKhatmahOnTap(khatmah.id);
                },
                child: ExpansionTileCard(
                  elevation: 0.0,
                  initialElevation: 0.0,
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Color(khatmah.color),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                  ),
                  expandedTextColor: Theme.of(context).primaryColorDark,
                  title: KhatmahNameWidget(
                    khatmah: khatmah,
                  ),
                  baseColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .2),
                  expandedColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .2),
                  children: <Widget>[
                    const Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        KhatmahDaysPage(khatmah: khatmah),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}

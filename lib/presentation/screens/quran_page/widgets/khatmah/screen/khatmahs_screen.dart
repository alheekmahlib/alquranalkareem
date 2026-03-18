part of '../../../quran.dart';

/// =============[KhatmahScreen]==============
class KhatmasScreen extends StatelessWidget {
  KhatmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // height: Get.height * 0.89,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(title: 'khatmah'.tr, horizontalPadding: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  AddKhatmahWidget(),
                  const Gap(8),
                  KhatmahBuildWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

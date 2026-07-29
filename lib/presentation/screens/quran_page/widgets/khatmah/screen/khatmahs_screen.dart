part of '../../../quran.dart';

/// =============[KhatmahScreen]==============
class KhatmasScreen extends StatelessWidget {
  KhatmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: 'khatmah'.tr),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: Get.height * 0.6,
            child: ListView(
              shrinkWrap: true,
              controller: KhatmahController.instance.scrollController,
              children: [
                AddKhatmahWidget(),
                const Gap(8),
                KhatmahBuildWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

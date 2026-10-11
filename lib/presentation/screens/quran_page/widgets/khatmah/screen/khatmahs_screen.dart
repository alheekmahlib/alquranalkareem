part of '../../../quran.dart';

/// =============[KhatmahScreen]==============
class KhatmasScreen extends StatelessWidget {
  const KhatmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: 'khatmah'.tr),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              // نسبة من الشاشة الحرة بعد طرح الكيبورد؛ الارتفاع الثابت
              // من الشاشة كاملة كان يفيض 2.3px عند فتح الكيبورد.
              height:
                  (Get.height - MediaQuery.of(context).viewInsets.bottom) * 0.6,
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
      ),
    );
  }
}

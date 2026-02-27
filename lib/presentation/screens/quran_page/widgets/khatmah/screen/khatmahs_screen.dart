part of '../../../quran.dart';

/// =============[KhatmahScreen]==============
class KhatmasScreen extends StatelessWidget {
  KhatmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [AddKhatmahWidget(), const Gap(8), KhatmahBuildWidget()],
      ),
    );
  }
}

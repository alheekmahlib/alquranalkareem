part of '../../../quran.dart';

/// =============[KhatmahScreen]==============
class KhatmasScreen extends StatelessWidget {
  KhatmasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: ListView(
        children: [
          AddKhatmahWidget(),
          KhatmahBuildWidget(),
        ],
      ),
    );
  }
}

part of '../../../quran.dart';

class KhatmahNameWidget extends StatelessWidget {
  final Khatmah khatmah;
  KhatmahNameWidget({super.key, required this.khatmah});

  @override
  Widget build(BuildContext context) {
    return Text(
      khatmah.name ?? 'khatmah'.tr,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'kufi',
        color: Theme.of(context).hintColor,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

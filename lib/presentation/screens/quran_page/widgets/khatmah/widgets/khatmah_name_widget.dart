part of '../../../quran.dart';

class KhatmahNameWidget extends StatelessWidget {
  final Khatmah khatmah;
  KhatmahNameWidget({
    super.key,
    required this.khatmah,
  });

  final khatmahCtrl = KhatmahController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 380,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(.6),
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: Text(
            khatmah.name ?? 'No Name',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).hintColor,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

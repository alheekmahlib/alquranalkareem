part of '../../quran.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'search_word'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'kufi',
                fontSize: 15,
              ),
            ),
            customSvgWithCustomColor(SvgPath.svgHomeSearch, height: 20),
          ],
        ),
      ),
    );
  }
}

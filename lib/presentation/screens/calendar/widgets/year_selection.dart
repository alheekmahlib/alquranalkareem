part of '../events.dart';

class YearSelection extends StatelessWidget {
  YearSelection({super.key});

  final eventCtrl = EventController.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        width: Get.width * .45,
        // margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.primary.withValues(alpha: .1),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_left,
                  size: 30,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () =>
                    eventCtrl.onYearChanged(eventCtrl.selectedDate.hYear - 1),
              ),
            ),
            Expanded(
              flex: 6,
              child: CustomDropdown<int>(
                excludeSelected: false,
                decoration: CustomDropdownDecoration(
                  closedFillColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  expandedFillColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  closedBorderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                closedHeaderPadding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                itemsListPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                listItemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                // hintText: 'المدة',
                hintBuilder: (context, _, select) => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${eventCtrl.selectedDate.hYear} ${'AH'.tr}'
                        .convertNumbersToCurrentLang(),
                    style: TextStyle(
                      color: Get.theme.colorScheme.inversePrimary,
                      fontSize: 14,
                      fontFamily: 'kufi',
                    ),
                  ),
                ),

                items: List.generate(
                  eventCtrl.endYear! - eventCtrl.startYear! + 1,
                  (index) => eventCtrl.startYear! + index,
                ),
                listItemBuilder: (context, index, select, _) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: eventCtrl.hijriNow.hYear == index
                        ? Get.theme.colorScheme.primary.withValues(alpha: .2)
                        : select
                        ? Get.theme.colorScheme.surface.withValues(alpha: .2)
                        : Colors.transparent,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${index} ${'AH'.tr}'.convertNumbersToCurrentLang(),
                      style: TextStyle(
                        color: Get.theme.colorScheme.inversePrimary,
                        fontSize: 18,
                        fontFamily: 'naskh',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                initialItem: null,
                onChanged: (value) {
                  log('changing value to: $value');
                  eventCtrl.onYearChanged(value!);
                  // khatmahCtrl.daysController.text =
                  //     (value! + 1).toString();
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Theme.of(context).hintColor,
                ),
                onPressed: () =>
                    eventCtrl.onYearChanged(eventCtrl.selectedDate.hYear + 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

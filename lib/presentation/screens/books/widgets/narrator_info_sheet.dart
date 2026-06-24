part of '../books.dart';

/// شيت معلومات الراوي / Narrator info bottom sheet
class NarratorInfoSheet extends StatelessWidget {
  final NarratorInfo narrator;
  final List<NarratorInfo>? otherMatches;

  const NarratorInfoSheet({
    super.key,
    required this.narrator,
    this.otherMatches,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: narrator.name),
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
              // معلومات أساسية
              _buildInfoGrid(context),
              const Gap(12),

              // ترتيب ابن حجر والذهبي
              if (narrator.rankIbnHajar != null ||
                  narrator.rankAlDhahabi != null)
                _buildRankSection(context),

              // الجرح والتعديل
              if (narrator.jarh.isNotEmpty) ...[
                const Gap(12),
                _buildJarhSection(context),
              ],

              // نتائج أخرى
              if (otherMatches != null && otherMatches!.isNotEmpty) ...[
                const Gap(12),
                _buildOtherMatches(context),
              ],
            ],
          ),
          ),
        ),

        const Gap(24),
      ],
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    final items = <_InfoRow>[];
    if (narrator.kunyah != null)
      items.add(_InfoRow('الكنية', narrator.kunyah!));
    if (narrator.nasab != null) items.add(_InfoRow('النسب', narrator.nasab!));
    if (narrator.residence != null)
      items.add(_InfoRow('السكن', narrator.residence!));
    if (narrator.birthDate != null)
      items.add(_InfoRow('الميلاد', narrator.birthDate!));
    if (narrator.deathDate != null)
      items.add(_InfoRow('الوفاة', narrator.deathDate!));
    if (narrator.deathPlace != null)
      items.add(_InfoRow('مكان الوفاة', narrator.deathPlace!));
    if (narrator.travelPlaces != null)
      items.add(_InfoRow('رحلاته', narrator.travelPlaces!));
    if (narrator.tabaqah != null)
      items.add(_InfoRow('الطبقة', narrator.tabaqah!));
    if (narrator.relations != null)
      items.add(_InfoRow('العلاقات', narrator.relations!));

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      '${item.label}: ',
                      style: AppTextStyles.titleSmall(fontSize: 17),
                    ),
                    Expanded(
                      child: Text(
                        item.value,
                        style: AppTextStyles.titleSmall(fontSize: 17),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRankSection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (narrator.rankIbnHajar != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'ترتيب ابن حجر: ',
                    style: AppTextStyles.titleSmall(fontSize: 17),
                  ),
                  Expanded(
                    child: Text(
                      narrator.rankIbnHajar!,
                      style: AppTextStyles.titleSmall(fontSize: 17),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ),
          if (narrator.rankAlDhahabi != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'ترتيب الذهبي: ',
                    style: AppTextStyles.titleSmall(fontSize: 17),
                  ),
                  Expanded(
                    child: Text(
                      narrator.rankAlDhahabi!,
                      style: AppTextStyles.titleSmall(fontSize: 17),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJarhSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ExpansionTileWidget(
        getxCtrl: BooksController.instance,
        manager: BooksController.instance.state.expansionManager,
        name: 'jarh_expansion_tile',
        title: narrator.jarhRaw ?? 'الجرح والتعديل',
        initiallyExpanded: narrator.jarh.length <= 3,
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: narrator.jarh
              .map((jarhItem) => _buildScholarCard(context, jarhItem))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildScholarCard(BuildContext context, JarhSaying jarhItem) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.theme.canvasColor.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jarhItem.scholar,
            style: AppTextStyles.titleMedium(fontSize: 18),
            textDirection: TextDirection.rtl,
          ),
          const Gap(6),
          ...jarhItem.sayings.map(
            (saying) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                saying,
                style: AppTextStyles.titleMedium(fontSize: 16),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherMatches(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نتائج أخرى',
          style: AppTextStyles.titleMedium(fontSize: 16),
          textDirection: TextDirection.rtl,
        ),
        const Gap(6),
        ...otherMatches!
            .take(3)
            .map(
              (match) => ContainerButton(
                isButton: true,
                width: double.infinity,
                horizontalMargin: 8.0,
                horizontalPadding: 0.0,
                title: match.name,
                subtitle: match.rankIbnHajar != null
                    ? match.rankIbnHajar!
                    : null,
                onPressed: () {
                  Get.back();
                  customBottomSheet(NarratorInfoSheet(narrator: match));
                },
              ),
            ),
      ],
    );
  }
}

/// شيت التحميل — يظهر للمستخدم أول مرة يضغط على "بحث عن الراوي"
class NarratorDownloadSheet extends StatelessWidget {
  const NarratorDownloadSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = NarratorsService.instance;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 64,
            color: context.theme.colorScheme.inversePrimary.withValues(
              alpha: .5,
            ),
          ),
          const Gap(16),
          Text(
            'قاعدة بيانات الرواة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'naskh',
              color: context.theme.colorScheme.inversePrimary,
            ),
          ),
          const Gap(8),
          Text(
            'حجم الملف ~48 ميجابايت\nيتم تحميله مرة واحدة فقط',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'naskh',
              color: context.theme.colorScheme.inversePrimary.withValues(
                alpha: .5,
              ),
            ),
          ),
          const Gap(24),
          Obx(() {
            if (ctrl.isDownloading.value) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ctrl.downloadProgress.value,
                      minHeight: 12,
                      backgroundColor: context.theme.colorScheme.surface
                          .withValues(alpha: .1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.theme.colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    '${(ctrl.downloadProgress.value * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: 'naskh',
                      fontSize: 16,
                      color: context.theme.colorScheme.inversePrimary,
                    ),
                  ),
                ],
              );
            }
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => ctrl.downloadNarratorsFile(),
                icon: const Icon(Icons.download),
                label: const Text(
                  'تحميل',
                  style: TextStyle(fontFamily: 'naskh', fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }),
          const Gap(16),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}

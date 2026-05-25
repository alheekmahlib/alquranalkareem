part of '../ai_search.dart';

class ChatHistorySheet extends StatelessWidget {
  const ChatHistorySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder<List<ChatHistoryEntry>>(
        future: AiSearchController.instance.getHistoryEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Text(
                  'noChatHistory'.tr,
                  style: AppTextStyles.titleMedium(
                    fontSize: 14,
                    color: context.theme.colorScheme.inversePrimary.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    TitleWidget(title: 'chatHistory'.tr),
                    const Spacer(),
                    // Clear all button
                    TextButton(
                      onPressed: () async {
                        await AiSearchController.instance.deleteAllHistory();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'clearAllHistory'.tr,
                        style: AppTextStyles.titleMedium(
                          fontSize: 13,
                          color: context.theme.colorScheme.inversePrimary
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(4),
              // Entries list
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.height * 0.5),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const Gap(4),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _buildHistoryItem(context, entry);
                  },
                ),
              ),
              const Gap(16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, ChatHistoryEntry entry) {
    final ctrl = AiSearchController.instance;
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.horizontal,
      onDismissed: (_) async {
        await ctrl.deleteHistoryEntry(entry.id);
      },
      background: const DeleteWidget(),
      child: ContainerButton(
        onPressed: () {
          Navigator.of(context).pop();
          ctrl.loadFromHistory(entry);
        },
        width: double.infinity,
        isButton: true,
        withArrow: true,
        horizontalPadding: 0.0,
        backgroundColor: context.theme.colorScheme.surface.withValues(
          alpha: 0.6,
        ),
        title: entry.query.length > 60
            ? '${entry.query.substring(0, 60)}...'
            : entry.query,
        subtitle:
            '${_formatRelativeDate(entry.date)}  •  ${entry.totalResults} ${'resultCount'.tr}',
      ),
    );
  }

  String _formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} ${'minutes'.tr}';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ${'hours'.tr}';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} ${'days'.tr}';

    // Format as date
    return '${date.day}/${date.month}/${date.year}';
  }
}

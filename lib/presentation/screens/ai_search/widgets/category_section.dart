part of '../ai_search.dart';

/// Category section header + results + "show more" button
class _CategorySection extends StatelessWidget {
  final String title;
  final List<SearchResult> results;
  final String sectionId;
  final String query;
  final bool hasMore;
  final int remainingCount;
  final int totalCount;
  final VoidCallback onShowMore;

  const _CategorySection({
    required this.title,
    required this.results,
    required this.sectionId,
    required this.query,
    required this.hasMore,
    required this.remainingCount,
    required this.totalCount,
    required this.onShowMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium(
                    color: context.theme.colorScheme.surface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '$totalCount',
                style: AppTextStyles.titleMedium(
                  color: context.theme.colorScheme.surface.withValues(
                    alpha: 0.6,
                  ),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Result cards
        ...List.generate(results.length, (index) {
          final cardKey = '${sectionId}_$index';
          return _StreamingResultCard(
            key: ValueKey(cardKey),
            result: results[index],
            color: context.theme.colorScheme.surface,
            query: query,
            cardKey: cardKey,
          );
        }),
        // Show more button
        if (hasMore)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: InkWell(
              onTap: onShowMore,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface.withValues(
                    alpha: 0.05,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.theme.colorScheme.surface.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.expand_more,
                      size: 18,
                      color: context.theme.colorScheme.surface.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      'عرض المزيد ($remainingCount)',
                      style: TextStyle(
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: 0.8,
                        ),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const Gap(16),
      ],
    );
  }
}

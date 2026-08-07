part of '../ai_search.dart';

/// مؤشر يظهر أثناء استدعاء أداة على خادم tafsir-mcp.
///
/// يعرض "جاري استدعاء <اسم الأداة>..." بمؤشر تحميل دوار، بنفس لغة الواجهة.
class ToolCallIndicator extends StatelessWidget {
  const ToolCallIndicator({super.key, required this.toolName});

  final String toolName;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    // خريطة أسماء أدوات MCP إلى أوصاف عربية مفهومة للمستخدم.
    final label = _toolLabels[toolName] ?? toolName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
              ),
            ),
            const Gap(10),
            Flexible(
              child: Text(
                'callingTool'.trParams({'tool': label}),
                style: AppTextStyles.titleMedium(
                  fontSize: 13,
                  color: theme.colorScheme.surface.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// أوصاف عربية لأدوات خادم tafsir-mcp الـ13.
  static const Map<String, String> _toolLabels = {
    'fetch_ayah': 'جلب الآية',
    'fetch_tafsir': 'التفسير',
    'fetch_nuzool_reason': 'سبب النزول',
    'fetch_surah_info': 'معلومات السورة',
    'get_surah_statistics': 'إحصاءات السورة',
    'analyze_word': 'تحليل الكلمة',
    'find_root_occurrences': 'مواضع الجذر',
    'get_root_stats': 'إحصاءات الجذر',
    'search_quran_text': 'البحث النصي',
    'search_in_tafsir': 'البحث في التفسير',
    'get_qeraat_variants': 'القراءات',
    'get_quran_overview': 'نظرة عامة',
    'get_page_fawaed': 'فوائد الصفحة',
    'list_all_sources': 'المصادر',
    'list_tafsir_sources': 'مصادر التفسير',
    'list_science_sources': 'علوم القرآن',
    'list_sources_for_ayah': 'مصادر الآية',
  };
}

part of '../ai_search.dart';

class AiSearchResults extends StatefulWidget {
  const AiSearchResults({super.key});

  @override
  State<AiSearchResults> createState() => _AiSearchResultsState();
}

class _AiSearchResultsState extends State<AiSearchResults> {
  final ctrl = AiSearchController.instance;
  @override
  void initState() {
    super.initState();
    AiSearchController.instance.state.searchTextEditing.addListener(
      _onTextChanged,
    );
    // Init AI search only when screen opens (not on app start)
    AiSearchController.instance.ensureInitialized();
  }

  @override
  void dispose() {
    AiSearchController.instance.state.searchTextEditing.removeListener(
      _onTextChanged,
    );
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primary,
      appBar: AppBarWidget(
        isTitled: false,
        isFontSize: false,
        searchButton: IconButton(
          onPressed: () {
            customBottomSheet(const ChatHistorySheet());
          },
          icon: const SizedBox().customSvgWithColor(
            SvgPath.svgHomeHistory,
            height: 26,
            color: context.theme.canvasColor,
          ),
        ),
        isNotifi: false,
        isBooks: false,
        arrowBackColor: context.theme.canvasColor,
        color: Colors.transparent,
      ),
      body: SafeArea(
        child: Stack(
          alignment: .center,
          children: [
            Column(
              children: [
                // Main scrollable content
                Expanded(
                  child: Center(child: Obx(() => _buildContent(context, ctrl))),
                ),
                // Fixed input bar at bottom — only when sections are loaded
                Obx(() {
                  if (!ctrl.state.hasAnySectionLoaded) {
                    return const SizedBox.shrink();
                  }
                  return Align(
                    alignment: .bottomCenter,
                    child: InputBarWidget(),
                  );
                }),
              ],
            ),
            // Settings floating menu — only when sections are loaded
            Obx(() {
              if (!ctrl.state.hasAnySectionLoaded) {
                return const SizedBox.shrink();
              }
              return FloatingMenuWidget(ctrl: ctrl);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AiSearchController ctrl) {
    // Show loading while initializing
    if (!ctrl.isInitialized.value) {
      return _buildInitializing(context, ctrl);
    }

    if (!ctrl.state.hasAnySectionLoaded) {
      return _buildSectionDownloadPrompt(context, ctrl);
    }

    if (ctrl.state.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final hasResults = SearchSection.all.any(
      (s) => ctrl.state.sectionResults(s.id).isNotEmpty,
    );

    if (!ctrl.state.isSearching.value && !hasResults) {
      if (ctrl.state.searchTextEditing.text.isNotEmpty && hasResults) {
        return _buildNoResults(context, ctrl);
      }
      return _buildEmptyState(context, ctrl);
    }

    return _buildGroupedResults(context, ctrl);
  }

  /// Empty state
  Widget _buildEmptyState(BuildContext context, AiSearchController ctrl) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: .min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _iconWidget(context, ctrl),
                Text(
                  'startSearchPrompt'.tr,
                  style: AppTextStyles.titleMedium(
                    fontSize: 16,
                    color: context.theme.colorScheme.surface,
                  ),
                ),
                const Gap(32),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    'ما فضل صلاة الليل؟',
                    'أحكام الزكاة',
                    'أدلة على وجود الله',
                    'كيفية الوضوء',
                    'فضل سورة البقرة',
                  ].map((s) => _suggestionChip(context, s)).toList(),
                ),
                const Gap(32),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  padding: const EdgeInsets.only(
                    right: 12.0,
                    left: 12.0,
                    top: 12.0,
                    bottom: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.surface.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'midadNote'.tr,
                    style: AppTextStyles.titleMedium(
                      fontSize: 13,
                      color: context.theme.canvasColor.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const SizedBox().customSvgWithColor(
                    SvgPath.svgAlert,
                    height: 24,
                    color: context.theme.colorScheme.surface.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestionChip(
    BuildContext context,
    String text, {
    bool? withArrow = false,
  }) {
    return ContainerButton(
      title: text,
      horizontalPadding: 8.0,
      withArrow: withArrow,
      backgroundColor: context.theme.colorScheme.surface,
      titleStyle: AppTextStyles.titleSmall(color: Colors.black),
      onPressed: () {
        ctrl.state.searchTextEditing.text = text;
        ctrl.search(text);
      },
    );
  }

  Widget _iconWidget(BuildContext context, AiSearchController ctrl) {
    return Column(
      children: [
        const SizedBox().customSvg(SvgPath.svgHomeMidadIcon, height: 70),
        const Gap(8),
        Text(
          ctrl.state.hasAnySectionLoaded
              ? 'midadDescription'.tr
              : 'downloadSections'.tr,
          style: AppTextStyles.titleMedium(
            fontSize: 14,
            color: context.theme.colorScheme.surface,
          ),
        ),
        const Gap(24),
      ],
    );
  }

  /// Section download prompt — welcome screen
  Widget _buildSectionDownloadPrompt(
    BuildContext context,
    AiSearchController ctrl,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            const SizedBox().customSvg(SvgPath.svgHomeMidadIcon, height: 70),
            const Gap(12),
            // Title
            Text(
              'midadWelcome'.tr,
              style: AppTextStyles.titleMedium(
                fontSize: 14,
                color: context.theme.colorScheme.surface,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            // Description
            Text(
              'midadWelcomeDesc'.tr,
              style: AppTextStyles.titleMedium(
                fontSize: 14,
                color: context.theme.colorScheme.surface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            // Instruction
            Text(
              'midadSelectSections'.tr,
              style: AppTextStyles.titleMedium(
                fontSize: 14,
                color: context.theme.colorScheme.surface.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            // Shared files card (must download first)
            if (!ctrl.state.isSharedLoaded.value)
              SharedDownloadCard(onDownload: () => ctrl.downloadShared())
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: context.theme.colorScheme.surface.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'sharedFilesReady'.tr,
                      style: AppTextStyles.titleMedium(
                        fontSize: 13,
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!ctrl.state.isSharedLoaded.value)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'sharedFilesRequired'.tr,
                  style: AppTextStyles.titleMedium(
                    fontSize: 12,
                    color: context.theme.colorScheme.error.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // Section cards
            ...SearchSection.all.map(
              (section) => SectionDownloadCard(
                section: section,
                onDownload: () => ctrl.downloadSection(section),
              ),
            ),
            const Gap(12),
            // Download all button
            Obx(() {
              if (!ctrl.state.isSharedLoaded.value)
                return const SizedBox.shrink();
              final hasUndownloaded = SearchSection.all.any((s) {
                return !ctrl.state.isSectionLoaded(s.id).value;
              });
              if (!hasUndownloaded) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => ctrl.downloadAllSections(ctrl),
                    icon: Icon(
                      Icons.download_rounded,
                      size: 18,
                      color: context.theme.colorScheme.surface.withValues(
                        alpha: 0.8,
                      ),
                    ),
                    label: Text(
                      'downloadAll'.tr,
                      style: AppTextStyles.titleMedium(
                        fontSize: 14,
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: context.theme.colorScheme.surface.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Gap(16),
            // Hint text
            Text(
              'midadLaterHint'.tr,
              style: AppTextStyles.titleMedium(
                fontSize: 12,
                color: context.theme.colorScheme.surface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Initializing indicator (shown while loading model + sections)
  Widget _buildInitializing(BuildContext context, AiSearchController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox().customSvg(SvgPath.svgHomeMidadIcon, height: 70),
          const Gap(24),
          customLottie(LottieConstants.assetsLottieSplashLoading, width: 60.0),
          const Gap(16),
          Text(
            'initializingMidad'.tr,
            style: AppTextStyles.titleMedium(
              fontSize: 15,
              color: context.theme.colorScheme.surface,
            ),
          ),
          const Gap(8),
          Text(
            'initializingMidadDesc'.tr,
            style: AppTextStyles.titleMedium(
              fontSize: 13,
              color: context.theme.colorScheme.surface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context, AiSearchController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconWidget(context, ctrl),
            Icon(
              Icons.search_off,
              size: 48,
              color: context.theme.colorScheme.surface.withValues(alpha: 0.5),
            ),
            const Gap(6),
            Text(
              'noResultsFound'.tr,
              style: AppTextStyles.titleMedium(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.theme.colorScheme.surface.withValues(alpha: 0.9),
              ),
            ),
            const Gap(8),
            Text(
              'tryDifferentQuery'.tr,
              style: AppTextStyles.titleMedium(
                fontSize: 13,
                color: context.theme.colorScheme.surface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Grouped results
  Widget _buildGroupedResults(BuildContext context, AiSearchController ctrl) {
    final query = ctrl.state.searchTextEditing.text;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        children: [
          _iconWidget(context, ctrl),
          // User query bubble
          if (query.isNotEmpty) _buildUserQuery(context, query),
          const Gap(12),

          // Streaming intro text (ChatGPT-style)
          if (!ctrl.state.introStreamed.value)
            _buildStreamingIntro(context, ctrl, query)
          else if (ctrl.state.hasAnyResult)
            _buildStaticIntro(context, ctrl, query),

          const Gap(16),

          // Results per section — after intro streaming completes
          if (ctrl.state.introStreamed.value)
            for (final section in SearchSection.all) ...[
              if (ctrl.state.sectionResults(section.id).isNotEmpty)
                _CategorySection(
                  title: '${'from'.tr} ${section.titleAr.tr}',
                  results: ctrl.state.sectionResults(section.id),
                  sectionId: section.id,
                  query: query,
                  hasMore: ctrl.state.hasMore(section.id),
                  remainingCount: ctrl.state.remainingCount(section.id),
                  totalCount: ctrl.state.totalCount(section.id),
                  onShowMore: () => ctrl.state.showMore(section.id),
                ),
              if (ctrl.state.searchingCategory.value == section.id)
                _buildSearchingIndicator(
                  context,
                  'جاري البحث في ${section.titleAr}...',
                ),
            ],

          // Follow-up suggestions
          if (ctrl.state.allResultsReady.value) ...[
            const Gap(16),
            _buildFollowUpSuggestions(context, query),
          ],
        ],
      ),
    );
  }

  Widget _buildUserQuery(BuildContext context, String query) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 16, left: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withValues(alpha: 0.08),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Text(
          query,
          style: AppTextStyles.titleMedium(
            fontSize: 15,
            height: 1.4,
            color: context.theme.colorScheme.surface,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchingIndicator(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.theme.colorScheme.surface.withValues(alpha: 0.3),
            ),
          ),
          const Gap(10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: context.theme.colorScheme.surface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpSuggestions(BuildContext context, String query) {
    final suggestions = _generateFollowUpSuggestions(query);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions
            .map((s) => _suggestionChip(context, s, withArrow: true))
            .toList(),
      ),
    );
  }

  /// Generate dynamic follow-up suggestions based on query type
  List<String> _generateFollowUpSuggestions(String query) {
    final lower = query.trim().toLowerCase();
    final topic = _extractTopic(query.trim());

    // --- فضائل وأعمال ---
    if (_matchesAny(lower, ['فضل', 'فضلها', 'فوائد', 'ثواب', 'أجر', 'فائدة'])) {
      return ['أحاديث عن $topic', '$topic في القرآن الكريم', 'كيفية $topic'];
    }

    // --- أحكام وفقه ---
    if (_matchesAny(lower, [
      'أحكام',
      'حكم',
      'كيف',
      'كيفية',
      'شروط',
      'واجب',
      'سنة',
      'مستحب',
      'مكروه',
      'حرام',
      'حلال',
    ])) {
      return ['أدلة $topic من السنة', '$topic في القرآن الكريم', 'شروط $topic'];
    }

    // --- عقيدة ---
    if (_matchesAny(lower, [
      'عقيدة',
      'توحيد',
      'إيمان',
      'إله',
      'الله',
      'قدر',
      'قضاء',
      'يوم القيامة',
      'جنة',
      'نار',
    ])) {
      return [
        'أدلة $topic من القرآن',
        'أحاديث عن $topic',
        '$topic عند أهل السنة',
      ];
    }

    // --- سيرة ---
    if (_matchesAny(lower, [
      'غزوة',
      'سيرة',
      'النبي',
      'الرسول',
      'صحابي',
      'معركة',
      'فتح',
      'هجرة',
    ])) {
      return ['الدروس المستفادة من $topic', 'أحداث $topic', 'أحاديث عن $topic'];
    }

    // --- تفسير ---
    if (_matchesAny(lower, ['تفسير', 'معنى', 'آية', 'سورة', 'تأويل'])) {
      return ['أسباب نزول $topic', '$topic في كتب التفسير', 'فضل $topic'];
    }

    // --- أدلة ---
    if (_matchesAny(lower, ['أدلة', 'دليل', 'برهان', 'حجة'])) {
      return [
        'أحاديث عن $topic',
        '$topic في القرآن الكريم',
        'أقوال العلماء في $topic',
      ];
    }

    // --- حديث ---
    if (_matchesAny(lower, [
      'حديث',
      'أحاديث',
      'رواه',
      'البخاري',
      'مسلم',
      'سند',
    ])) {
      return ['درجة حديث $topic', 'شرح $topic', '$topic في كتب السنة'];
    }

    // --- مقارنة ---
    if (_matchesAny(lower, ['فرق', 'مقارنة', 'أيهما', 'أفضل', 'الصحيح'])) {
      return [
        'أدلة $topic',
        'أقوال العلماء في $topic',
        '$topic في القرآن والسنة',
      ];
    }

    // --- افتراضي ---
    return [
      'أحاديث عن $topic',
      '$topic في القرآن الكريم',
      'أقوال العلماء في $topic',
    ];
  }

  /// Extract the core topic from a query by removing question words/prefixes
  String _extractTopic(String query) {
    var topic = query.trim();

    // Remove common question prefixes
    final prefixes = [
      'ما ',
      'ما هي ',
      'ما هو ',
      'ماذا ',
      'هل ',
      'كيف ',
      'كيفية ',
      'لماذا ',
      'لما ',
      'أين ',
      'متى ',
      'من ',
      'كم ',
      'أحكام ',
      'حكم ',
      'فضل ',
      'فوائد ',
      'فائدة ',
      'أدلة على ',
      'أدلة ',
      'دليل على ',
      'دليل ',
      'تفسير ',
      'معنى ',
      'شروط ',
      'أسباب ',
    ];

    for (final prefix in prefixes) {
      if (topic.startsWith(prefix)) {
        topic = topic.substring(prefix.length);
        break; // Only strip the first matching prefix
      }
    }

    // Remove trailing question mark
    if (topic.endsWith('؟') || topic.endsWith('?')) {
      topic = topic.substring(0, topic.length - 1);
    }

    return topic.trim();
  }

  /// Check if text contains any of the keywords
  bool _matchesAny(String text, List<String> keywords) {
    for (final kw in keywords) {
      if (text.contains(kw)) return true;
    }
    return false;
  }

  /// ChatGPT-style streaming intro text
  Widget _buildStreamingIntro(
    BuildContext context,
    AiSearchController ctrl,
    String query,
  ) {
    final introText = _buildIntroText(query, ctrl);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamingTextMarkdown(
          text: introText,
          wordByWord: true,
          chunkSize: 1,
          // fadeInEnabled: true,
          styleSheet: AppTextStyles.titleMedium(
            fontSize: 15,
            height: 1.6,
            color: context.theme.canvasColor,
          ),
          textDirection: TextDirection.rtl,
          markdownEnabled: true,
          onComplete: () {
            ctrl.state.introStreamed.value = true;
          },
        ),
      ),
    );
  }

  /// Static intro text (shown after streaming completes, stays visible)
  Widget _buildStaticIntro(
    BuildContext context,
    AiSearchController ctrl,
    String query,
  ) {
    final introText = _buildIntroText(query, ctrl);
    // Strip markdown bold markers for plain display
    final plainText = introText.replaceAll('**', '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          plainText,
          style: AppTextStyles.titleMedium(
            fontSize: 15,
            height: 1.6,
            color: context.theme.canvasColor,
          ),
        ),
      ),
    );
  }

  /// Build dynamic intro text mentioning ENABLED (selected) sections
  String _buildIntroText(String query, AiSearchController ctrl) {
    final enabledTitles = SearchSection.all
        .where((s) => ctrl.state.isSectionEnabled(s.id))
        .map((s) => s.titleAr.tr)
        .toList();

    String sectionsText;
    if (enabledTitles.isEmpty) {
      sectionsText = 'المصادر المتاحة';
    } else if (enabledTitles.length == 1) {
      sectionsText = enabledTitles.first;
    } else if (enabledTitles.length == 2) {
      sectionsText = '${enabledTitles.first}، ثم ${enabledTitles.last}';
    } else {
      sectionsText =
          '${enabledTitles.take(enabledTitles.length - 1).join('، ')}، ثم ${enabledTitles.last}';
    }

    return 'أبحث عن **$query**...\n\n'
        'أفهم سؤالك جيداً. دعني أبحث لك في المصادر المتاحة وأجمع أفضل ما يتعلق بموضوعك.\n\n'
        'سأبدأ البحث في $sectionsText...\n\n'
        'النتائج ستظهر تباعاً فور العثور عليها...';
  }
}

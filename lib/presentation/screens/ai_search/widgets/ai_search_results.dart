part of '../ai_search.dart';

class AiSearchResults extends StatefulWidget {
  const AiSearchResults({super.key});

  @override
  State<AiSearchResults> createState() => _AiSearchResultsState();
}

class _AiSearchResultsState extends State<AiSearchResults> {
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
    final ctrl = AiSearchController.instance;
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primary,
      appBar: AppBarWidget(
        isTitled: false,
        isFontSize: false,
        searchButton: const SizedBox.shrink(),
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
                // Fixed input bar at bottom
                Align(
                  alignment: .bottomCenter,
                  child: _buildInputBar(context, ctrl),
                ),
              ],
            ),
            FloatingMenuExpendable(
              controller: FloatingMenuExpendableController(
                initialIsOpen: false,
              ),
              panelWidth: 460,
              panelHeight: 460,
              handleWidth: 40,
              handleHeight: 40,
              expandPanelFromHandle: true,
              initialPosition: ctrl.floatingMenuPosition,
              startDocked: false,
              onPositionChanged: ctrl.savePosition,
              // isRTL
              //     ? const Offset(120, 0)
              //     : const Offset(16, 0),
              openMode: FloatingMenuExpendableOpenMode.vertical,
              style: FloatingMenuExpendableStyle(
                // Background barrier
                showBarrierWhenOpen: true,
                barrierDismissible: true,
                barrierColor: context.theme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                barrierBlurSigmaX: 10,
                barrierBlurSigmaY: 10,
                handleMaterialColor: context.theme.canvasColor,
                panelDecoration: BoxDecoration(
                  color: context.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                panelBorderRadius: BorderRadius.circular(8),
              ),
              handleChild: const SizedBox().customSvg(
                SvgPath.svgHomeSetting,
                height: 30,
              ),
              panelChild: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...SearchSection.all.map(
                    (section) => SectionDownloadCard(
                      section: section,
                      onDownload: () => ctrl.downloadSection(section),
                    ),
                  ),
                ],
              ),
            ),
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

  /// ChatGPT-style input bar fixed at bottom
  Widget _buildInputBar(BuildContext context, AiSearchController ctrl) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.theme.colorScheme.surface.withValues(alpha: 0.15),
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Row(
                children: [
                  // Text field
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: ctrl.state.searchTextEditing,
                        cursorColor: context.theme.colorScheme.surface,
                        style: TextStyle(
                          color: context.theme.colorScheme.surface,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'askMidad'.tr,
                          hintStyle: TextStyle(
                            color: context.theme.colorScheme.surface,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (query) {
                          if (query.trim().isNotEmpty) {
                            ctrl.search(query);
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                      ),
                    ),
                  ),
                  // Clear button
                  if (ctrl.state.searchTextEditing.text.isNotEmpty)
                    IconButton(
                      onPressed: () => ctrl.clearSearch(),
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 12),
                ],
              ),
              Row(
                children: [
                  // Send button
                  IconButton(
                    onPressed: ctrl.state.searchTextEditing.text.isNotEmpty
                        ? () {
                            final query = ctrl.state.searchTextEditing.text
                                .trim();
                            if (query.isNotEmpty) {
                              ctrl.search(query);
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          }
                        : null,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.surface.withValues(
                          alpha: ctrl.state.searchTextEditing.text.isNotEmpty
                              ? 0.25
                              : .1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        size: 18,
                        color: context.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  // Section filter dropdown
                  SectionFilterWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Empty state
  Widget _buildEmptyState(BuildContext context, AiSearchController ctrl) {
    return Column(
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
                    color: context.theme.colorScheme.surface.withValues(
                      alpha: 0.8,
                    ),
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
    );
  }

  Widget _suggestionChip(BuildContext context, String text) {
    final ctrl = AiSearchController.instance;
    return ContainerButton(
      title: text,
      horizontalPadding: 8.0,
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

  /// Section download prompt
  Widget _buildSectionDownloadPrompt(
    BuildContext context,
    AiSearchController ctrl,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: .center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconWidget(context, ctrl),
            ...SearchSection.all.map(
              (section) => SectionDownloadCard(
                section: section,
                onDownload: () => ctrl.downloadSection(section),
              ),
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
    final suggestions = <String>[
      'ماذا قال ابن كثير؟',
      'أحاديث عن $query',
      'تفسير مفصل',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((s) => _suggestionChip(context, s)).toList(),
      ),
    );
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

  /// Build dynamic intro text mentioning only loaded sections
  String _buildIntroText(String query, AiSearchController ctrl) {
    final loadedTitles = SearchSection.all
        .where((s) => ctrl.state.isSectionLoaded(s.id).value)
        .map((s) => s.titleAr.tr)
        .toList();

    String sectionsText;
    if (loadedTitles.isEmpty) {
      sectionsText = 'المصادر المتاحة';
    } else if (loadedTitles.length == 1) {
      sectionsText = loadedTitles.first;
    } else if (loadedTitles.length == 2) {
      sectionsText = '${loadedTitles.first}، ثم ${loadedTitles.last}';
    } else {
      sectionsText =
          '${loadedTitles.take(loadedTitles.length - 1).join('، ')}، ثم ${loadedTitles.last}';
    }

    return 'أبحث عن **$query**...\n\n'
        'أفهم سؤالك جيداً. دعني أبحث لك في المصادر المتاحة وأجمع أفضل ما يتعلق بموضوعك.\n\n'
        'سأبدأ بـ$sectionsText — بحسب الأقسام المحملة على جهازك.\n\n'
        'النتائج ستظهر تباعاً فور العثور عليها...';
  }
}

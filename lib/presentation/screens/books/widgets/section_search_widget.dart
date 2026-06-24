part of '../books.dart';

class SectionSearchWidget extends StatefulWidget {
  final String title;
  const SectionSearchWidget({super.key, required this.title});

  @override
  State<SectionSearchWidget> createState() => _SectionSearchWidgetState();
}

class _SectionSearchWidgetState extends State<SectionSearchWidget>
    with SingleTickerProviderStateMixin {
  final booksCtrl = BooksController.instance;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _iconFadeAnimation;
  late final FocusNode _searchFocusNode;
  late final TextEditingController _textController;
  Worker? _searchWorker;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _iconFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _searchFocusNode = FocusNode();
    _textController = TextEditingController();

    // مزامنة مع حالة البحث - Sync with search state
    _searchWorker = ever(booksCtrl.state.isSearch, (bool val) {
      if (val && !_isExpanded) {
        _expand();
      } else if (!val && _isExpanded) {
        _collapse();
      }
    });
  }

  @override
  void dispose() {
    _searchWorker?.dispose();
    _controller.dispose();
    _searchFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _expand() {
    setState(() => _isExpanded = true);
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _collapse() {
    _controller.reverse().then((_) {
      if (mounted) setState(() => _isExpanded = false);
      _textController.clear();
      booksCtrl.state.searchQuery.value = '';
      booksCtrl.searchBookNames('');
    });
  }

  void _toggleSearch() {
    if (_isExpanded) {
      booksCtrl.state.isSearch.value = false;
    } else {
      booksCtrl.state.isSearch.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // — الصف العلوي: العنوان + أزرار البحث والترتيب —
          SizedBox(
            height: 48,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                // العنوان — يختفي عند تفعيل البحث
                FadeTransition(
                  opacity: _iconFadeAnimation,
                  child: IgnorePointer(
                    ignoring: _isExpanded,
                    child: TitleWidget(
                      title: widget.title,
                      horizontalPadding: 0.0,
                    ),
                  ),
                ),
                // الأزرار على اليمين — زر الترتيب + زر البحث
                if (!_isExpanded)
                  PositionedDirectional(
                    end: 0,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر الترتيب
                        _buildSortButton(context),
                        const Gap(4),
                        // زر البحث
                        _buildSearchIconButton(),
                      ],
                    ),
                  ),
                // حقل البحث — يتمدد عند التفعيل
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: AnimatedBuilder(
                    animation: _expandAnimation,
                    builder: (context, child) {
                      final screenWidth = Get.width;
                      final collapsedWidth = 48.0;
                      final expandedWidth = screenWidth - 32.0;
                      final width =
                          collapsedWidth +
                          (expandedWidth - collapsedWidth) *
                              _expandAnimation.value;

                      return Container(
                        height: 48,
                        width: width,
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface.withValues(
                            alpha: .4,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Row(
                            children: [
                              // زر الرجوع
                              _buildSearchButton(),
                              // حقل النص
                              Expanded(
                                child: FadeTransition(
                                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: _controller,
                                          curve: const Interval(
                                            0.3,
                                            1.0,
                                            curve: Curves.easeIn,
                                          ),
                                        ),
                                      ),
                                  child: SizeTransition(
                                    sizeFactor: _expandAnimation,
                                    axis: Axis.horizontal,
                                    child: Center(
                                      child: _buildTextField(context),
                                    ),
                                  ),
                                ),
                              ),
                              // زر المسح
                              FadeTransition(
                                opacity: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: _controller,
                                        curve: const Interval(
                                          0.3,
                                          1.0,
                                          curve: Curves.easeIn,
                                        ),
                                      ),
                                    ),
                                child: SizeTransition(
                                  sizeFactor: _expandAnimation,
                                  axis: Axis.horizontal,
                                  child: _buildClearButton(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// زر البحث المنفصل (حالة غير متمدد)
  Widget _buildSearchIconButton() {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        onPressed: _toggleSearch,
        icon: const SizedBox().customSvgWithCustomColor(
          SvgPath.svgHomeSearch,
          height: 22,
          width: 22,
          color: Get.theme.primaryColorLight,
        ),
      ),
    );
  }

  /// زر الترتيب
  Widget _buildSortButton(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        onPressed: () => customBottomSheet(_SortOptionsSheet()),
        icon: const SizedBox().customSvgWithCustomColor(
          SvgPath.svgBooksSortDown,
          height: 22,
          width: 22,
          color: Get.theme.primaryColorLight,
        ),
      ),
    );
  }

  /// زر البحث/الرجوع (داخل حقل البحث)
  Widget _buildSearchButton() {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        onPressed: _toggleSearch,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: _isExpanded
              ? SizedBox(
                  key: const ValueKey('back'),
                  child: const SizedBox().customSvgWithCustomColor(
                    SvgPath.svgHomeArrowBack,
                    height: 22,
                    width: 22,
                    color: context.theme.primaryColorLight,
                  ),
                )
              : SizedBox(
                  key: const ValueKey('search'),
                  child: const SizedBox().customSvgWithCustomColor(
                    SvgPath.svgHomeSearch,
                    height: 22,
                    width: 22,
                    color: context.theme.primaryColorLight,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: _textController,
      focusNode: _searchFocusNode,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.bodySmall(
        color: context.theme.colorScheme.inversePrimary,
      ),
      decoration: InputDecoration(
        hintText: 'search'.tr,
        hintStyle: AppTextStyles.bodySmall(
          color: context.theme.colorScheme.inversePrimary.withValues(alpha: .4),
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (value) {
        booksCtrl.searchBookNames(value);
      },
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _textController,
      builder: (context, value, child) {
        final showClear = value.text.isNotEmpty;
        return AnimatedOpacity(
          opacity: showClear ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: IgnorePointer(
            ignoring: !showClear,
            child: CustomButton(
              width: 40,
              height: 48,
              onPressed: () {
                _textController.clear();
                booksCtrl.state.searchQuery.value = '';
                booksCtrl.searchBookNames('');
                _searchFocusNode.requestFocus();
              },
              svgPath: SvgPath.svgHomeClose,
            ),
          ),
        );
      },
    );
  }
}

/// BottomSheet لخيارات الترتيب - Sort options bottom sheet
class _SortOptionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final booksCtrl = BooksController.instance;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // العنوان
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const TitleWidget(title: 'sortBooks', horizontalPadding: 0.0),
              const Spacer(),
              // زر تبديل تصاعدي/تنازلي (يُخفى للترتيب الافتراضي وسنة الوفاة)
              Obx(() {
                final hideToggle =
                    booksCtrl.state.sortType.value ==
                        BookSortType.defaultOrder ||
                    booksCtrl.state.sortType.value == BookSortType.deathYear;
                if (hideToggle) return const SizedBox.shrink();
                return TextButton.icon(
                  onPressed: () {
                    booksCtrl.state.sortAscending.toggle();
                    booksCtrl.update(['booksList']);
                  },
                  icon: Icon(
                    booksCtrl.state.sortAscending.value
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 18,
                    color: context.theme.primaryColorLight,
                  ),
                  label: Text(
                    booksCtrl.state.sortAscending.value
                        ? 'ascending'.tr
                        : 'descending'.tr,
                    style: AppTextStyles.bodySmall(
                      color: context.theme.primaryColorLight,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const Gap(8),
        // قائمة خيارات الترتيب
        ...BookSortType.values.map((type) {
          return Obx(
            () => ContainerButton(
              onPressed: () {
                booksCtrl.state.sortType.value = type;
                booksCtrl.update(['booksList']);
                Navigator.of(context).pop();
              },
              width: double.infinity,
              isButton: booksCtrl.state.sortType.value == type,
              horizontalMargin: 16.0,
              horizontalPadding: 0.0,
              verticalPadding: 6.0,
              backgroundColor: booksCtrl.state.sortType.value == type
                  ? context.theme.primaryColorLight.withValues(alpha: .3)
                  : Colors.transparent,
              title: type.label.tr,
              titleColor: context.theme.colorScheme.inversePrimary,
            ),
          );
        }),
        const Gap(16),
      ],
    );
  }
}

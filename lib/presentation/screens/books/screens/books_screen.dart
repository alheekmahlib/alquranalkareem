part of '../books.dart';

class BooksScreen extends StatelessWidget {
  final booksCtrl = BooksController.instance;

  BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, _) {
        AppTour.instance.closeTourIfRunning();
      },
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.primary,
        body: SafeArea(
          child: Container(
            color: context.theme.colorScheme.primaryContainer,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: Obx(() {
                    final tabs = buildBooksTabs(booksCtrl.state.bookTypes);
                    return BooksTabBarWidget(topPadding: 120.0, tabs: tabs);
                  }),
                ),
                TopBarWidget(
                  isHomeChild: true,
                  isQuranSetting: false,
                  isNotification: false,
                  tabBarController:
                      BooksController.instance.state.tabBarController,
                  bodyChild: Obx(() {
                    if (booksCtrl.state.isAiMode.value) {
                      return AiBodyWidget();
                    }
                    return SearchBuild();
                  }),
                  centerChild: TextFieldBarWidget(
                    // هدف جولة المكتبة: حقل البحث في الكتب.
                    key: BooksTourKeys.searchField,
                    hintText: 'searchInBooks'.tr,
                    controller: booksCtrl.state.searchController,
                    horizontalPadding: 0.0,
                    onPressed: () {
                      QuranController.instance.setTopBarType =
                          TopBarType.search;
                      BooksController.instance.state.tabBarController.open();
                    },
                    onButtonPressed: () {
                      booksCtrl.state.searchResults.clear();
                      booksCtrl.state.subjectSearchResults.clear();
                      booksCtrl.state.searchedBookTypes.clear();
                      booksCtrl.state.sectionVisibleCount.clear();
                      booksCtrl.state.activeSearchQuery = null;
                      booksCtrl.state.searchController.clear();
                    },
                    // onChanged: (query) => booksCtrl.searchBooks(query),
                    onSubmitted: (query) => booksCtrl.searchBooks(query),
                  ),
                ),
                // يشغّل جولة المكتبة تلقائياً أول مرة بعد اكتمال تحميل الكتب.
                const _BooksTourTrigger(),
                BooksTourReplayButton(
                  onPressed: () => AppTour.instance.replayBooksTour(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// زر إعادة جولة شاشة من شاشات المكتبة (زر الاستفهام العائم)، كل شاشة تمرّر
/// جولتها. في القارئ يرتفع فوق شريط القراءة السفلي بتمرير [bottom].
class BooksTourReplayButton extends StatelessWidget {
  const BooksTourReplayButton({
    super.key,
    required this.onPressed,
    this.bottom,
  });

  final VoidCallback onPressed;

  /// المسافة بين الزر وحافة الشاشة السفلى.
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom ?? 16.0, right: 8.0, left: 8.0),
        child: CustomButton(
          height: 50,
          width: 50,
          backgroundColor: context.theme.colorScheme.surface,
          isCustomSvgColor: true,
          svgPath: SvgPath.svgHomeCommentQuestion,
          svgColor: context.theme.canvasColor,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

/// يشغّل جولة قائمة الكتب تلقائياً أول مرة بعد اكتمال تحميل الكتب: الجولة
/// تُبنى على حالة مستقرة (شريط آخر قراءة وشبكة كتب ظاهرة) لا على شاشة
/// التحميل. وكونه ودجتاً داخل الشاشة يلغي التشغيلَ بعد مغادرتها، فالبطاقة
/// تُفكَّك معها فيُلغى النداء المعلَّق ولا تبدأ الجولة فوق شاشة أخرى.
class _BooksTourTrigger extends StatefulWidget {
  const _BooksTourTrigger();

  @override
  State<_BooksTourTrigger> createState() => _BooksTourTriggerState();
}

class _BooksTourTriggerState extends State<_BooksTourTrigger> {
  final booksCtrl = BooksController.instance;
  bool _armed = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ready = !booksCtrl.state.isLoading.value;
      if (ready && !_armed) {
        _armed = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) AppTour.instance.startBooksTourOnce();
        });
      }
      return const SizedBox.shrink();
    });
  }
}

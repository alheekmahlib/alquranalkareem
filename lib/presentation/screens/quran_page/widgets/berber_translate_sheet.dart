part of '../quran.dart';

/// نافذة سفلية مخصصة للترجمة الأمازيغية
/// Custom bottom sheet for Berber translation
class BerberTranslateSheet extends StatefulWidget {
  final int surahNum;
  final int ayahNum;
  final String ayahTextNormal;

  const BerberTranslateSheet({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahTextNormal,
  });

  @override
  State<BerberTranslateSheet> createState() => _BerberTranslateSheetState();
}

class _BerberTranslateSheetState extends State<BerberTranslateSheet> {
  /// Dedicated player for Berber audio translations
  final AudioPlayer _berberPlayer = AudioPlayer();
  bool _isPlaying = false;

  /// Current displayed ayah (user can navigate prev/next inside the sheet)
  late int _currentAyah;

  /// Local image height (font-size equivalent for images)
  late double _imgHeight;

  /// Surah info from assets/info.json
  List<dynamic> _surahsData = [];

  @override
  void initState() {
    super.initState();
    _currentAyah = widget.ayahNum;
    _imgHeight = 32.0;
    _loadSurahInfo();
  }

  Future<void> _loadSurahInfo() async {
    try {
      final String response = await rootBundle.loadString('assets/info.json');
      final data = await json.decode(response);
      setState(() {
        _surahsData = data;
      });
    } catch (e) {
      log('Error loading surah info: $e');
    }
  }

  // ---- path helpers ----

  String _imagePath(int surah, int ayah, int part) {
    final s = surah.toString().padLeft(3, '0');
    final a = ayah.toString().padLeft(3, '0');
    return 'assets/translate_kabyle_image_hafs/translate_$s/${a}_$part.jpg';
  }

  String _audioPath(int surah, int ayah) {
    final s = surah.toString().padLeft(3, '0');
    final a = ayah.toString().padLeft(3, '0');
    return 'assets/translate_kabyle_voix_hafs/$s/$a.mp3';
  }

  List<String> _imagePaths(int surah, int ayah) =>
      List.generate(60, (i) => _imagePath(surah, ayah, i));

  // ---- navigation ----

  void _goToPrevAyah() {
    if (_currentAyah > 1) {
      _stopAudio();
      setState(() => _currentAyah--);
    }
  }

  void _goToNextAyah() {
    _stopAudio();
    setState(() => _currentAyah++);
  }

  // ---- audio ----

  void _stopAudio() {
    _berberPlayer.stop();
    setState(() => _isPlaying = false);
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      _stopAudio();
      return;
    }
    final path = _audioPath(widget.surahNum, _currentAyah);
    try {
      await _berberPlayer.setAsset(path);
      _berberPlayer.play();
      setState(() => _isPlaying = true);
      _berberPlayer.playerStateStream.listen((s) {
        if (s.processingState == ProcessingState.completed) {
          if (mounted) setState(() => _isPlaying = false);
        }
      });
    } catch (_) {
      Get.snackbar(
        'ⵣ',
        'الترجمة الصوتية غير متوفرة لهذه الآية',
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _berberPlayer.dispose();
    super.dispose();
  }

  // Matrix to convert white bg to transparent, black text to white (Dark Mode)
  static const ColorFilter _darkFilter = ColorFilter.matrix(<double>[
    0, 0, 0, 0, 255, // R' = 255
    0, 0, 0, 0, 255, // G' = 255
    0, 0, 0, 0, 255, // B' = 255
    -1, 0, 0, 0, 255, // A' = 255 - R
  ]);

  // Matrix to convert white bg to transparent, keep text black (Light Mode)
  static const ColorFilter _lightFilter = ColorFilter.matrix(<double>[
    0, 0, 0, 0, 0, // R' = 0
    0, 0, 0, 0, 0, // G' = 0
    0, 0, 0, 0, 0, // B' = 0
    -1, 0, 0, 0, 255, // A' = 255 - R
  ]);

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeController.instance.isDarkMode;
    final primary = Get.theme.colorScheme.primary;
    final scaleFactor = _imgHeight / 18.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 8),
              // Decorative handle
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              // ── Top Header Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      'translation'.tr,
                      style: QuranLibrary().cairoStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Audio play/stop button
                        IconButton(
                          onPressed: _toggleAudio,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              _isPlaying
                                  ? Icons.stop_circle_rounded
                                  : Icons.play_circle_filled_rounded,
                              key: ValueKey(_isPlaying),
                              size: 28,
                              color: _isPlaying ? Colors.red.shade400 : primary,
                            ),
                          ),
                          tooltip: _isPlaying ? 'إيقاف' : 'استماع للترجمة',
                        ),
                        // Divider
                        Container(width: 1, height: 24, color: Colors.grey.shade300),
                        const SizedBox(width: 4),
                        // Global font size dropdown (Controls Arabic Text)
                        const SizedBox().fontSizeDropDownWidget(),
                        // Berber image font size dropdown (matches Arabic one but controls _imgHeight)
                        PopupMenuButton(
                          position: PopupMenuPosition.under,
                          icon: Semantics(
                            button: true,
                            enabled: true,
                            label: 'Change Berber Font Size',
                            child: Transform.translate(
                              offset: const Offset(0, -5),
                              child: Icon(
                                Icons.format_size_rounded,
                                size: 28,
                                color: primary,
                              ),
                            ),
                          ),
                          color: Get.theme.colorScheme.primary.withValues(alpha: .8),
                          iconSize: 35.0,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              height: 30,
                              child: SizedBox(
                                height: 30,
                                width: MediaQuery.sizeOf(context).width,
                                child: FlutterSlider(
                                  values: [_imgHeight],
                                  max: 72,
                                  min: 12,
                                  rtl: true,
                                  trackBar: FlutterSliderTrackBar(
                                    inactiveTrackBarHeight: 5,
                                    activeTrackBarHeight: 5,
                                    inactiveTrackBar: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Get.theme.colorScheme.surface,
                                    ),
                                    activeTrackBar: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Get.theme.colorScheme.primaryContainer,
                                    ),
                                  ),
                                  handlerAnimation: const FlutterSliderHandlerAnimation(
                                    curve: Curves.elasticOut,
                                    reverseCurve: null,
                                    duration: Duration(milliseconds: 700),
                                    scale: 1.4,
                                  ),
                                  onDragging: (handlerIndex, lowerValue, upperValue) {
                                    setState(() {
                                      _imgHeight = lowerValue;
                                    });
                                  },
                                  handler: FlutterSliderHandler(
                                    decoration: const BoxDecoration(),
                                    child: Material(
                                      type: MaterialType.circle,
                                      color: Colors.transparent,
                                      elevation: 3,
                                      child: SvgPicture.asset('assets/svg/slider_ic.svg'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Translation Content ──
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF151515)
                        : Get.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Arabic ayah text
                        Obx(
                          () => GetSingleAyah(
                            surahNumber: widget.surahNum,
                            ayahNumber: _currentAyah,
                            fontSize: TafsirCtrl.instance.fontSizeArabic.value + 2,
                            isBold: false,
                            isSingleAyah: true,
                            isDark: isDark,
                            textColor: isDark ? Colors.white : Colors.black87,
                            useDefaultFont: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Divider
                        context.horizontalDivider(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.withValues(alpha: 0.3),
                          height: 1.5,
                        ),
                        const SizedBox(height: 12),

                        // --- Active System Translation (e.g. English, French, etc.) ---
                        GetBuilder<TafsirAndTranslateController>(
                          builder: (transCtrl) {
                            final quranCtrl = QuranController.instance;
                            final ayahModel = quranCtrl.state.surahs[widget.surahNum - 1]
                                .ayahs[_currentAyah - 1];
                            final translation = TafsirCtrl.instance
                                .getTranslationForAyahModel(ayahModel, ayahModel.ayahUQNumber);

                            if (translation == null || translation.cleanText.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  translation.cleanText,
                                  style: TextStyle(
                                    fontSize: sl<GeneralController>().state.fontSizeArabic.value - 3,
                                    fontFamily: sl<SettingsController>().languageFont.value,
                                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 12),
                                context.horizontalDivider(
                                  color: isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.withValues(alpha: 0.3),
                                  height: 1.5,
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),

                        // Berber translation images — RTL flowing text with transparent BG
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4 * scaleFactor,
                            runSpacing: 2 * scaleFactor,
                            children: _imagePaths(widget.surahNum, _currentAyah)
                                .map((path) => ColorFiltered(
                                      colorFilter: isDark ? _darkFilter : _lightFilter,
                                      child: Image.asset(
                                        path,
                                        height: _imgHeight,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const SizedBox.shrink(),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Prev / Next Ayah Navigation ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // In RTL: right side = "previous" (higher ayah number)
                    TextButton.icon(
                      onPressed: _currentAyah > 1 ? _goToPrevAyah : null,
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      label: Text('prev_ayah'.tr),
                      style: TextButton.styleFrom(foregroundColor: primary),
                    ),
                    // Ayah indicator with 3 surah names
                    Expanded(
                      child: Center(
                        child: _surahsData.isEmpty
                            ? Text(
                                '${widget.surahNum} : $_currentAyah',
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_surahsData[widget.surahNum - 1]['sura_name_berber']} - ${_surahsData[widget.surahNum - 1]['sura_name_ar']}',
                                    style: TextStyle(
                                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'droid_kufi',
                                    ),
                                  ),
                                  Text(
                                    '${_surahsData[widget.surahNum - 1]['sura_name_en']} : $_currentAyah',
                                    style: TextStyle(
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    // Next ayah
                    TextButton.icon(
                      onPressed: _goToNextAyah,
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                      label: Text('next_ayah'.tr),
                      style: TextButton.styleFrom(foregroundColor: primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

part of '../../quran.dart';

/// شريط التحكم بالتسميع في شريط التنقل السفلي — بديل [AudioWidget]
/// في وضع التسميع، بتصميم التطبيق الخاص.
///
/// الحالات: خمول (زر تسجيل) / اتصال أو تسجيل (عداد الكلمات + إيقاف) /
/// معالجة (انتظار) / تجهيز المحرك أو تنزيل النموذج / خطأ.
/// عند اكتمال التقييم تُفتح ورقة النتائج تلقائيًا — منطقها في
/// [TasmeeSettingsController] وليس هنا، فالويدجت Stateless.
class TasmeeBarWidget extends StatelessWidget {
  TasmeeBarWidget({super.key});

  final tasmee = TasmeeCtrl.instance;

  // الوصول للكونترولر يضمن إنشاءه (وتسجيل مستمع فتح ورقة النتائج في
  // onInit) عند أول بناء للشريط حتى لو لم تُفتح الإعدادات قط.
  // ignore: unused_field
  final TasmeeSettingsController _settingsCtrl =
      TasmeeSettingsController.instance;

  // إنشاء مبكر لمنسّق الجلسات — بدون هذا تبقى مستمعاته (فتح شيت تصحيح
  // الكلمة، حلقة المعلم، حفظ النتائج) غير مسجَّلة حتى أول لمسٍ لها،
  // وقد يبدأ المستخدم التسجيل قبل ذلك فلا يظهر شيت التصحيح أصلًا.
  final TasmeeSessionController _sessionCtrl = TasmeeSessionController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
        child: Obx(() {
          final sessionState = tasmee.state.sessionState.value;
          final mode = tasmee.state.mode.value;
          return Row(
            children: [
              if (mode == TasmeeMode.teacher)
                _buildTeacherAction()
              else
                _buildAction(sessionState),
              const Gap(8),
              Expanded(
                child: mode == TasmeeMode.teacher
                    ? _buildTeacherStatus()
                    : _buildStatus(),
              ),
              // زر العين يخص نمط التسميع فقط — الكلمات ظاهرة أصلًا في
              // المصحح والمعلم.
              if (mode == TasmeeMode.tasmee)
                CustomButton(
                  isCustomSvgColor: true,
                  tooltip: tasmee.state.showAllWords.value
                      ? 'tasmeeHideWords'.tr
                      : 'tasmeeShowWords'.tr,
                  svgPath: tasmee.state.showAllWords.value
                      ? SvgPath.svgQuranEyeCrossed
                      : SvgPath.svgQuranEye,
                  svgColor: tasmee.state.showAllWords.value
                      ? Get.theme.colorScheme.surface
                      : Get.theme.primaryColorLight,
                  onPressed: () => _busy ? null : tasmee.toggleShowAllWords(),
                ),
              CustomButton(
                isCustomSvgColor: true,
                tooltip: 'tasmeeRetry'.tr,
                svgPath: SvgPath.svgAudioLoop,
                svgColor: Get.theme.primaryColorLight,
                onPressed: () => _busy
                    ? null
                    : mode == TasmeeMode.teacher
                    ? _sessionCtrl.restartTeacherSession()
                    : tasmee.retryTasmee(),
              ),
              CustomButton(
                isCustomSvgColor: true,
                tooltip: 'checkList'.tr,
                svgPath: SvgPath.svgQuranCheckList,
                svgColor: Get.theme.primaryColorLight,
                onPressed: () =>
                    customBottomSheet(const TasmeePagesListWidget()),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// هل الجلسة نشطة (لا يجوز إظهار/إخفاء الكلمات أو الإعادة)؟
  bool get _busy {
    final s = tasmee.state.sessionState.value;
    return s == RecitationState.recording ||
        s == RecitationState.processing ||
        s == RecitationState.connecting;
  }

  /// زر البدء/الإيقاف الدائري في بداية الشريط.
  Widget _buildAction(RecitationState sessionState) {
    switch (sessionState) {
      case RecitationState.recording:
      case RecitationState.connecting:
        return CustomButton(
          isCustomSvgColor: true,
          svgPath: SvgPath.svgQuranStop,
          tooltip: 'tasmeeStopRecording'.tr,
          onPressed: tasmee.stopRecording,
          svgColor: Get.theme.colorScheme.surface,
        );
      case RecitationState.processing:
        return _processingIndicator();
      default:
        return CustomButton(
          svgPath: SvgPath.svgQuranMicrophone,
          tooltip: 'tasmeeStartRecording'.tr,
          onPressed: tasmee.startRecording,
          svgColor: Get.theme.primaryColorLight,
          isCustomSvgColor: true,
        );
    }
  }

  Widget _processingIndicator() => const SizedBox(
    width: 38,
    height: 38,
    child: Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );

  /// زر الفعل في نمط المعلم حسب طور الجلسة — بدء الحلقة، إيقافها أثناء
  /// تلاوة القارئ، إيقاف التسجيل، أو مؤشر انتظار أثناء التقييم.
  Widget _buildTeacherAction() {
    final sessionCtrl = _sessionCtrl;
    final phase = tasmee.state.teacherPhase.value;
    switch (phase) {
      case TasmeeTeacherPhase.qariPlaying:
        return CustomButton(
          isCustomSvgColor: true,
          svgPath: SvgPath.svgAudioPlayArrow,
          tooltip: 'tasmeeTeacherQariPlaying'.tr,
          svgColor: Get.theme.primaryColorLight,
          onPressed: sessionCtrl.stopTeacherSession,
        );
      case TasmeeTeacherPhase.evaluating:
        return _processingIndicator();
      case TasmeeTeacherPhase.userRecording:
        final s = tasmee.state.sessionState.value;
        if (s == RecitationState.processing) return _processingIndicator();
        return CustomButton(
          isCustomSvgColor: true,
          svgPath: SvgPath.svgQuranStop,
          tooltip: 'tasmeeStopRecording'.tr,
          onPressed: sessionCtrl.stopTeacherSession,
          svgColor: Get.theme.colorScheme.surface,
        );
      default:
        return CustomButton(
          svgPath: SvgPath.svgQuranMicrophone,
          tooltip: 'tasmeeStartRecording'.tr,
          onPressed: sessionCtrl.startTeacherSession,
          svgColor: Get.theme.primaryColorLight,
          isCustomSvgColor: true,
        );
    }
  }

  /// نص حالة المعلم: الطور الحالي وتقدم الآيات (آية ٣/٧).
  Widget _buildTeacherStatus() {
    final state = tasmee.state;
    final statusStyle = AppTextStyles.titleSmall(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Get.theme.colorScheme.inversePrimary,
    );
    if (state.isPreparingEngine.value) {
      return _statusText('tasmeePreparingEngine'.tr, statusStyle);
    }
    final phase = state.teacherPhase.value;
    if (phase == TasmeeTeacherPhase.pageDone) {
      return _statusText('tasmeeTeacherPageDone'.tr, statusStyle);
    }
    if (phase == TasmeeTeacherPhase.idle) {
      if (state.lastError.value.isNotEmpty) {
        return Text(
          state.lastError.value,
          style: statusStyle.copyWith(color: Get.theme.colorScheme.surface),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      }
      return _statusText('tasmeeStartRecording'.tr, statusStyle);
    }
    final label = switch (phase) {
      TasmeeTeacherPhase.qariPlaying => 'tasmeeTeacherQariPlaying'.tr,
      TasmeeTeacherPhase.userRecording => 'tasmeeTeacherYourTurn'.tr,
      _ => 'tasmeeProcessing'.tr,
    };
    final idx = (state.teacherAyahIndex.value + 1)
        .toString()
        .convertNumbersToCurrentLang();
    final total = state.teacherAyahTotal.value
        .toString()
        .convertNumbersToCurrentLang();
    return Row(
      children: [
        if (phase == TasmeeTeacherPhase.userRecording)
          const _PulsingTasmeeDot()
        else
          const Gap(2),
        const Gap(8),
        Expanded(
          child: Text(
            '$label ($idx/$total)',
            style: statusStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// نص الحالة حسب حالة الجلسة والمحرك.
  Widget _buildStatus() {
    final state = tasmee.state;
    final statusStyle = AppTextStyles.titleSmall(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Get.theme.colorScheme.inversePrimary,
    );
    switch (state.sessionState.value) {
      case RecitationState.recording:
        final done = state.completedWords.value.toString();
        final total = state.totalWords.value.toString();
        return Row(
          children: [
            const _PulsingTasmeeDot(),
            const Gap(8),
            Expanded(
              child: Text(
                '${'tasmeeRecording'.tr} '
                '(${done.convertNumbersToCurrentLang()}/'
                '${total.convertNumbersToCurrentLang()})',
                style: statusStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      case RecitationState.connecting:
        return _statusText('tasmeeConnecting'.tr, statusStyle);
      case RecitationState.processing:
        return _statusText('tasmeeProcessing'.tr, statusStyle);
      case RecitationState.error:
        return Text(
          state.lastError.value.isEmpty
              ? 'tasmeeNoMatch'.tr
              : state.lastError.value,
          style: statusStyle.copyWith(color: Get.theme.colorScheme.surface),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      default:
        if (state.isPreparingEngine.value) {
          return _statusText(
            state.isDownloadingModel.value
                ? '${'tasmeeDownloadingModel'.tr} '
                      '${(state.modelDownloadProgress.value * 100).toInt().toString().convertNumbersToCurrentLang()}%'
                : 'tasmeePreparingEngine'.tr,
            statusStyle,
          );
        }
        if (state.lastError.value.isNotEmpty &&
            state.lastResult.value == null) {
          return Text(
            state.lastError.value,
            style: statusStyle.copyWith(color: Get.theme.colorScheme.surface),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          );
        }
        return _statusText('tasmeeStartRecording'.tr, statusStyle);
    }
  }

  Widget _statusText(String text, TextStyle style) =>
      Text(text, style: style, overflow: TextOverflow.ellipsis);
}

/// نقطة نابضة تشير إلى أن التسجيل جارٍ.
class _PulsingTasmeeDot extends StatefulWidget {
  const _PulsingTasmeeDot();

  @override
  State<_PulsingTasmeeDot> createState() => _PulsingTasmeeDotState();
}

class _PulsingTasmeeDotState extends State<_PulsingTasmeeDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: .3, end: 1).animate(_controller),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io' show File, Platform;

import 'package:connectivity_kit/connectivity_kit.dart';
import 'package:dio/dio.dart' as dio show FormData, MultipartFile;
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/services/error_handling_system.dart';
import '../../../../core/services/notifications_helper.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../data/feedback_media_staging.dart';
import '../data/feedback_queue.dart';
import '../data/models/feedback_model.dart';
import '../data/models/feedback_reply_model.dart';
import '../data/models/feedback_thread.dart';

/// إدارة ميزة الـ Feedback بالكامل.
///
/// يحفظ **قائمة tokens** محلياً (كل ملاحظة لها token مستقل خاص بها)،
/// يحمّل كل المحادثات للعرض كقائمة، ويدير المحادثة المفتوحة حالياً.
/// كل اللوجيك هنا — الشاشات مجرد واجهة تستهلك الـ Rx state.
class FeedbackController extends GetxController {
  static FeedbackController get instance =>
      GetInstance().putOrFind(() => FeedbackController());

  final _box = GetStorage();

  /// مفتاح حفظ قائمة الـ tokens في GetStorage.
  static const _tokensKey = 'feedback_tokens';

  /// آخر id رد رآه المستخدم (للكشف عن الردود الجديدة).
  static const _lastReplyKey = 'feedback_last_reply_id';

  /// اسم التطبيق الثابت المُرسل للـ backend.
  static const String appSource = 'Al Quran Al Kareem';

  // ---------- State ----------
  /// قائمة كل المحادثات (لعرضها كقائمة بطاقات).
  final threads = <FeedbackThread>[].obs;

  /// حالة تحميل القائمة.
  final isLoadingList = false.obs;

  /// حالة الإرسال من الـ bottom sheet.
  final isSubmitting = false.obs;

  /// المحادثة المفتوحة حالياً (في شاشة conversation).
  final openThread = Rxn<FeedbackThread>();

  /// حالة تحميل المحادثة المفتوحة.
  final isLoadingThread = false.obs;

  /// حالة إرسال رد متابعة.
  final isReplying = false.obs;

  // ---------- state الوسائط ----------
  /// الملفات المختارة محلياً قبل الإرسال (في الـ bottom sheet).
  final selectedFiles = <File>[].obs;

  /// حالة رفع الوسائط لـ R2.
  final isUploading = false.obs;

  /// تقدّم الرفع الحالي (0.0 - 1.0).
  final uploadProgress = 0.0.obs;

  /// الحد الأقصى لعدد الملفات لكل رسالة.
  static const int maxFiles = 5;

  /// أنواع الصور المسموحة + حد حجمها (10MB).
  static const Set<String> _allowedImageExts = {
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
  };
  static const int _maxImageBytes = 10 * 1024 * 1024; // 10MB

  /// أنواع الفيديو المسموحة + حد حجمها (50MB).
  static const Set<String> _allowedVideoExts = {'mp4', 'webm', 'mov'};
  static const int _maxVideoBytes = 50 * 1024 * 1024; // 50MB

  // ---------- Lifecycle ----------
  /// علامة نتيجة "أُدخلت الطابور": token/id فارغ تتحقق منه الواجهات
  /// لعرض رسالة الانتظار بدل رسالة النجاح الفوري.
  static const FeedbackModel _queuedModel = FeedbackModel(
    id: '',
    token: '',
    message: '',
    status: 'queued',
    published: false,
    createdAt: '',
    updatedAt: '',
  );
  static const FeedbackReplyModel _queuedReply = FeedbackReplyModel(
    id: '',
    feedbackId: '',
    authorRole: 'user',
    body: '',
    createdAt: '',
  );

  /// اشتراك أحداث الطابور لتحديث القائمة عند وصول إرسال مؤجَّل.
  StreamSubscription<QueueEvent>? _queueSubscription;

  @override
  void onInit() {
    super.onInit();
    // حمّل tokens مبكراً لمعرفة هل توجد ملاحظات سابقة.
    _loadTokens();
    // تحميل هادئ للقائمة + فحص الردود الجديدة عند بدء التطبيق.
    loadAllThreads();
    checkForNewReplies();
    _listenToQueue();
  }

  @override
  void onClose() {
    _queueSubscription?.cancel();
    super.onClose();
  }

  /// عند نجاح إرسال مؤجَّل في الخلفية: حدّث القائمة والمحادثة المفتوحة.
  void _listenToQueue() {
    if (!Get.isRegistered<TaskQueueService>()) return;
    _queueSubscription = Get.find<TaskQueueService>().events.listen((event) {
      if (event is! QueueTaskSucceeded) return;
      final type = event.task.type;
      if (type != FeedbackQueue.submitType && type != FeedbackQueue.replyType) {
        return;
      }
      loadAllThreads();
      final token = event.task.payload['token']?.toString();
      final open = openThread.value?.feedback.token;
      if (token != null && token.isNotEmpty && token == open) {
        openConversation(token);
      }
    });
  }

  /// يضمن تحميل القائمة عند فتح [FeedbackThreadScreen] (ولو بعد hot restart).
  ///
  /// يُستدعى من بناء الشاشة عبر [WidgetsBinding.addPostFrameCallback].
  /// لا يعيد التحميل إن كان جارياً already.
  Future<void> ensureLoaded() async {
    if (isLoadingList.value) return;
    await loadAllThreads();
  }

  // ---------- Tokens ----------
  /// قائمة الـ tokens المحفوظة (RxLite داخلي للتفاعل).
  final _tokens = <String>[].obs;
  List<String> get tokens => _tokens.toList();
  bool get hasFeedback => _tokens.isNotEmpty;

  void _loadTokens() {
    final raw = _box.read<List<dynamic>>(_tokensKey) ?? [];
    _tokens.value = raw.map((e) => e.toString()).toList();
  }

  void _saveTokens() {
    _box.write(_tokensKey, _tokens.toList());
  }

  /// يضيف token جديد (بدون تكرار) ويحفظ القائمة.
  void _addToken(String token) {
    if (token.isEmpty) return;
    if (!_tokens.contains(token)) {
      _tokens.insert(0, token); // الأحدث أولاً
      _saveTokens();
    }
  }

  // ---------- قائمة الملاحظات ----------

  /// يحمّل كل المحادثات للـ tokens المحفوظة لعرضها كقائمة بطاقات.
  ///
  /// يستدعى عند فتح [FeedbackThreadScreen] تلقائياً.
  Future<void> loadAllThreads() async {
    _loadTokens();
    if (_tokens.isEmpty) {
      threads.clear();
      return;
    }
    isLoadingList.value = true;
    try {
      final loaded = <FeedbackThread>[];
      // حمّل كل محادثة على حدة (التوازي مسموح لأن الـ endpoints مستقلة).
      final results = await Future.wait(_tokens.map((t) => _fetchThread(t)));
      for (final r in results) {
        r.fold((_) => null, (thread) => loaded.add(thread));
      }
      // رتّب: الأحدث أولاً حسب created_at للرسالة الأصلية.
      loaded.sort(
        (a, b) => b.feedback.createdAt.compareTo(a.feedback.createdAt),
      );
      threads.value = loaded;
    } finally {
      isLoadingList.value = false;
    }
  }

  /// جلب محادثة واحدة بالـ token (داخلي).
  Future<Either<Failure, FeedbackThread>> _fetchThread(String token) async {
    try {
      final endpoint =
          '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}/$token';
      final result = await ApiClient().request(
        endpoint: endpoint,
        method: HttpMethod.get,
        printResponse: false,
      );
      return result.fold((f) => Left(f), (data) {
        final map = _asMap(data);
        if (map == null) return Left(DataSource.DEFAULT.getFailure());
        return Right(FeedbackThread.fromJson(map));
      });
    } catch (e) {
      log('_fetchThread error: $e', name: 'FeedbackController');
      return Left(DataSource.DEFAULT.getFailure());
    }
  }

  // ---------- الإرسال ----------

  /// إرسال ملاحظة جديدة من الـ bottom sheet. يحفظ الـ token ويُحدّث القائمة.
  ///
  /// يُرجع الـ model عند النجاح (لإغلاق الـ bottom sheet والانتقال).
  Future<Either<Failure, FeedbackModel>> submitFeedback(
    String msg, {
    String? email,
    BuildContext? context,
  }) async {
    final trimmed = msg.trim();
    if (trimmed.isEmpty || trimmed.length > 8000) {
      return Left(Failure(400, 'feedback_message_hint'));
    }

    isSubmitting.value = true;
    try {
      // دون اتصال: أدخل الطابور مباشرة بدل الفشل (الوسائط تُرحَّل
      // إلى مجلد دائم لتُرفع لاحقًا).
      if (!_isOnline) {
        return await _enqueueSubmit(
          trimmed: trimmed,
          email: email,
          context: context,
        );
      }

      // ارفع الوسائط المختارة أولاً (إن وُجدت) واحصل على روابط R2.
      final mediaUrls = await _uploadAllFiles();
      if (mediaUrls == null) {
        // فشل الرفع (اتصال متذبذب غالبًا) — أسقط للطابور بدل إظهار خطأ.
        return await _enqueueSubmit(
          trimmed: trimmed,
          email: email,
          context: context,
        );
      }

      final body = <String, dynamic>{
        'message': trimmed,
        'app_source': appSource,
      };
      if (email != null && email.trim().isNotEmpty) {
        body['contact_email'] = email.trim();
      }
      body['user_meta'] = _collectUserMeta(context);
      if (mediaUrls.isNotEmpty) {
        body['media_urls'] = mediaUrls;
      }

      final endpoint =
          '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}';

      final result = await ApiClient().request(
        endpoint: endpoint,
        method: HttpMethod.post,
        data: body,
        printResponse: false,
      );

      // فشل شبكي/خادم → الطابور (الروابط رُفعت بالفعل فتُعاد كما هي)؛
      // أما 4xx فهي أخطاء حقيقية تُعرض للمستخدم ولا تستحق إعادة محاولة.
      final failure = result.fold<Failure?>((f) => f, (_) => null);
      if (failure != null) {
        if (_isQueueableFailure(failure)) {
          return await _enqueueSubmit(
            trimmed: trimmed,
            email: email,
            context: context,
            mediaUrls: mediaUrls,
          );
        }
        return Left(failure);
      }

      final map = _asMap(result.right);
      if (map == null) return Left(DataSource.DEFAULT.getFailure());
      final token = map['token']?.toString();
      final dataField = map['data'];
      final feedbackMap = dataField is Map
          ? Map<String, dynamic>.from(dataField)
          : null;
      if (feedbackMap == null) return Left(DataSource.DEFAULT.getFailure());
      final model = FeedbackModel.fromJson(feedbackMap);
      final finalToken = (token != null && token.isNotEmpty)
          ? token
          : model.token;
      if (finalToken.isNotEmpty) {
        _addToken(finalToken);
      }
      clearFiles(); // افرغ القائمة بعد النجاح
      return Right(model);
    } catch (e) {
      log('submitFeedback error: $e', name: 'FeedbackController');
      return Left(DataSource.DEFAULT.getFailure());
    } finally {
      isSubmitting.value = false;
    }
  }

  // ---------- الطابور دون اتصال ----------

  /// هل يوجد اتصال الآن؟ (بحسب خدمة المراقبة المسجَّلة في main).
  bool get _isOnline =>
      Get.isRegistered<ConnectionService>() &&
      Get.find<ConnectionService>().currentStatus.isOnline;

  /// هل الفشل شبكي/خادم يستحق الدخول في الطابور؟
  /// في نظام أخطاء هذا التطبيق الأكواد السالبة/الصفرية أخطاء عميل
  /// شبكية، و5xx أخطاء خادم عابرة — أما 4xx فلا تنجح بإعادة المحاولة.
  bool _isQueueableFailure(Failure failure) =>
      failure.code <= 0 || failure.code >= 500;

  /// يضيف ملاحظة جديدة إلى الطابور ويعيد علامة queued.
  ///
  /// [mediaUrls] لروابط رُفعت بالفعل (فشل POST بعد نجاح الرفع)، وإلا
  /// تُرحَّل الملفات المختارة إلى مجلد دائم ليرفعها المعالج لاحقًا.
  Future<Either<Failure, FeedbackModel>> _enqueueSubmit({
    required String trimmed,
    String? email,
    BuildContext? context,
    List<String> mediaUrls = const [],
  }) async {
    final staged = selectedFiles.isNotEmpty && mediaUrls.isEmpty
        ? await FeedbackMediaStaging.stage(selectedFiles)
        : const <String>[];
    await Get.find<TaskQueueService>().enqueue(
      type: FeedbackQueue.submitType,
      payload: <String, dynamic>{
        'message': trimmed,
        'app_source': appSource,
        'user_meta': _collectUserMeta(context),
        if (email != null && email.trim().isNotEmpty)
          'contact_email': email.trim(),
        if (mediaUrls.isNotEmpty) 'media_urls': mediaUrls,
        if (staged.isNotEmpty) FeedbackMediaStaging.payloadKey: staged,
      },
    );
    clearFiles();
    return const Right(_queuedModel);
  }

  /// يضيف رد متابعة إلى الطابور ويعيد علامة queued.
  Future<Either<Failure, FeedbackReplyModel>> _enqueueReply({
    required String token,
    required String body,
    List<String> mediaUrls = const [],
  }) async {
    if (body.isEmpty && selectedFiles.isEmpty && mediaUrls.isEmpty) {
      return Left(Failure(400, 'feedback_reply_hint'));
    }
    final staged = selectedFiles.isNotEmpty && mediaUrls.isEmpty
        ? await FeedbackMediaStaging.stage(selectedFiles)
        : const <String>[];
    await Get.find<TaskQueueService>().enqueue(
      type: FeedbackQueue.replyType,
      payload: <String, dynamic>{
        'token': token,
        'body': body,
        if (mediaUrls.isNotEmpty) 'media_urls': mediaUrls,
        if (staged.isNotEmpty) FeedbackMediaStaging.payloadKey: staged,
      },
    );
    clearFiles();
    return const Right(_queuedReply);
  }

  // ---------- المحادثة المفتوحة ----------

  /// فتح محادثة للعرض في شاشة [FeedbackConversationScreen].
  ///
  /// يعتمد على token المحادثة المطلوبة.
  Future<void> openConversation(String token) async {
    isLoadingThread.value = true;
    openThread.value = null;
    try {
      final result = await _fetchThread(token);
      result.fold((_) => null, (t) {
        openThread.value = t;
        // حدّث آخر رد مُشاهد لهذه المحادثة.
        _markThreadSeen(t);
      });
    } finally {
      isLoadingThread.value = false;
    }
  }

  /// إرسال رد متابعة في المحادثة المفتوحة. يضيفه محلياً ويُحدّث القائمة.
  ///
  /// يقبل وسائط فقط (دون نص) — النص مطلوب فقط إن لم تكن هناك وسائط مختارة.
  Future<Either<Failure, FeedbackReplyModel>> sendReply(String body) async {
    final token = openThread.value?.feedback.token;
    if (token == null || token.isEmpty) {
      return Left(Failure(404, 'no_feedback_yet'));
    }
    final trimmed = body.trim();

    isReplying.value = true;
    try {
      // دون اتصال: رد نصي/بوسائط مرحَّلة يدخل الطابور بدل الفشل.
      if (!_isOnline) {
        return await _enqueueReply(token: token, body: trimmed);
      }

      // ارفع الوسائط المختارة أولاً (إن وُجدت).
      final mediaUrls = await _uploadAllFiles();
      if (mediaUrls == null) {
        // اتصال متذبذب — أسقط للطابور بدل إظهار خطأ.
        return await _enqueueReply(token: token, body: trimmed);
      }
      // النص مطلوب فقط إن لم تكن هناك وسائط.
      if (trimmed.isEmpty && mediaUrls.isEmpty) {
        return Left(Failure(400, 'feedback_reply_hint'));
      }

      final endpoint =
          '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}/$token${ApiConstants.feedbackReplySuffix}';
      final payload = <String, dynamic>{'body': trimmed};
      if (mediaUrls.isNotEmpty) {
        payload['media_urls'] = mediaUrls;
      }
      final result = await ApiClient().request(
        endpoint: endpoint,
        method: HttpMethod.post,
        data: payload,
        printResponse: false,
      );

      final failure = result.fold<Failure?>((f) => f, (_) => null);
      if (failure != null) {
        if (_isQueueableFailure(failure)) {
          return await _enqueueReply(
            token: token,
            body: trimmed,
            mediaUrls: mediaUrls,
          );
        }
        return Left(failure);
      }

      final map = _asMap(result.right);
      final replyMap = map == null
          ? null
          : (map['data'] is Map
                ? Map<String, dynamic>.from(map['data'])
                : null);
      if (replyMap == null) return Left(DataSource.DEFAULT.getFailure());
      final reply = FeedbackReplyModel.fromJson(replyMap);
      // أضف الرد محلياً للمحادثة المفتوحة + للقائمة.
      final current = openThread.value;
      if (current != null) {
        final updated = current.copyWith(replies: [...current.replies, reply]);
        openThread.value = updated;
        _upsertThreadInList(updated);
      }
      return Right(reply);
    } catch (e) {
      log('sendReply error: $e', name: 'FeedbackController');
      return Left(DataSource.DEFAULT.getFailure());
    } finally {
      isReplying.value = false;
    }
  }

  /// يحدّث/يضيف محادثة في قائمة [threads] (بعد رد جديد مثلاً).
  void _upsertThreadInList(FeedbackThread updated) {
    final idx = threads.indexWhere(
      (t) => t.feedback.token == updated.feedback.token,
    );
    if (idx >= 0) {
      final list = threads.toList();
      list[idx] = updated;
      threads.value = list;
    } else {
      threads.insert(0, updated);
    }
  }

  // ---------- اختيار ورفع الوسائط ----------

  /// يفتح المعرض لاختيار صور متعددة. يتحقق من النوع والحجم والحد الأقصى.
  Future<String?> pickImages() async {
    final remaining = maxFiles - selectedFiles.length;
    if (remaining <= 0) return 'feedback_max_files';

    final picker = ImagePicker();
    try {
      final results = await picker.pickMultiImage(
        limit: remaining,
        imageQuality: 85,
      );
      if (results.isEmpty) return null; // ألغى المستخدم

      for (final x in results) {
        if (selectedFiles.length >= maxFiles) break;
        final file = File(x.path);
        final ext = _extension(x.path);
        final size = await file.length();

        if (!_allowedImageExts.contains(ext)) {
          return 'feedback_invalid_type';
        }
        if (size > _maxImageBytes) {
          return 'feedback_file_too_large';
        }
        selectedFiles.add(file);
      }
      return null; // نجاح
    } catch (e) {
      log('pickImages error: $e', name: 'FeedbackController');
      return 'feedback_invalid_type';
    }
  }

  /// يفتح المعرض لاختيار فيديو واحد. يتحقق من النوع والحجم.
  Future<String?> pickVideo() async {
    if (selectedFiles.length >= maxFiles) return 'feedback_max_files';

    final picker = ImagePicker();
    try {
      final x = await picker.pickVideo(source: ImageSource.gallery);
      if (x == null) return null; // ألغى المستخدم

      final file = File(x.path);
      final ext = _extension(x.path);
      final size = await file.length();

      if (!_allowedVideoExts.contains(ext)) {
        return 'feedback_invalid_type';
      }
      if (size > _maxVideoBytes) {
        return 'feedback_file_too_large';
      }
      selectedFiles.add(file);
      return null; // نجاح
    } catch (e) {
      log('pickVideo error: $e', name: 'FeedbackController');
      return 'feedback_invalid_type';
    }
  }

  /// يزيل ملفاً من القائمة المختارة بالـ index.
  void removeFileAt(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  /// يفرّغ قائمة الملفات المختارة (بعد الإرسال أو الإلغاء).
  void clearFiles() {
    selectedFiles.clear();
    uploadProgress.value = 0.0;
  }

  /// هل الملف فيديو؟ (حسب الامتداد).
  bool isVideoFile(File file) {
    return _allowedVideoExts.contains(_extension(file.path));
  }

  /// يرفع كل الملفات المختارة لـ R2 عبر [ApiClient.uploadFile].
  ///
  /// يُرجع قائمة الروابط عند النجاح، أو `null` عند الفشل.
  /// يحدّث [uploadProgress] و [isUploading].
  Future<List<String>?> _uploadAllFiles() async {
    if (selectedFiles.isEmpty) return const [];

    isUploading.value = true;
    uploadProgress.value = 0.0;
    final urls = <String>[];
    final endpoint =
        '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackUploadEndpoint}';

    try {
      for (var i = 0; i < selectedFiles.length; i++) {
        final file = selectedFiles[i];
        final fileName = file.path.split('/').last;
        final formField = await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
        final formData = dio.FormData.fromMap({'file': formField});

        final result = await ApiClient().uploadFile(
          endpoint: endpoint,
          data: formData,
          onSendProgress: (sent, total) {
            if (total > 0) {
              // نسبة الملف الحالي ضمن كل الملفات.
              final fileFraction = (i + (sent / total)) / selectedFiles.length;
              uploadProgress.value = fileFraction.clamp(0.0, 1.0);
            }
          },
          printResponse: false,
        );

        if (result.isLeft) {
          log(
            'upload failed: ${result.left.message}',
            name: 'FeedbackController',
          );
          uploadProgress.value = 0.0;
          return null;
        }
        final data = result.right;
        final url = data is Map ? data['url']?.toString() : null;
        if (url == null || url.isEmpty) {
          uploadProgress.value = 0.0;
          return null;
        }
        urls.add(url);
      }
      uploadProgress.value = 1.0;
      return urls;
    } catch (e) {
      log('_uploadAllFiles error: $e', name: 'FeedbackController');
      uploadProgress.value = 0.0;
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  /// استخراج الامتداد من مسار الملف (بدون نقطة، بأحرف صغيرة).
  String _extension(String path) {
    final dot = path.lastIndexOf('.');
    if (dot < 0 || dot == path.length - 1) return '';
    return path.substring(dot + 1).toLowerCase();
  }

  // ---------- الإشعارات عند وصول رد جديد ----------

  /// يفحص كل المحادثات للكشف عن ردود أدمن جديدة ويطلق إشعاراً فورياً لكل رد.
  ///
  /// نسخة instance — تُستدعى من الـ UI lifecycle و [FeedbackThreadScreen].
  /// للخلفية استخدم [checkForNewRepliesStatic] لتجنب بناء controller كامل.
  Future<void> checkForNewReplies() async {
    await checkForNewRepliesStatic(box: _box);
  }

  /// نسخة ثابتة مستقلة للاستدعاء من الخلفية ([BGServices]).
  ///
  /// لا تعتمد على Rx state ولا GetX translations ولا تحتاج لإنشاء controller.
  /// تقرأ الـ tokens مباشرة من GetStorage (المُهيّأ في أي isolate).
  /// آمنة تماماً — كل خطأ يُلتقط بصمت.
  @pragma('vm:entry-point')
  static Future<void> checkForNewRepliesStatic({GetStorage? box}) async {
    final storage = box ?? GetStorage();
    try {
      final raw = storage.read<List<dynamic>>(_tokensKey) ?? [];
      final tokens = raw.map((e) => e.toString()).toList();
      if (tokens.isEmpty) return;

      final lastSeen = storage.read<int>(_lastReplyKey) ?? 0;
      int newMax = lastSeen;
      for (final token in tokens) {
        final result = await _fetchThreadStatic(token);
        if (result.isLeft) continue;
        final thread = result.right;
        final adminReplies = thread.replies.where((r) => r.isAdmin);
        for (final reply in adminReplies) {
          final idInt = _replyIdAsIntStatic(reply.id);
          if (idInt > lastSeen) {
            await NotifyHelper().showNotification(
              id: reply.id.hashCode,
              title: _trStatic('feedback_reply_title', fallback: 'Admin Reply'),
              summary: _trStatic('feedback', fallback: 'Feedback'),
              body: reply.body,
              payload: {
                'type': 'feedback_reply',
                'feedback_token': token,
                'reply_id': reply.id,
              },
            );
            if (idInt > newMax) newMax = idInt;
          }
        }
      }
      if (newMax > lastSeen) {
        storage.write(_lastReplyKey, newMax);
      }
    } catch (e) {
      log('checkForNewRepliesStatic error: $e', name: 'FeedbackController');
    }
  }

  /// جلب محادثة واحدة (نسخة ثابتة للخلفية).
  static Future<Either<Failure, FeedbackThread>> _fetchThreadStatic(
    String token,
  ) async {
    try {
      final endpoint =
          '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}/$token';
      final result = await ApiClient().request(
        endpoint: endpoint,
        method: HttpMethod.get,
        printResponse: false,
      );
      return result.fold((f) => Left(f), (data) {
        Map<String, dynamic>? map;
        if (data is Map<String, dynamic>) {
          map = data;
        } else if (data is Map) {
          map = Map<String, dynamic>.from(data);
        } else if (data is String) {
          final trimmed = data.trim();
          if (trimmed.isNotEmpty) {
            try {
              final decoded = jsonDecode(trimmed);
              if (decoded is Map) {
                map = Map<String, dynamic>.from(decoded);
              }
            } catch (_) {}
          }
        }
        if (map == null) return Left(DataSource.DEFAULT.getFailure());
        return Right(FeedbackThread.fromJson(map));
      });
    } catch (e) {
      log('_fetchThreadStatic error: $e', name: 'FeedbackController');
      return Left(DataSource.DEFAULT.getFailure());
    }
  }

  /// ترجمة آمنة للخلفية: ترجع القيمة المُترجمة إن وُجدت، وإلا fallback.
  static String _trStatic(String key, {required String fallback}) {
    try {
      final translated = key.tr;
      return translated == key ? fallback : translated;
    } catch (_) {
      return fallback;
    }
  }

  static int _replyIdAsIntStatic(String id) => int.tryParse(id) ?? id.hashCode;

  void _markThreadSeen(FeedbackThread t) {
    if (t.replies.isEmpty) return;
    final lastSeen = _box.read<int>(_lastReplyKey) ?? 0;
    final maxInThread = t.replies
        .map((r) => _replyIdAsInt(r.id))
        .fold(lastSeen, (a, b) => a > b ? a : b);
    if (maxInThread > lastSeen) {
      _box.write(_lastReplyKey, maxInThread);
    }
  }

  // ---------- Helpers ----------

  /// يجمع معلومات الجهاز تلقائياً (بدون سؤال المستخدم).
  Map<String, dynamic> _collectUserMeta(BuildContext? context) {
    String appVersion = '';
    String osName = '';
    String osVersion = '';
    if (context != null) {
      try {
        final info = AppInfo.of(context);
        appVersion = '${info.package.versionWithoutBuild}';
        osName = info.platform.operatingSystem;
        osVersion = info.platform.operatingSystemVersion;
      } catch (_) {}
    }
    if (appVersion.isEmpty) appVersion = 'unknown';
    if (osName.isEmpty) osName = Platform.operatingSystem;
    if (osVersion.isEmpty) osVersion = Platform.operatingSystemVersion;

    return {
      'platform': Platform.isIOS ? 'ios' : 'android',
      'app_version': appVersion,
      'device_model': '',
      'os_version': osVersion,
      'language': Get.locale?.languageCode ?? 'ar',
      'os_name': osName,
    };
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }

  int _replyIdAsInt(String id) => int.tryParse(id) ?? id.hashCode;
}

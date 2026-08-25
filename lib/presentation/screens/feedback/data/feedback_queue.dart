import 'dart:convert';
import 'dart:io' show File;

import 'package:connectivity_kit/connectivity_kit.dart';
import 'package:dio/dio.dart' as dio show FormData, MultipartFile;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/utils/constants/api_constants.dart';
import 'feedback_media_staging.dart';

/// طابور الـ feedback: تهيئة [TaskQueueService] ومعالجات إرسال صافية
/// (بلا Rx ولا BuildContext) لأنها تعمل في الخلفية وربما بعد إعادة
/// تشغيل التطبيق.
///
/// تُستدعى [init] من main بعد تهيئة ConnectionService وقبل runApp.
class FeedbackQueue {
  FeedbackQueue._();

  /// نوع مهمة إرسال ملاحظة جديدة.
  static const String submitType = 'feedback_submit';

  /// نوع مهمة رد متابعة على محادثة قائمة.
  static const String replyType = 'feedback_reply';

  /// نفس مفتاح المتحكم لحفظ tokens المحادثات في GetStorage.
  static const String _tokensKey = 'feedback_tokens';

  /// ينشئ الطابور، يسجّل المعالجات، يخزّنه في GetX دائمًا، وينظّف ملفات
  /// المراحل اليتيمة من إقلاع سابق.
  static Future<void> init(ConnectionService service) async {
    final queue = TaskQueueService(
      connectionService: service,
      options: const TaskQueueOptions(
        // ملاحظات المستخدم تستحق محاولات أكثر، ورفع الوسائط الكبيرة
        // يحتاج مهلة أطول من الافتراضي (30 ثانية).
        maxAttempts: 5,
        taskTimeout: Duration(minutes: 5),
      ),
    );
    queue.registerHandler(submitType, _submitHandler);
    queue.registerHandler(replyType, _replyHandler);
    await queue.init();
    Get.put(queue, permanent: true);

    await FeedbackMediaStaging.sweepOrphans(queue);

    // لا توجد واجهة لإدارة الفاشل نهائيًا في هذه الميزة → نظّف ملفاتها
    // فور الفشل النهائي (المهمة نفسها تبقى في الطابور للتشخيص).
    queue.events.listen((event) {
      if (event is! QueueTaskFailedPermanently) return;
      final raw = event.task.payload[FeedbackMediaStaging.payloadKey];
      if (raw is List) {
        FeedbackMediaStaging.cleanup(raw.map((e) => e.toString()).toList());
      }
    });
  }

  // ---------- المعالجات ----------

  /// إرسال ملاحظة جديدة: يرفع الوسائط المرحّلة (إن وُجدت) ثم POST ثم
  /// يحفظ الـ token. أي فشل يُرمى ليُعاد جدولته وفق سياسة الطابور.
  static Future<void> _submitHandler(Map<String, dynamic> payload) async {
    final staged = _stagedPathsOf(payload);
    final body = Map<String, dynamic>.of(payload)
      ..remove(FeedbackMediaStaging.payloadKey);

    final urls = await _uploadStaged(staged);
    final existing = body['media_urls'];
    final mediaUrls = <String>[
      if (existing is List) ...existing.map((e) => e.toString()),
      ...urls,
    ];
    if (mediaUrls.isNotEmpty) body['media_urls'] = mediaUrls;

    final endpoint =
        '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}';
    final result = await ApiClient().request(
      endpoint: endpoint,
      method: HttpMethod.post,
      data: body,
      printResponse: false,
    );
    if (result.isLeft) throw Exception(result.left.message);

    _saveTokenFromResponse(result.right);
    await FeedbackMediaStaging.cleanup(staged);
  }

  /// إرسال رد متابعة على محادثة قائمة (الـ token داخل الـ payload).
  static Future<void> _replyHandler(Map<String, dynamic> payload) async {
    final token = payload['token']?.toString() ?? '';
    if (token.isEmpty) throw Exception('feedback reply missing token');

    final staged = _stagedPathsOf(payload);
    final urls = await _uploadStaged(staged);
    final body = <String, dynamic>{'body': payload['body']?.toString() ?? ''};
    if (urls.isNotEmpty) body['media_urls'] = urls;

    final endpoint =
        '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackEndpoint}/$token${ApiConstants.feedbackReplySuffix}';
    final result = await ApiClient().request(
      endpoint: endpoint,
      method: HttpMethod.post,
      data: body,
      printResponse: false,
    );
    if (result.isLeft) throw Exception(result.left.message);

    await FeedbackMediaStaging.cleanup(staged);
  }

  /// يرفع الملفات المرحلية لـ R2 ويعيد روابطها؛ الرمي = فشل محاولة.
  static Future<List<String>> _uploadStaged(List<String> paths) async {
    if (paths.isEmpty) return const [];
    final endpoint =
        '${ApiConstants.feedbackApiUrl}${ApiConstants.feedbackUploadEndpoint}';
    final urls = <String>[];
    for (final path in paths) {
      if (!await File(path).exists()) {
        throw Exception('staged media file missing: $path');
      }
      final formField = await dio.MultipartFile.fromFile(
        path,
        filename: path.split('/').last,
      );
      final result = await ApiClient().uploadFile(
        endpoint: endpoint,
        data: dio.FormData.fromMap({'file': formField}),
        printResponse: false,
      );
      if (result.isLeft) throw Exception(result.left.message);
      final data = result.right;
      final url = data is Map ? data['url']?.toString() : null;
      if (url == null || url.isEmpty) {
        throw Exception('upload response missing url');
      }
      urls.add(url);
    }
    return urls;
  }

  /// مسارات الوسائط المرحلية من الـ payload دون تعديله (يظل صالحًا
  /// لإعادة المحاولة).
  static List<String> _stagedPathsOf(Map<String, dynamic> payload) {
    final raw = payload[FeedbackMediaStaging.payloadKey];
    return raw is List ? raw.map((e) => e.toString()).toList() : const [];
  }

  /// يكتب token المحادثة الجديدة في GetStorage (نفس منطق المتحكم) ليعرفها
  /// التطبيق بعد إقلاعٍ لاحق دون المرور بالواجهة.
  static void _saveTokenFromResponse(dynamic data) {
    Map<String, dynamic>? map;
    if (data is Map<String, dynamic>) {
      map = data;
    } else if (data is Map) {
      map = Map<String, dynamic>.from(data);
    } else if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) map = Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    if (map == null) return;

    var token = map['token']?.toString() ?? '';
    if (token.isEmpty) {
      final dataField = map['data'];
      if (dataField is Map) token = dataField['token']?.toString() ?? '';
    }
    if (token.isEmpty) return;

    final box = GetStorage();
    final raw = box.read<List<dynamic>>(_tokensKey) ?? [];
    final tokens = raw.map((e) => e.toString()).toList();
    if (!tokens.contains(token)) {
      box.write(_tokensKey, <String>[token, ...tokens]);
    }
  }
}

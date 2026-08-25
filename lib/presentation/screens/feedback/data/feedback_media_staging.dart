import 'dart:io';

import 'package:connectivity_kit/connectivity_kit.dart';
import 'package:path_provider/path_provider.dart';

/// إدارة ملفات الوسائط المرحلية للطابور.
///
/// ملفات `image_picker` في مجلد الكاش وقد يمسحها النظام في أي وقت،
/// والمهمة قد تبقى في الطابور أيامًا؛ لذا تُنقل إلى مجلد دائم يملكه
/// التطبيق قبل إضافة المهمة، وتُحذف بعد نجاح الإرسال.
class FeedbackMediaStaging {
  FeedbackMediaStaging._();

  static const String _rootName = 'feedback_queue_media';

  /// مفتاح حقل الـ payload الذي يحمل مسارات الملفات المرحلية.
  static const String payloadKey = 'media_paths';

  /// ينقل الملفات المختارة من الكاش إلى مجلد دائم خاص بها
  /// ويعيد المسارات الدائمة لتُخزَّن في الـ payload.
  static Future<List<String>> stage(List<File> files) async {
    if (files.isEmpty) return const [];
    final root = await _root();
    final dir = Directory(
      '${root.path}/${DateTime.now().microsecondsSinceEpoch}',
    );
    await dir.create(recursive: true);

    final staged = <String>[];
    for (final file in files) {
      if (!await file.exists()) continue;
      final target = '${dir.path}/${file.path.split('/').last}';
      try {
        staged.add((await file.rename(target)).path);
      } on FileSystemException {
        // rename قد يفشل بين أجزاء تخزين مختلفة → انسخ ثم احذف الأصل.
        await file.copy(target);
        await file.delete();
        staged.add(target);
      }
    }
    return staged;
  }

  /// يحذف ملفات مهمة انتهت (نجح إرسالها أو استُغني عنها) ومجلدها إن صار
  /// فارغًا. الفاشلة نهائيًا تُنظَّف عبر [sweepOrphans] أو هذا الاستدعاء.
  static Future<void> cleanup(List<String> paths) async {
    final dirs = <String>{};
    for (final path in paths) {
      final file = File(path);
      try {
        if (await file.exists()) await file.delete();
      } on FileSystemException {
        // تجاهل — كنس الإقلاع التالي يلتقط أي بقايا.
      }
      dirs.add(file.parent.path);
    }
    for (final path in dirs) {
      try {
        final dir = Directory(path);
        if (await dir.exists() && await dir.list().isEmpty) {
          await dir.delete();
        }
      } on FileSystemException {
        // تجاهل.
      }
    }
  }

  /// يمسح مجلدات لا تشير إليها أي مهمة قائمة (معلّقة أو فاشلة) —
  /// استدعِه عند إقلاع التطبيق لتغطية تسريبات الإغلاقات المفاجئة.
  static Future<void> sweepOrphans(TaskQueueService queue) async {
    final root = await _root();
    if (!await root.exists()) return;

    final referenced = <String>{};
    for (final task in [...queue.pendingTasks, ...queue.failedTasks]) {
      final raw = task.payload[payloadKey];
      if (raw is List) {
        referenced.addAll(raw.map((e) => e.toString()));
      }
    }

    await for (final entry in root.list()) {
      if (entry is! Directory) continue;
      final stillUsed = referenced.any((path) => path.startsWith(entry.path));
      if (!stillUsed) {
        try {
          await entry.delete(recursive: true);
        } on FileSystemException {
          // تجاهل — المحاولة القادمة.
        }
      }
    }
  }

  static Future<Directory> _root() async {
    final support = await getApplicationSupportDirectory();
    return Directory('${support.path}/$_rootName');
  }
}

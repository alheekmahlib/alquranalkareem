import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:url_launcher/url_launcher.dart';

extension ContactUsExtension on void {
  Future<void> contactUs({required BuildContext context}) async {
    final info = AppInfo.of(context);
    const String stringText =
        '| يرجى كتابة أي ملاحظة أو إستفسار دون حذف المعلومات التي في الأعلى، جزاكم الله خيرًا |';
    final String text = '''-----------------------------------\n'''
        '''تطبيق: ${info.package.appName}\n'''
        '''الإصدار: ${info.package.versionWithoutBuild}\n'''
        '''النظام: ${info.platform.operatingSystem}-${info.platform.version}\n'''
        '''-----------------------------------\n'''
        '''$stringText\n\n\n''';
    String uri =
        'mailto:haozo89@gmail.com?subject=${Uri.encodeComponent(info.package.appName)}&body=${Uri.encodeComponent(text)}';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      log('No email client found');
    }
  }
}

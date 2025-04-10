import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../data/models/ourApp_model.dart';

class OurAppsController extends GetxController {
  static OurAppsController get instance =>
      GetInstance().putOrFind(() => OurAppsController());

  Future<List<OurAppInfo>> fetchApps() async {
    try {
      final response = await ApiClient().request(
        endpoint: ApiConstants.ourAppsUrl,
        method: HttpMethod.get,
      );

      if (response.isRight) {
        // إذا كانت الاستجابة صحيحة، قم بتحليل البيانات
        // If the response is successful, parse the data
        List<dynamic> jsonData = jsonDecode(response.right as String);
        return jsonData.map((data) => OurAppInfo.fromJson(data)).toList();
      } else {
        // إذا كانت الاستجابة خاطئة، قم بتسجيل الخطأ
        // If the response is an error, log the error
        log('Failed to load data: ${response.left.message}',
            name: 'OurAppsController');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // تسجيل أي استثناء يحدث
      // Log any exception that occurs
      log('Error occurred: $e', name: 'OurAppsController');
      throw Exception('Failed to load data');
    }
  }

  launchURL(BuildContext context, int index, OurAppInfo ourAppInfo) async {
    if (!kIsWeb) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppStore))) {
          await launchUrl(Uri.parse(ourAppInfo.urlAppStore));
        } else {
          throw 'Could not launch ${ourAppInfo.urlAppStore}';
        }
      } else {
        if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppGallery))) {
          await launchUrl(Uri.parse(ourAppInfo.urlAppGallery));
        } else {
          throw 'Could not launch ${ourAppInfo.urlAppGallery}';
        }
        // }
      }
    } else {
      if (await canLaunchUrl(Uri.parse(ourAppInfo.urlMacAppStore))) {
        await launchUrl(Uri.parse(ourAppInfo.urlMacAppStore));
      } else {
        throw 'Could not launch ${ourAppInfo.urlMacAppStore}';
      }
    }
  }
}

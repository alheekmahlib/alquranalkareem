import 'dart:convert';

import 'package:alquranalkareem/core/utils/constants/string_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../data/models/ourApp_model.dart';

class OurAppsController extends GetxController {
  static OurAppsController get instance => Get.isRegistered<OurAppsController>()
      ? Get.find<OurAppsController>()
      : Get.put<OurAppsController>(OurAppsController());

  Future<List<OurAppInfo>> fetchApps() async {
    try {
      final response = await http.get(Uri.parse(StringConstants.ourAppsUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((data) => OurAppInfo.fromJson(data)).toList();
      } else {
        print('Failed to load data: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error occurred: $e');
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

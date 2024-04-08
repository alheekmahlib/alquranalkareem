import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../screens/ourApp/data/models/ourApp_model.dart';

class OurAppsController extends GetxController {
  Future<List<OurAppInfo>> fetchApps() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/alheekmahlib/thegarlanded/master/ourAppV2.json'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => OurAppInfo.fromJson(data)).toList();
    } else {
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
      } else if (Theme.of(context).platform == TargetPlatform.android) {
        GooglePlayServicesAvailability availability =
            await GoogleApiAvailability.instance
                .checkGooglePlayServicesAvailability(true);

        if (availability == GooglePlayServicesAvailability.success) {
          if (await canLaunchUrl(Uri.parse(ourAppInfo.urlPlayStore))) {
            await launchUrl(Uri.parse(ourAppInfo.urlPlayStore));
          } else {
            throw 'Could not launch ${ourAppInfo.urlPlayStore}';
          }
        } else {
          if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppGallery))) {
            await launchUrl(Uri.parse(ourAppInfo.urlAppGallery));
          } else {
            throw 'Could not launch ${ourAppInfo.urlAppGallery}';
          }
        }
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

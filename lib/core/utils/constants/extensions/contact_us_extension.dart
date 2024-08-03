import 'package:url_launcher/url_launcher.dart';

extension ContactUsExtension on void {
  Future<void> contactUs(
      {required String subject, required String stringText}) async {
    String uri =
        'mailto:haozo89@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      print("No email client found");
    }
  }
}

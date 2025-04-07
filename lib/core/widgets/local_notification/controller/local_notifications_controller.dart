import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/api_client.dart';
import '../../../services/notifications_helper.dart';
import '../../../utils/constants/api_constants.dart';
import '../data/model/post_model.dart';

class LocalNotificationsController extends GetxController {
  static LocalNotificationsController get instance =>
      Get.isRegistered<LocalNotificationsController>()
          ? Get.find<LocalNotificationsController>()
          : Get.put(LocalNotificationsController());

  RxList<PostModel> postsList = <PostModel>[].obs;
  final box = GetStorage();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    NotifyHelper().notificationBadgeListener();
    fetchNewNotifications();
    loadReadStatus();
  }

  int get unreadCount =>
      postsList.where((n) => n.appName == 'quran' && !n.opened).length;

  Future<void> fetchNewNotifications() async {
    try {
      final response = await ApiClient().request(
        endpoint: ApiConstants.notificationsUrl,
        method: HttpMethod.get,
      );

      if (response.isRight) {
        // فك ترميز JSON الخام إلى كائن Dart
        List<dynamic> jsonData = jsonDecode(response.right as String);
        List<PostModel> jsonResponse =
            jsonData.map((item) => PostModel.fromJson(item)).toList();
        postsList.value = jsonResponse;
        log('Posts loaded: ${postsList.length}');

        loadReadStatus();
        int lastSeenPostId = box.read('lastSeenPostId') ?? 0;

        int newLastSeenPostId = lastSeenPostId;
        update();
        for (var post in jsonResponse) {
          if (post.id > lastSeenPostId && post.appName == 'quran') {
            String title = post.title;
            String body = post.body;
            int id = post.id;

            await NotifyHelper().scheduledNotification(
              reminderId: id,
              title: title,
              summary: title,
              body: body,
              time: DateTime.now().add(const Duration(seconds: 10)),
              isRepeats: false,
            );

            if (id > newLastSeenPostId) {
              newLastSeenPostId = id;
            }
          }
        }

        await box.write('lastSeenPostId', newLastSeenPostId);
      } else {
        log('Failed to load posts, error: ${response.left.message}');
      }
    } catch (e) {
      log('Error fetching notifications: $e');
    }
  }

  void markNotificationAsRead(int postId) {
    int index =
        postsList.indexWhere((notification) => notification.id == postId);
    if (index != -1) {
      postsList[index].opened = true;
      postsList.refresh();
      _saveReadStatus(postId, true);
      NotifyHelper().notificationBadgeListener();
      update();
    }
  }

  void _saveReadStatus(int postId, bool isRead) {
    List<dynamic> readPostsDynamic = box.read<List<dynamic>>('readPosts') ?? [];
    List<int> readPosts = readPostsDynamic.map((e) => e as int).toList();

    if (isRead) {
      if (!readPosts.contains(postId)) {
        readPosts.add(postId);
        log('post read: ${postId}');
        box.write('readPosts', readPosts);
      }
    } else {
      readPosts.remove(postId);
    }
  }

  void loadReadStatus() {
    List<dynamic> readPostsDynamic = box.read<List<dynamic>>('readPosts') ?? [];
    List<int> readPosts = readPostsDynamic.map((e) => e as int).toList();
    log('Read posts IDs: $readPosts');

    for (var post in postsList) {
      post.opened = readPosts.contains(post.id);
      log('Post ID: ${post.id}, opened: ${post.opened}');
    }
    postsList.refresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

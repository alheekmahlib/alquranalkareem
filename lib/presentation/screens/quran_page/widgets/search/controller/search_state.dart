import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/quran.dart';

import '../data/models/search_item.dart';

class SearchState {
  /// -------- [Variables] ----------
  final ScrollController scrollController = ScrollController();
  final searchTextEditing = TextEditingController();
  ContainerTransitionType transitionType = ContainerTransitionType.fade;
  GetStorage box = GetStorage();
  var isLoading = false.obs;
  var ayahList = <AyahModel>[].obs;
  var surahList = <AyahModel>[].obs;
  var errorMessage = ''.obs;
  int currentPage = 1;
  int itemsPerPage = 5;
  bool hasMore = true;
  RxList<SearchItem> searchHistory = <SearchItem>[].obs;
}

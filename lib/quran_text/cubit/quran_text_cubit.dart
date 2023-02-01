import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meta/meta.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../quran_page/data/repository/translate2_repository.dart';
import '../../quran_page/data/repository/translate3_repository.dart';
import '../../quran_page/data/repository/translate4_repository.dart';
import '../../quran_page/data/repository/translate5_repository.dart';
import '../../quran_page/data/repository/translate_repository.dart';
import '../bookmarksText_controller.dart';
import '../model/bookmark_text.dart';

part 'quran_text_state.dart';

class QuranTextCubit extends Cubit<QuranTextState> {
  QuranTextCubit() : super(QuranTextInitial());

  static QuranTextCubit get(context) => BlocProvider.of(context);

  bool isShowBottomSheet = false;
  IconData bookmarksFabIcon = Icons.bookmarks_outlined;
  late final BookmarksTextController bookmarksTextController =
  Get.put(BookmarksTextController());
  late Animation<Offset> offset;
  late AnimationController controller;
  int? id;
  String? ayahNum;
  String? sorahName;
  String translateAyah = '';
  String translate = '';
  late int radioValue;
  var showTaf;
  String? selectedValue;
  double scrollSpeed = 0;
  String? selectedSpeed;
  Color? bColor;
  final ScrollController scrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  double verticalOffset = 0;
  double horizontalOffset = 0;
  PreferDirection preferDirection = PreferDirection.topCenter;
  int isSelected = -1;
  bool selected = false;

  handleRadioValueChanged(int val) {
    TranslateRepository translateRepository = TranslateRepository();
    TranslateRepository2 translateRepository2 = TranslateRepository2();
    TranslateRepository3 translateRepository3 = TranslateRepository3();
    TranslateRepository4 translateRepository4 = TranslateRepository4();
    TranslateRepository5 translateRepository5 = TranslateRepository5();

    radioValue = val;
    switch (radioValue) {
      case 0:
        return showTaf = translateRepository2;
        break;
      case 1:
        return showTaf = translateRepository;
        break;
      case 2:
        return showTaf = translateRepository3;
        break;
      case 3:
        return showTaf = translateRepository4;
        break;
      case 4:
        return showTaf = translateRepository5;
        break;
      default:
        return showTaf = translateRepository2;
    }
  }


  addBookmarkText(String sorahName, int sorahNum, pageNum, nomPageF, nomPageL, lastRead,) async {
    try {
      int? bookmark = await bookmarksTextController.addBookmarksText(
        BookmarksText(
          id,
          sorahName,
          sorahNum,
          pageNum,
          nomPageF,
          nomPageL,
          lastRead,
        ),
      );
      print('bookmark number: ${bookmark!}');
    } catch (e) {
      print('Error');
    }
  }

  /// Time

  // var now = DateTime.now();
  String lastRead = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  void bookmarksChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(ChangeBottomShowState());
  }

  void bookmarksCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(CloseBottomShowState());
  }

  void tafseerChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(ChangeBottomShowState());
  }

  void tafseerCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isShowBottomSheet = isShow;
    bookmarksFabIcon = icon;
    emit(CloseBottomShowState());
  }
}

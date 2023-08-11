import 'package:alquranalkareem/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(SoundPageState());
  static QuranCubit get(context) => BlocProvider.of<QuranCubit>(context);

  bool isShowSettings = false;

  void initState() {
    // MPages.currentPage2 = cuMPage;
    // scrollController = ScrollController();
    // scrollController.addListener(() {
    //   if (scrollController.offset >=
    //           scrollController.position.maxScrollExtent &&
    //       !scrollController.position.outOfRange) {
    //     panelController.expand();
    //   } else if (scrollController.offset <=
    //           scrollController.position.minScrollExtent &&
    //       !scrollController.position.outOfRange) {
    //     panelController.anchor();
    //   } else {}
    // });
    emit(QuranPageState());
  }

  /// Time
  // var now = DateTime.now();
  String lastRead =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
}

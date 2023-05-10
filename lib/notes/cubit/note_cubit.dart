import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_state.dart';


class NotesCubit extends Cubit<NotesState>{
  NotesCubit() : super(NotesAddState());

  static NotesCubit get(context) => BlocProvider.of(context);
  bool isShowBottomSheet = false;
  IconData notesFabIcon = Icons.add_comment_outlined;
  List<Map> notes = [];


  void notesChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }){
    isShowBottomSheet = isShow;
    notesFabIcon = icon;
    emit(ChangeBottomShowState());
  }
  void notesCloseBottomSheetState({
    required bool isShow,
    required IconData icon,
  }){
    isShowBottomSheet = isShow;
    notesFabIcon = icon;
    emit(CloseBottomShowState());
  }
}
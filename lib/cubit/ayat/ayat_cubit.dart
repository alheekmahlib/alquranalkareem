import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../quran_page/data/model/ayat.dart';

part 'ayat_state.dart';

class AyatCubit extends Cubit<List<Ayat>?> {
  final QuranCubit cubit;
  final BuildContext context;

  AyatCubit(this.cubit, this.context) : super(null);

  void fetchAyat(int pageNum) async {
    List<Ayat>? ayat = await cubit
        .handleRadioValueChanged(context, cubit.radioValue)
        .getPageTranslate(pageNum);
    emit(ayat);
  }
}

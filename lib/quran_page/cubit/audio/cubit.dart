import 'package:alquranalkareem/quran_page/cubit/audio/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioAyahState());

  static AudioCubit get(context) => BlocProvider.of(context);

  /// Ayah play

  String? readerValue;
  String? ayahNum;
  String? sorahName;


  // Save & Load Reader Quran
  saveQuranReader(String readerValue) async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    await prefService.setString('audio_player_sound', readerValue);
    emit(AudioSharedPrefeState());
  }

  loadQuranReader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    readerValue =
        prefs.getString('audio_player_sound') ?? "Abdul_Basit_Murattal_192kbps";
    print('Quran Reader ${prefs.getString('audio_player_sound')}');
    emit(AudioSharedPrefeState());
  }
}
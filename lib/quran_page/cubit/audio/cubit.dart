import 'package:alquranalkareem/quran_page/cubit/audio/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioAyahState()) {}

  static AudioCubit get(context) => BlocProvider.of(context);

  /// Ayah play

  String? readerValue;
  String? sorahReaderValue;
  String? sorahPageReaderValue;
  String? sorahReaderNameValue;
  String? ayahNum;
  int? ayahNumber;
  String? sorahName;
  late Animation<Offset> offset;
  late AnimationController controllerSorah;

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

  // Save & Load Reader Quran
  saveSorahReader(String readerValue, sorahReaderName) async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    await prefService.setString('sorah_audio_player_sound', readerValue);
    await prefService.setString('sorah_audio_player_name', sorahReaderName);
    emit(AudioSharedPrefeState());
  }

  loadSorahReader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sorahReaderValue = prefs.getString('sorah_audio_player_sound') ??
        "https://server7.mp3quran.net/";
    sorahReaderNameValue =
        prefs.getString('sorah_audio_player_name') ?? "basit/";
    print('Quran Reader ${prefs.getString('sorah_audio_player_sound')}');
    emit(AudioSharedPrefeState());
  }
}

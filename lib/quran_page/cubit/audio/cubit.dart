import 'package:alquranalkareem/quran_page/cubit/audio/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioAyahState()) {}

  static AudioCubit get(context) => BlocProvider.of(context);

  /// Ayah play
}

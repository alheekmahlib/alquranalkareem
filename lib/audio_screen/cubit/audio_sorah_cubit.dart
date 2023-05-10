import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'audio_sorah_state.dart';

class AudioSorahCubit extends Cubit<AudioSorahState> {
  AudioSorahCubit() : super(AudioSorahInitial());

  static AudioSorahCubit get(context) => BlocProvider.of(context);


}

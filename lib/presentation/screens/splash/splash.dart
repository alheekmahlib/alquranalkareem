import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_library/quran_library.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/widgets/container_button.dart';
import '/core/widgets/settings_list.dart';
import '/presentation/controllers/general/extensions/general_getters.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../core/utils/constants/lottie_constants.dart';
import '../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../core/utils/constants/svg_constants.dart';
import '../../../core/widgets/animated_drawing_widget.dart';
import '../../controllers/general/general_controller.dart';
import '../../controllers/settings_controller.dart';
import '../calendar/events.dart';
import '../home/home_screen.dart';
import '../whats_new/whats_new.dart';

part 'controller/splash_screen_controller.dart';
part 'controller/splash_screen_state.dart';
part 'screen/splash_screen.dart';
part 'screen/widgets/alheekmah_and_loading.dart';
part 'screen/widgets/logo_and_title.dart';

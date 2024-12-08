import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/controllers/general/extensions/general_getters.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../core/utils/constants/lottie_constants.dart';
import '../../../core/utils/constants/svg_constants.dart';
import '../../../core/widgets/container_with_border.dart';
import '../../controllers/general/general_controller.dart';
import '../../controllers/settings_controller.dart';
import '../quran_page/quran.dart';
import '../whats_new/whats_new.dart';

part 'controller/splash_screen_controller.dart';
part 'controller/splash_screen_state.dart';
part 'screen/splash_screen.dart';
part 'screen/widgets/alheekmah_and_loading.dart';
part 'screen/widgets/logo_and_title.dart';

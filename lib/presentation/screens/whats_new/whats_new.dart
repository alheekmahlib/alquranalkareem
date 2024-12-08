import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/presentation/controllers/general/extensions/general_getters.dart';
import '/presentation/controllers/general/general_controller.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../core/widgets/elevated_button_widget.dart';
import '../../../core/widgets/select_screen_build.dart';
import '../screen_type.dart';
import '../splash/splash.dart';

part 'controller/extensions/whats_new_getters.dart';
part 'controller/whats_new_controller.dart';
part 'controller/whats_new_state.dart';
part 'screen/whats_new_screen.dart';
part 'screen/widgets/button_widget.dart';
part 'screen/widgets/page_view_build.dart';
part 'screen/widgets/smooth_page_indicator.dart';
part 'screen/widgets/whats_new_widget.dart';

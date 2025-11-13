import 'dart:convert';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri_date/hijri_date.dart';

import '/core/utils/constants/extensions/bottom_sheet_extension.dart';
import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '../../../core/utils/constants/lists.dart';
import '../../../core/utils/constants/lottie.dart';
import '../../../core/widgets/home_widget/hijri_home_widget_controller.dart';
import '../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/general/general_controller.dart';

part 'controller/event_controller.dart';
part 'data/model/event_model.dart';
part 'screen/hijri_calendar_screen.dart';
part 'widgets/all_calculating_events_widget.dart';
part 'widgets/calculating_date_events_widget.dart';
part 'widgets/calendar_build.dart';
part 'widgets/days_name.dart';
part 'widgets/hijri_widget_integration.dart';
part 'widgets/month_selection.dart';
part 'widgets/reminder_event_bottom_sheet.dart';
part 'widgets/year_selection.dart';

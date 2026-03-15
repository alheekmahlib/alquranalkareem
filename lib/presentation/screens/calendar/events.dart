import 'dart:convert';

import 'package:alquranalkareem/core/utils/helpers/app_text_styles.dart';
import 'package:alquranalkareem/core/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri_date/hijri_date.dart';
import 'package:intl/intl.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '/core/utils/constants/extensions/bottom_sheet_extension.dart';
import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/extensions/text_span_extension.dart';
import '../../../core/services/languages/localization_controller.dart';
import '../../../core/utils/constants/lists.dart';
import '../../../core/utils/constants/lottie.dart';
import '../../../core/widgets/custom_sheet_widget.dart';
import '../../../core/widgets/home_widget/hijri_home_widget_controller.dart';
import '../../../core/widgets/tab_bar_widget.dart';
import '../../controllers/general/general_controller.dart';
import '../home/widgets/hijri_widget.dart';

part 'controller/event_controller.dart';
part 'data/model/event_model.dart';
part 'screen/hijri_calendar_screen.dart';
part 'widgets/all_calculating_events_widget.dart';
part 'widgets/calculating_date_events_widget.dart';
part 'widgets/calendar_build.dart';
part 'widgets/days_name.dart';
part 'widgets/hijri_widget_integration.dart';
part 'widgets/reminder_event_bottom_sheet.dart';

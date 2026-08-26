import 'dart:math';
import 'dart:ui' show ImageFilter, lerpDouble;

import 'package:alquranalkareem/core/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:particles_flutter/engine.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '../../../core/services/sync/sync_controller.dart';
import '../../../core/utils/constants/extensions/bottom_sheet_extension.dart';
import '../../../core/utils/constants/extensions/svg_extensions.dart';
import '../../../core/utils/constants/svg_constants.dart';
import '../../../core/utils/constants/sync_constants.dart';
import '../../../core/utils/helpers/app_text_styles.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/container_button.dart';

part 'sync_scanner_screen.dart';
part 'sync_screen.dart';
part 'widgets/info_card.dart';
part 'widgets/ios_qr_card.dart';
part 'widgets/paired_view.dart';
part 'widgets/unpaired_view.dart';

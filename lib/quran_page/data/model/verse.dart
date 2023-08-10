import 'dart:math';

import 'package:alquranalkareem/shared/controller/general_controller.dart';
import 'package:alquranalkareem/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../database/verseDBHelper.dart';

class Verse {
  final int ayahNumber;
  final int glyphId;
  final int lineNumber;
  final int maxX;
  final int maxY;
  final int minX;
  final int minY;
  final int pageNumber;
  final int position;
  final int suraNumber;

  Verse({
    required this.ayahNumber,
    required this.glyphId,
    required this.lineNumber,
    required this.maxX,
    required this.maxY,
    required this.minX,
    required this.minY,
    required this.pageNumber,
    required this.position,
    required this.suraNumber,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      ayahNumber: json['ayah_number'],
      glyphId: json['glyph_id'],
      lineNumber: json['line_number'],
      maxX: json['max_x'],
      maxY: json['max_y'],
      minX: json['min_x'],
      minY: json['min_y'],
      pageNumber: json['page_number'],
      position: json['position'],
      suraNumber: json['sura_number'],
    );
  }
}

class QuranPage extends StatefulWidget {
  final String imageUrl;
  final String imageUrl2;
  final int currentPage;

  QuranPage({
    required this.imageUrl,
    required this.imageUrl2,
    required this.currentPage,
  });

  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late List<bool> _selectedVerses;
  List<Verse>? verses;
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _gestureDetectorKey = GlobalKey();
  late final GeneralController generalController = Get.put(GeneralController());

  @override
  void initState() {
    super.initState();
    _fetchVerses();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // قم بتخزين الموقع الحالي للصورة بعد التحديث
      _updateImagePosition();
    });
  }

  void _updateImagePosition() {
    final RenderBox imageBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox gestureDetectorBox =
        _gestureDetectorKey.currentContext?.findRenderObject() as RenderBox;

    final imageOffset = imageBox.localToGlobal(Offset.zero);
    final gestureDetectorOffset = gestureDetectorBox.localToGlobal(Offset.zero);

    final touchPosition = gestureDetectorOffset - imageOffset;

    // استخدم touchPosition كموقع لمعرفة نقطة النقر على الصورة

    print('تم النقر على الصورة في الموقع: $touchPosition');
  }

  // void _onTap(TapDownDetails details) {
  //   QuranCubit cubit = QuranCubit.get(context);
  //   RenderBox box = context.findRenderObject() as RenderBox;
  //   Offset localPosition = box.globalToLocal(details.globalPosition);
  //
  //   // Adjust for translation and scale
  //   double adjustedX = localPosition.dx / 0.90;
  //   double adjustedY = adjustedYValue((localPosition.dy - 5) / 0.84, (localPosition.dy - 10) / 0.74);
  //   Offset adjustedPosition = Offset(adjustedX, adjustedY);
  //
  //   int tappedVerseIndex;
  //   if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //     tappedVerseIndex = _findTappedVersePortrait(adjustedPosition);
  //   } else {
  //     tappedVerseIndex = _findTappedVerseLandscape(adjustedPosition);
  //   }
  //
  //   if (tappedVerseIndex != -1) {
  //     print('Verse tapped: ${tappedVerseIndex + 1}');
  //     setState(() {
  //       // Deselect all other verses
  //       for (int i = 0; i < _selectedVerses.length; i++) {
  //         if (i != tappedVerseIndex) {
  //           _selectedVerses[i] = false;
  //         }
  //       }
  //       // Select the tapped verse
  //       _selectedVerses[tappedVerseIndex] = !_selectedVerses[tappedVerseIndex];
  //     });
  //   }
  // }
  //
  // void _onTap2(TapDownDetails details) {
  //   QuranCubit cubit = QuranCubit.get(context);
  //   RenderBox box = context.findRenderObject() as RenderBox;
  //   Offset localPosition = box.globalToLocal(details.globalPosition);
  //
  //   // Adjust for translation and scale
  //   double adjustedX = cubit.selected ? localPosition.dx / 0.92 : localPosition.dx / 0.90;
  //   double adjustedY = cubit.selected ? (localPosition.dy - 60 - 10) / 0.92 : (localPosition.dy - 0.84) / 0.84;
  //   Offset adjustedPosition = Offset(adjustedX, adjustedY);
  //
  //   int tappedVerseIndex;
  //   if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //     tappedVerseIndex = _findTappedVersePortrait(adjustedPosition);
  //   } else {
  //     tappedVerseIndex = _findTappedVerseLandscape(adjustedPosition);
  //   }
  //
  //   if (tappedVerseIndex != -1) {
  //     print('Verse tapped: ${tappedVerseIndex + 1}');
  //     setState(() {
  //       // Deselect all other verses
  //       for (int i = 0; i < _selectedVerses.length; i++) {
  //         if (i != tappedVerseIndex) {
  //           _selectedVerses[i] = false;
  //         }
  //       }
  //       // Select the tapped verse
  //       _selectedVerses[tappedVerseIndex] = !_selectedVerses[tappedVerseIndex];
  //     });
  //   }
  // }

  void _onTap2(TapDownDetails details) {
    // QuranCubit cubit = QuranCubit.get(context);
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);

    double adjustedYOffset;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      adjustedYOffset = 60;
    } else {
      adjustedYOffset =
          0; // Adjust this value to move the pressure point down in landscape mode
    }

    // Adjust for translation and scale
    double adjustedX = localPosition.dx / 0.92;
    double adjustedY = (localPosition.dy - adjustedYOffset) / 0.92;
    Offset adjustedPosition = Offset(adjustedX, adjustedY);

    int tappedVerseIndex = _findTappedVerse(adjustedPosition);
    if (tappedVerseIndex != -1) {
      print('Verse tapped: ${tappedVerseIndex + 1}');
      setState(() {
        // Deselect all other verses
        for (int i = 0; i < _selectedVerses.length; i++) {
          if (i != tappedVerseIndex) {
            _selectedVerses[i] = false;
          }
        }
        // Select the tapped verse
        _selectedVerses[tappedVerseIndex] = !_selectedVerses[tappedVerseIndex];
      });
    }
  }

  // void _onTap(TapDownDetails details) {
  //   QuranCubit cubit = QuranCubit.get(context);
  //   RenderBox box = context.findRenderObject() as RenderBox;
  //   Offset localPosition = box.globalToLocal(details.globalPosition);
  //
  //   // Adjust for translation and scale
  //   double adjustedX = localPosition.dx / 0.90;
  //   double adjustedY = orientation(context, ((localPosition.dy - 5) / 0.84), ((localPosition.dy - 2) / 0.84)); // Adjust the Y value here
  //   Offset adjustedPosition = Offset(adjustedX, adjustedY);
  //
  //   int tappedVerseIndex = _findTappedVerse(adjustedPosition);
  //   if (tappedVerseIndex != -1) {
  //     print('Verse tapped: ${tappedVerseIndex + 1}');
  //     setState(() {
  //       // Deselect all other verses
  //       for (int i = 0; i < _selectedVerses.length; i++) {
  //         if (i != tappedVerseIndex) {
  //           _selectedVerses[i] = false;
  //         }
  //       }
  //       // Select the tapped verse
  //       _selectedVerses[tappedVerseIndex] = !_selectedVerses[tappedVerseIndex];
  //     });
  //   }
  // }

  // void _onTap(TapDownDetails details, BoxConstraints constraints) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     QuranCubit cubit = QuranCubit.get(context);
  //     RenderBox box = context.findRenderObject() as RenderBox;
  //     Offset localPosition = box.globalToLocal(details.globalPosition);
  //
  //     double adjustedYOffset;
  //     double scaleFactor;
  //     double xTranslationFactor;
  //
  //     if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //       adjustedYOffset = calculateAdjustedYOffset(constraints.maxHeight);
  //       scaleFactor = 0.84;
  //       xTranslationFactor = 0.90;
  //     } else {
  //       double screenWidth = MediaQuery.of(context).size.width;
  //       adjustedYOffset = 60; // Adjust this value to move the pressure point down in landscape mode
  //       scaleFactor = 0.84 * (screenWidth / 1260); // Adjust the scale factor based on the screen width
  //       xTranslationFactor = 0.90 * (screenWidth / 1260); // Adjust the x translation factor based on the screen width
  //     }
  //
  //     Offset adjustedLocalPosition = Offset(
  //       localPosition.dx / xTranslationFactor,
  //       localPosition.dy / scaleFactor,
  //     );
  //
  //     double adjustedY = adjustedLocalPosition.dy - adjustedYOffset;
  //     Offset adjustedPosition = Offset(adjustedLocalPosition.dx, adjustedY);
  //
  //     int tappedVerseIndex = _findTappedVerse(adjustedPosition);
  //     if (tappedVerseIndex != -1) {
  //       print('Verse tapped: ${tappedVerseIndex + 1}');
  //       setState(() {
  //         // Deselect all other verses
  //         for (int i = 0; i < _selectedVerses.length; i++) {
  //           if (i != tappedVerseIndex) {
  //             _selectedVerses[i] = false;
  //           }
  //         }
  //         // Select the tapped verse
  //         _selectedVerses[tappedVerseIndex] = !_selectedVerses[tappedVerseIndex];
  //       });
  //     }
  //   });
  // }

  // void _onTap(TapDownDetails details, BoxConstraints constraints) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     QuranCubit cubit = QuranCubit.get(context);
  //     RenderBox box = context.findRenderObject() as RenderBox;
  //     Offset localPosition = box.globalToLocal(details.globalPosition);
  //
  //     double? adjustedYOffset;
  //     if (MediaQuery
  //         .of(context)
  //         .orientation == Orientation.portrait) {
  //       // adjustedYOffset = calculateAdjustedYOffset(constraints.maxHeight);
  //       double adjustedYOffset = calculateAdjustedYOffset();
  //     } else {
  //       adjustedYOffset =
  //       0; // Adjust this value to move the pressure point down in landscape mode
  //     }
  //
  //     // Adjust for translation and scale
  //     double adjustedX = localPosition.dx / 0.90;
  //     double adjustedY = (localPosition.dy - adjustedYOffset!) /
  //         0.84; // Adjust the Y value here
  //     Offset adjustedPosition = Offset(adjustedX, adjustedY);
  //
  //     int tappedVerseIndex = _findTappedVerse(adjustedPosition);
  //     if (tappedVerseIndex != -1) {
  //       print('Verse tapped: ${tappedVerseIndex + 1}');
  //       setState(() {
  //         // Deselect all other verses
  //         for (int i = 0; i < _selectedVerses.length; i++) {
  //           if (i != tappedVerseIndex) {
  //             _selectedVerses[i] = false;
  //           }
  //         }
  //         // Select the tapped verse
  //         _selectedVerses[tappedVerseIndex] =
  //         !_selectedVerses[tappedVerseIndex];
  //       });
  //     }
  //   });
  // }

  double _calculateScaleFactor(double screenWidth, double screenHeight) {
    // Define breakpoints for different screen sizes
    double smallScreenWidth = 320.0;
    double mediumScreenWidth = 480.0;
    double largeScreenWidth = 720.0;

    if (screenWidth <= smallScreenWidth) {
      return 0.85;
    } else if (screenWidth <= mediumScreenWidth) {
      return 0.84;
    } else if (screenWidth <= largeScreenWidth) {
      return 0.90;
    } else {
      return 0.93;
    }
  }

  double _calculateSelectedScaleFactor(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor;

    // Define breakpoints for different screen sizes
    double smallScreenWidth = 320.0;
    double mediumScreenWidth = 480.0;
    double largeScreenWidth = 720.0;

    if (screenWidth <= smallScreenWidth) {
      scaleFactor = 0.88;
    } else if (screenWidth <= mediumScreenWidth) {
      scaleFactor = 0.90;
    } else if (screenWidth <= largeScreenWidth) {
      scaleFactor = 0.92;
    } else {
      scaleFactor = 0.95;
    }

    return orientation(context, scaleFactor, scaleFactor);
  }

  // int _findTappedVerse(Offset localPosition) {
  //   double scaleFactor = MediaQuery.of(context).size.width / 1260;
  //   double padding;
  //
  //   if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //     padding = 3.0; // Increase the tap area for portrait mode
  //   } else {
  //     padding = 15.0; // Increase the tap area for landscape mode
  //   }
  //
  //   for (int i = 0; i < widget.verses.length; i++) {
  //     if (localPosition.dx >= (widget.verses[i].minX - padding) * scaleFactor &&
  //         localPosition.dx <= (widget.verses[i].maxX + padding) * scaleFactor &&
  //         localPosition.dy >= (widget.verses[i].minY - padding) * scaleFactor &&
  //         localPosition.dy <= (widget.verses[i].maxY + padding) * scaleFactor) {
  //       return i;
  //     }
  //   }
  //   return -1;
  // }

  // double calculateAdjustedYOffset() {
  //   double screenHeight = MediaQuery.of(context).size.height;
  //   double screenWidth = MediaQuery.of(context).size.width;
  //
  //   if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //     // Define the screen heights for small and large screens
  //     double smallScreenHeight = 600; // Adjust this value as needed
  //     double largeScreenHeight = 900; // Adjust this value as needed
  //
  //     // Define the adjusted Y offsets for small and large screens
  //     double smallScreenOffset = screenHeight * 0.062;
  //     double largeScreenOffset = screenHeight * 0.128;
  //
  //     // Use linear interpolation to calculate the adjusted Y offset
  //     return lerp(screenHeight, smallScreenHeight, largeScreenHeight, smallScreenOffset, largeScreenOffset);
  //   } else {
  //     // Define the screen widths for small and large screens
  //     double smallScreenWidth = 800; // Adjust this value as needed
  //     double largeScreenWidth = 1200; // Adjust this value as needed
  //
  //     // Define the adjusted Y offsets for small and large screens
  //     double smallScreenOffset = screenWidth * 0.032; // Adjust this value as needed
  //     double largeScreenOffset = screenWidth * 0.064; // Adjust this value as needed
  //
  //     // Use linear interpolation to calculate the adjusted Y offset
  //     return lerp(screenWidth, smallScreenWidth, largeScreenWidth, smallScreenOffset, largeScreenOffset);
  //   }
  // }

  // Future<void> _fetchVerses() async {
  //   DBHelper dbHelper = DBHelper.instance;
  //   List<Verse> verses = await dbHelper.getVerses();
  //   setState(() {
  //     widget.verses = verses;
  //     _selectedVerses = List.generate(verses.length, (index) => false);
  //   });
  // }
  Future<List<Map<String, dynamic>>> _getVersesFromDatabase() async {
    // Replace this line with your database query
    List<Map<String, dynamic>> data =
        await DBHelper().getVersesForCurrentPage(widget.currentPage);
    return data;
  }

  double getImageWidthFactor(BuildContext context, bool isLandscape) {
    double screenWidth = MediaQuery.of(context).size.width;

    double baseFactor = 1.0;

    if (isLandscape) {
      baseFactor = 1.90;
    } else {
      // Your existing portrait calculations
      if (screenWidth < 360) {
        baseFactor = 1.1;
      } else if (screenWidth < 1080) {
        baseFactor = 1.59;
      } else if (screenWidth < 1284) {
        baseFactor = 1.36;
      } else {
        baseFactor = 1.36;
      }
    }

    return baseFactor;
  }

  // void _onTap(TapDownDetails details, BoxConstraints constraints) {
  //   final RenderBox imageBox = context.findRenderObject() as RenderBox;
  //   final Offset localTouchPosition = details.localPosition;
  //   final Offset imagePosition = imageBox.localToGlobal(Offset.zero);
  //   final double x = localTouchPosition.dx + imagePosition.dx;
  //   final double y = localTouchPosition.dy + imagePosition.dy;
  //   double adjustedYOffset =
  //       calculateAdjustedYOffset(MediaQuery.sizeOf(context).height);
  //   bool isLandscape =
  //       MediaQuery.of(context).orientation == Orientation.landscape;
  //   print(
  //       'x $x | y $y | AdjustedYOffset ${calculateAdjustedYOffset(MediaQuery.sizeOf(context).height)}');
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     RenderBox box = context.findRenderObject() as RenderBox;
  //     Offset localPosition = box.globalToLocal(details.globalPosition);
  //     bool isLandscape =
  //         MediaQuery.of(context).orientation == Orientation.landscape;
  //
  //     double adjustedYOffset;
  //     double scaleFactor;
  //     double xTranslationFactor;
  //
  //     // Calculate the imageWidth scale factor based on the screen size
  //     // const double minScreenWidth = 320.0; // Minimum screen width for adjustments
  //     // const double maxScreenWidth = 768.0; // Maximum screen width for adjustments
  //     //
  //     // const double minImageWidthFactor = 3.1; // Image width factor for the minimum screen width
  //     // const double maxImageWidthFactor = 1.16; // Image width factor for the maximum screen width
  //
  //     // double largeScreenWidthFactor = 1.625;
  //     // double getImageWidthFactor(double screenWidth) {
  //     //   if (screenWidth <= minScreenWidth) {
  //     //     return minImageWidthFactor;
  //     //   } else if (screenWidth >= maxScreenWidth) {
  //     //     return maxImageWidthFactor;
  //     //   } else {
  //     //     return lerp(
  //     //       screenWidth,
  //     //       minScreenWidth,
  //     //       maxScreenWidth,
  //     //       minImageWidthFactor,
  //     //       maxImageWidthFactor,
  //     //     );
  //     //   }
  //     // }
  //     // double screenWidth = ScreenUtil().screenWidth;
  //     // double screenHeight = ScreenUtil().screenHeight;
  //     // double imageWidthFactor = getImageWidthFactor(context, isLandscape);
  //
  //     // RenderBox imageRenderBox =
  //     //     _imageKey.currentContext?.findRenderObject() as RenderBox;
  //     // double imageWidth = imageRenderBox.size.width * imageWidthFactor;
  //
  //     // if (!isLandscape) {
  //     //   // adjustedYOffset = calculateAdjustedYOffset(constraints.maxHeight);
  //     //   // scaleFactor = 0.84.sp;
  //     //   // xTranslationFactor = 0.90.sp;
  //     // } else {
  //     //   // adjustedYOffset = constraints.maxHeight * .9;
  //     //   adjustedYOffset =
  //     //       20; // Adjust this value to move the pressure point down in landscape mode
  //     //   // scaleFactor = (0.45 * (imageWidth / 1260))
  //     //   // scaleFactor = MediaQuery.sizeOf(context).width /
  //     //   //     imageWidth; // Adjust the scale factor based on the image width
  //     //   scaleFactor = orientation(context, 2.20, .26);
  //     //   print('${MediaQuery.sizeOf(context).width}');
  //     //   xTranslationFactor =
  //     //       .56; // Adjust the x translation factor based on the image width
  //     // }
  //
  //     print('width ${MediaQuery.sizeOf(context).width}');
  //     print('height ${MediaQuery.sizeOf(context).height}');
  //     // Adjust for translation and scale
  //     double adjustedX = localPosition.dx / xTranslationFactor;
  //     double adjustedY = (localPosition.dy - adjustedYOffset) / scaleFactor;
  //     Offset adjustedPosition = Offset(adjustedX, adjustedY);
  //
  //     int tappedVerseIndex = _findTappedVerse(adjustedPosition);
  //     if (tappedVerseIndex != -1) {
  //       print('Verse tapped: ${tappedVerseIndex + 1}');
  //       setState(() {
  //         // Deselect all other verses
  //         for (int i = 0; i < _selectedVerses.length; i++) {
  //           if (i != tappedVerseIndex) {
  //             _selectedVerses[i] = false;
  //           }
  //         }
  //         // Select the tapped verse
  //         _selectedVerses[tappedVerseIndex] =
  //             !_selectedVerses[tappedVerseIndex];
  //       });
  //     }
  //   });
  // }

  void onTap2(details) {
    final RenderBox imageBox = context.findRenderObject() as RenderBox;
    final Offset localTouchPosition = details.localPosition;
    final Offset imagePosition = imageBox.localToGlobal(Offset.zero);
    final double x = localTouchPosition.dx + imagePosition.dx;
    final double y = localTouchPosition.dy + imagePosition.dy;
    print(
        'x $x | y $y | AdjustedYOffset ${calculateAdjustedYOffset(MediaQuery.sizeOf(context).height)}');
  }

  int _findTappedVersePercentage(double xPercentage, double yPercentage) {
    for (int i = 0; i < verses!.length; i++) {
      if (xPercentage >= verses![i].minX / 1162 &&
          xPercentage <= verses![i].maxX / 1162 &&
          yPercentage >= verses![i].minY / 1162 &&
          yPercentage <= verses![i].maxY / 1162) {
        return i;
      }
    }
    return -1;
  }

  // void _onTap(TapDownDetails details, BoxConstraints constraints) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // The rest of the _onTap function remains unchanged
  //     QuranCubit cubit = QuranCubit.get(context);
  //     RenderBox box = context.findRenderObject() as RenderBox;
  //     Offset localPosition = box.globalToLocal(details.globalPosition);
  //
  //     double adjustedYOffset;
  //     double scaleFactor;
  //     double xTranslationFactor;
  //
  //     if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //       adjustedYOffset = calculateAdjustedYOffset(constraints.maxHeight);
  //       scaleFactor = 0.84;
  //       xTranslationFactor = 0.90;
  //     } else {
  //       double screenWidth = MediaQuery.of(context).size.width;
  //       adjustedYOffset = 60; // Adjust this value to move the pressure point down in landscape mode
  //       scaleFactor = 0.84 * (screenWidth / 1260); // Adjust the scale factor based on the screen width
  //       xTranslationFactor = 0.90 * (screenWidth / 1260); // Adjust the x translation factor based on the screen width
  //       print('ScreenWidth: $screenWidth');
  //       print('adjustedYOffset: $adjustedYOffset');
  //       print('scaleFactor: $scaleFactor');
  //       print('xTranslationFactor: $xTranslationFactor');
  //
  //     }
  //
  //     // double adjustedYOffset;
  //     if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //       adjustedYOffset = calculateAdjustedYOffset(constraints.maxHeight);
  //     } else {
  //       adjustedYOffset = 50; // Adjust this value to move the pressure point down in landscape mode
  //     }
  //
  //     // Adjust for translation and scale
  //     // double adjustedX = localPosition.dx / xTranslationFactor;
  //     // double adjustedY = (localPosition.dy - adjustedYOffset) / scaleFactor;
  //     // Offset adjustedPosition = Offset(adjustedX, adjustedY);
  //     // print('localPosition: $localPosition');
  //     // print('adjustedPosition: $adjustedPosition');
  //
  //     // Adjust for translation and scale
  //     double adjustedX = localPosition.dx / 0.90;
  //     double adjustedY = (localPosition.dy - adjustedYOffset) / 0.84; // Adjust the Y value here
  //     Offset adjustedPosition = Offset(adjustedX, adjustedY);
  //
  //     int tappedVerseIndex = _findTappedVerse(adjustedPosition);
  //     if (tappedVerseIndex != -1) {
  //       print('Verse tapped: ${tappedVerseIndex + 1}');
  //       setState(() {
  //         // Deselect all other verses
  //         for (int i = 0; i < _selectedVerses.length; i++) {
  //           if (i != tappedVerseIndex) {
  //             _selectedVerses[i] = false;
  //           }
  //         }
  //         // Select the tapped verse
  //         _selectedVerses[tappedVerseIndex] = !_selectedVerses[tappedVerseIndex];
  //       });
  //     }
  //   });
  // }

  double lerp(double x, double x0, double x1, double y0, double y1) {
    return y0 + (x - x0) * (y1 - y0) / (x1 - x0);
  }

  double adjustedYValue(double portraitValue, double landscapeValue) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? portraitValue
        : landscapeValue;
  }

  int _findTappedVerse(Offset localPosition) {
    double scaleFactor = MediaQuery.of(context).size.width / 1162;
    double padding = 3.0; // Add a padding value to increase the tap area

    for (int i = 0; i < verses!.length; i++) {
      if (localPosition.dx >= (verses![i].minX - padding) * scaleFactor &&
          localPosition.dx <= (verses![i].maxX + padding) * scaleFactor &&
          localPosition.dy >= (verses![i].minY - padding) * scaleFactor &&
          localPosition.dy <= (verses![i].maxY + padding) * scaleFactor) {
        return i;
      }
    }
    return -1;
  }

  double calculateVerticalMargin(BoxConstraints constraints) {
    double screenSizeAverage =
        (constraints.maxWidth + constraints.maxHeight) / 2;
    return screenSizeAverage * 0.035; // Adjust the multiplier as needed
  }

  double calculateAdjustedXOffset(double screenWidth, double screenHeight) {
    if (screenWidth >= 768.0) {
      return 100.0;
    } else if (screenWidth >= 640.0) {
      return 80.0;
    } else if (screenWidth >= 540.0) {
      return 60.0;
    } else {
      return 40.0;
    }
  }

  double calculateAdjustedYOffset(double screenHeight) {
    // Define the screen heights for small and large screens
    double smallScreenHeight = 600; // Adjust this value as needed
    double largeScreenHeight = 900; // Adjust this value as needed

    // Define the adjusted Y offsets for small and large screens
    double smallScreenOffset = screenHeight * 0.062;
    double largeScreenOffset = screenHeight * 0.128;

    // Use linear interpolation to calculate the adjusted Y offset
    return lerp(screenHeight, smallScreenHeight, largeScreenHeight,
        smallScreenOffset, largeScreenOffset);
  }

  double calculateAdjustedYOffsetForLand(double screenHeight) {
    // Define the screen heights for small and large screens
    double smallScreenHeight = 600; // Adjust this value as needed
    double largeScreenHeight = 900; // Adjust this value as needed

    // Define the adjusted Y offsets for small and large screens
    double smallScreenOffset = screenHeight * 0.062;
    double largeScreenOffset = screenHeight * 0.128;

    // Use linear interpolation to calculate the adjusted Y offset
    return lerp(screenHeight, smallScreenHeight, largeScreenHeight,
        smallScreenOffset, largeScreenOffset);
  }

  Future<void> _fetchVerses() async {
    final data = await DBHelper().getVersesForCurrentPage(widget.currentPage);
    setState(() {
      verses = data.map((v) => Verse.fromJson(v)).toList();
      _selectedVerses = List.generate(verses!.length, (index) => false);
    });
    print('verses!.length ${verses!.length}');
  }

  // void _onTap(TapDownDetails details, BoxConstraints constraints) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     QuranCubit cubit = QuranCubit.get(context);
  //     RenderBox box = context.findRenderObject() as RenderBox;
  //     Offset localPosition = box.globalToLocal(details.globalPosition);
  //
  //     double adjustedYOffset;
  //     double adjustedXOffset;
  //     double scaleFactor;
  //     double xTranslationFactor;
  //
  //     if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //       adjustedYOffset = calculateAdjustedYOffset(constraints.maxHeight);
  //       adjustedXOffset = 0.0;
  //       scaleFactor = 0.84;
  //       xTranslationFactor = 0.90;
  //     } else {
  //       double screenWidth = MediaQuery.of(context).size.width;
  //       double screenHeight = MediaQuery.of(context).size.height;
  //       adjustedYOffset = 90; // Adjust this value to move the pressure point down in landscape mode
  //       adjustedXOffset = calculateAdjustedXOffset(screenWidth, screenHeight);
  //       scaleFactor = 0.94 * (screenWidth / 1260); // Adjust the scale factor based on the screen width
  //       xTranslationFactor = 0.90 * (screenWidth / 1260); // Adjust the x translation factor based on the screen width
  //     }
  //
  //     Offset adjustedLocalPosition = Offset(
  //       (localPosition.dx - adjustedXOffset) / xTranslationFactor,
  //       localPosition.dy / scaleFactor,
  //     );
  //
  //     double adjustedY = adjustedLocalPosition.dy - adjustedYOffset;
  //     Offset adjustedPosition = Offset(adjustedLocalPosition.dx, adjustedY);
  //
  //     int tappedVerseIndex = _findTappedVerse(adjustedPosition);
  //     if (tappedVerseIndex != -1) {
  //       print('Verse tapped: ${tappedVerseIndex + 1}');
  //       setState(() {
  //         // Deselect all other verses
  //         for (int i = 0; i < _selectedVerses.length; i++) {
  //           if (i != tappedVerseIndex) {
  //             _selectedVerses[i] = false;
  //           }
  //         }
  //         // Select the tapped verse
  //         _selectedVerses[tappedVerseIndex] = !_selectedVerses[tappedVerseIndex];
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (_selectedVerses.isEmpty) {
      _selectedVerses.addAll(List.generate(20, (index) => false));
    }
    return SingleChildScrollView(
      child: SizedBox(
        height: 600,
        child: FractionallySizedBox(
          widthFactor: orientation(context, 1.0, 1.0),
          heightFactor: orientation(context, 1.0, 2.2),
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              final Offset localTouchPosition = details.localPosition;
              final double x = localTouchPosition.dx;
              final double y = localTouchPosition.dy;
              final double minX = 46;
              final double maxX = 1227;
              final double minY = 59;
              final double maxY = 157;
              Offset adjustedPosition = Offset(x, y);
              int tappedVerseIndex;
              if (MediaQuery.of(context).orientation == Orientation.portrait) {
                tappedVerseIndex = _findTappedVerse(adjustedPosition);
              } else {
                tappedVerseIndex = _findTappedVerse(adjustedPosition);
              }
              print('TappedVerse ${tappedVerseIndex + 1}');

              if (tappedVerseIndex != -1) {
                for (int s = 0; s < _selectedVerses.length; s++) {
                  tappedVerseIndex == s
                      ? _selectedVerses[s] = !_selectedVerses[s]
                      : _selectedVerses[s] = false;
                }
                setState(() {});
                // _selectedVerses[tappedVerseIndex]
                // _selectedVerses.;
                // _selectedVerses[tappedVerseIndex] =
                //     !_selectedVerses[tappedVerseIndex];
              }
              if (x >= minX && x <= maxX && y >= minY && y <= maxY) {
                print('x' * 70);
              }
              print('x $x');
              print('y $y');
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints innerConstraints) {
                  return Container(
                    // width: containerWidth,
                    // height: containerHeight,
                    margin: EdgeInsets.symmetric(
                      // vertical: calculateVerticalMargin(innerConstraints),
                      vertical:
                          min(calculateVerticalMargin(innerConstraints), 6),
                      horizontal: orientation(context, 16.0, 24.0),
                    ),
                    child: verses != null
                        ? AspectRatio(
                            aspectRatio: orientation(context, 5.7 / 9, 5.8 / 9),
                            // aspectRatio: orientation(context, 2.20, 1.22),
                            child: Transform.scale(
                              scale: orientation(context, 1.0, 1.0),
                              child: CustomPaint(
                                foregroundPainter: VerseHighlightPainter(
                                  verses: verses ?? [],
                                  selectedVerses: _selectedVerses,
                                ),
                              ),
                            ),
                          )
                        : const CircularProgressIndicator(),
                  );
                }),
                KeyedSubtree(
                  key: _imageKey,
                  child: Image.asset(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    color: ThemeProvider.themeOf(context).id == 'dark'
                        ? Colors.white
                        : null,
                    width: generalController.width,
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // return FractionallySizedBox(
    //   heightFactor: 932.0,
    //   widthFactor: 430.0,
    //   child: GestureDetector(
    //     key: _gestureDetectorKey,
    //     onTapDown: (details) {
    //       final RenderBox imageBox = context.findRenderObject() as RenderBox;
    //       final Offset localTouchPosition = details.localPosition;
    //       final double x = localTouchPosition.dx / imageBox.size.width;
    //       final double y = localTouchPosition.dy / imageBox.size.height;
    //       final double screenWidth = MediaQuery.of(context).size.width;
    //       final double screenHeight = MediaQuery.of(context).size.height;
    //       final double imageWidth = 430.0;
    //       final double imageHeight = 932.0;
    //       final double screenAspectRatio = screenWidth / screenHeight;
    //       final double imageAspectRatio = imageWidth / imageHeight;
    //       double minX, maxX, minY, maxY;
    //       if (screenAspectRatio > imageAspectRatio) {
    //         final double scaledWidth = screenHeight * imageAspectRatio;
    //         final double horizontalPadding = (screenWidth - scaledWidth) / 2;
    //         minX = horizontalPadding + (screenWidth - scaledWidth) / 2;
    //         maxX = horizontalPadding + (screenWidth + scaledWidth) / 2;
    //         minY = 0;
    //         maxY = screenHeight;
    //       } else {
    //         final double scaledHeight = screenWidth / imageAspectRatio;
    //         final double verticalPadding = (screenHeight - scaledHeight) / 2;
    //         minX = 0;
    //         maxX = screenWidth;
    //         minY = verticalPadding + (screenHeight - scaledHeight) / 2;
    //         maxY = verticalPadding + (screenHeight + scaledHeight) / 2;
    //       }
    //       print('x $x | y $y');
    //       print('minX $minX | maxX $maxX');
    //       print('minY $minY | maxY $maxY');
    //
    //       // _updateImagePosition();
    //       // _onTap(details, constraints);
    //       // onTap2(details);
    //     },
    //     child: Container(
    //       alignment: Alignment.center,
    //       child: Stack(
    //         alignment: Alignment.center,
    //         children: [
    //           LayoutBuilder(
    //             builder:
    //                 (BuildContext context, BoxConstraints innerConstraints) {
    //               // double aspectRatio;
    //               // if (MediaQuery.of(context).orientation == Orientation.portrait) {
    //               //   aspectRatio = 5.7 / 9;
    //               // } else {
    //               //   aspectRatio = 6.2 / 9;
    //               // }
    //
    //               // double containerWidth = constraints.maxWidth;
    //               // double containerHeight = containerWidth / aspectRatio;
    //
    //               return Container(
    //                 // width: containerWidth,
    //                 // height: containerHeight,
    //                 margin: EdgeInsets.symmetric(
    //                   // vertical: calculateVerticalMargin(innerConstraints),
    //                   vertical:
    //                       min(calculateVerticalMargin(innerConstraints), 6),
    //                   horizontal: orientation(context, 16.0, 24.0),
    //                 ),
    //                 child: verses != null
    //                     ? AspectRatio(
    //                         aspectRatio: orientation(context, 5.7 / 9, 5.8 / 9),
    //                         // aspectRatio: orientation(context, 2.20, 1.22),
    //                         child: Transform.scale(
    //                           scale: orientation(context, 1.0, 1.0),
    //                           child: CustomPaint(
    //                             foregroundPainter: VerseHighlightPainter(
    //                               verses: verses ?? [],
    //                               selectedVerses: _selectedVerses,
    //                             ),
    //                           ),
    //                         ),
    //                       )
    //                     : const CircularProgressIndicator(),
    //               );
    //             },
    //           ),
    //           KeyedSubtree(
    //             key: _imageKey,
    //             child: Image.asset(
    //               widget.imageUrl,
    //               fit: BoxFit.contain,
    //               color: ThemeProvider.themeOf(context).id == 'dark'
    //                   ? Colors.white
    //                   : null,
    //               width: cubit.width,
    //               alignment: Alignment.center,
    //             ),
    //           ),
    //           Image.asset(
    //             widget.imageUrl2,
    //             fit: BoxFit.contain,
    //             width: cubit.width,
    //             alignment: Alignment.center,
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class VerseHighlightPainter extends CustomPainter {
  final List<Verse> verses;
  final List<bool> selectedVerses;

  VerseHighlightPainter({required this.verses, required this.selectedVerses});

  @override
  void paint(Canvas canvas, Size size) {
    double scaleFactor = size.width / 1260;
    double padding = 0.0; // Adjust the padding value as needed
    double borderRadius = 4.0; // Adjust the border radius as needed

    for (int index = 0; index < selectedVerses.length; index++) {
      if (!selectedVerses[index]) continue;

      // Get all parts of the verse
      List<Verse> verseParts = verses
          .where((v) =>
              v.ayahNumber == verses[index].ayahNumber &&
              v.suraNumber == verses[index].suraNumber)
          .toList();

      for (Verse verse in verseParts) {
        Rect rect = Rect.fromLTRB(
          (verse.minX - padding) * scaleFactor,
          (verse.minY - padding) * scaleFactor,
          (verse.maxX + padding) * scaleFactor,
          (verse.maxY + padding) * scaleFactor,
        );

        RRect roundedRect =
            RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

        Paint paint = Paint()..color = const Color(0xff91a57d).withOpacity(0.4);
        canvas.drawRRect(roundedRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

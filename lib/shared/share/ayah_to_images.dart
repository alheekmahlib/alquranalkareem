import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:alquranalkareem/cubit/cubit.dart';
import 'package:image/image.dart' as img;
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';
import 'dart:io';
import '../../l10n/app_localizations.dart';
import '../widgets/lottie.dart';
import '../widgets/widgets.dart';


ArabicNumbers arabicNumber = ArabicNumbers();
/// Share Ayah
Future<Uint8List> createVerseImage(int verseNumber,
    surahNumber, String verseText) async {
  // Set a fixed canvas width
  const canvasWidth = 960.0;
  // const fixedWidth = canvasWidth;

  final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$verseText',
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.normal,
              fontFamily: 'uthmanic2',
              color: Color(0xff161f07),
            ),
          ),
          TextSpan(
            text: ' ${arabicNumber.convert(verseNumber)}\n',
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.normal,
              fontFamily: 'uthmanic2',
              color: Color(0xff161f07),
            ),
          ),
        ],
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify
  );
  textPainter.layout(maxWidth: 800);

  final padding = 32.0;
  // final imagePadding = 20.0;

  // Load the PNG image
  final pngBytes = await rootBundle.load('assets/share_images/Sorah_name_ba.png');
  final codec = await ui.instantiateImageCodec(pngBytes.buffer.asUint8List());
  final frameInfo = await codec.getNextFrame();
  final pngImage = frameInfo.image;

  // Load the second PNG image
  final pngBytes2 = await rootBundle.load('assets/share_images/surah_name/00$surahNumber.png');
  final codec2 = await ui.instantiateImageCodec(pngBytes2.buffer.asUint8List());
  final frameInfo2 = await codec2.getNextFrame();
  final pngImage2 = frameInfo2.image;

  // Calculate the image sizes and positions
  final imageWidth = pngImage.width.toDouble() / 1.0;
  final imageHeight = pngImage.height.toDouble() / 1.0;
  final imageX = (canvasWidth - imageWidth) / 2; // Center the first image
  final imageY = padding;

  final image2Width = pngImage2.width.toDouble() / 4.0;
  final image2Height = pngImage2.height.toDouble() / 4.0;
  final image2X = (canvasWidth - image2Width) / 2; // Center the second image
  final image2Y = imageHeight + padding - 90; // Adjust this value as needed

  // Set the text position
  final textX = (canvasWidth - textPainter.width) / 2; // Center the text horizontally
  final textY = image2Y + image2Height + padding + 20; // Position the text below the second image

  final pngBytes3 = await rootBundle.load('assets/share_images/Logo_line2.png');
  final codec3 = await ui.instantiateImageCodec(pngBytes3.buffer.asUint8List());
  final frameInfo3 = await codec3.getNextFrame();
  final pngImage3 = frameInfo3.image;

  // Calculate the canvas width and height
  double canvasHeight = textPainter.height + imageHeight + 3 * padding;

  // Calculate the new image sizes and positions
  final image3Width = pngImage3.width.toDouble() / 5.0;
  final image3Height = pngImage3.height.toDouble() / 5.0;
  final image3X = (canvasWidth - image3Width) / 2; // Center the image horizontally

// Calculate the position of the new image to be below the new text
  final image3Y = textPainter.height + padding + 70;

  // Calculate the minimum height
  final minHeight = imageHeight + image2Height + image3Height + 4 * padding;

  // Set the canvas width and height
  canvasHeight = textPainter.height + imageHeight + image2Height + image3Height + 5 * padding;

  // Check if the total height is less than the minimum height
  if (canvasHeight < minHeight) {
    canvasHeight = minHeight;
  }

  // Update the canvas height
  canvasHeight += image3Height + textPainter.height + 3 + padding;

  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder, Rect.fromLTWH(0, 0, canvasWidth, canvasHeight)); // Add Rect to fix the canvas size

  final borderRadius = 25.0;
  final borderPaint = Paint()
    ..color = const Color(0xff91a57d)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 25;

  final backgroundPaint = Paint()..color = const Color(0xfff3efdf);

  final rRect = RRect.fromLTRBR(0, 0, canvasWidth, canvasHeight, Radius.circular(borderRadius));

  canvas.drawRRect(rRect, backgroundPaint);
  canvas.drawRRect(rRect, borderPaint);

  textPainter.paint(canvas, Offset(textX, textY));
  canvas.drawImageRect(
    pngImage,
    Rect.fromLTWH(0, 0, pngImage.width.toDouble(), pngImage.height.toDouble()),
    Rect.fromLTWH(imageX, imageY, imageWidth, imageHeight),
    Paint(),
  );

  canvas.drawImageRect(
    pngImage2,
    Rect.fromLTWH(0, 0, pngImage2.width.toDouble(), pngImage2.height.toDouble()),
    Rect.fromLTWH(image2X, image2Y, image2Width, image2Height),
    Paint(),
  );

  canvas.drawImageRect(
    pngImage3,
    Rect.fromLTWH(0, 0, pngImage3.width.toDouble(), pngImage3.height.toDouble()),
    Rect.fromLTWH(image3X, image3Y, image3Width, image3Height),
    Paint(),
  );


  final picture = pictureRecorder.endRecording();
  final imgWidth = canvasWidth.toInt(); // Use canvasWidth instead of (textPainter.width + 2 * padding)
  final imgHeight = (textPainter.height + imageHeight + image3Height + 4 * padding - 90).toInt();
  final imgScaleFactor = 1; // Increase this value for a higher resolution image
  final imgScaled = await picture.toImage(imgWidth * imgScaleFactor, imgHeight * imgScaleFactor);

  // Convert the image to PNG bytes
  final pngResultBytes = await imgScaled.toByteData(format: ui.ImageByteFormat.png);

  // Decode the PNG bytes to an image object
  final decodedImage = img.decodePng(pngResultBytes!.buffer.asUint8List());

  // Scale down the image to the desired resolution
  final resizedImage = img.copyResize(decodedImage!, width: imgWidth, height: imgHeight);

  // Convert the resized image back to PNG bytes
  final resizedPngBytes = img.encodePng(resizedImage);

  return resizedPngBytes;
}

Future<Uint8List> createVerseWithTranslateImage(BuildContext context, int verseNumber,
    surahNumber, String verseText, textTranslate,
    {double dividerWidth = 2.0,
      double textNextToDividerWidth = 100.0}) async {
  QuranCubit cubit = QuranCubit.get(context);
  // if (textTranslate.split(' ').length > 300) {
  //   customSnackBar(context, "The translation cannot be shared because it is too long.");
  //   // Fluttertoast.showToast(
  //   //     msg: "The translation cannot be shared because it is too long.",
  //   //     toastLength: Toast.LENGTH_LONG,
  //   //     gravity: ToastGravity.BOTTOM,
  //   //     timeInSecForIosWeb: 1,
  //   //     backgroundColor: Colors.red,
  //   //     textColor: Colors.white,
  //   //     fontSize: 16.0);
  //   return Uint8List(0); // Return an empty Uint8List to indicate that no image was created
  // }
  // Set a fixed canvas width
  const canvasWidth = 960.0;
  // const fixedWidth = canvasWidth;

  final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$verseText',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.normal,
              fontFamily: 'uthmanic2',
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : const Color(0xff161f07),
            ),
          ),
          TextSpan(
            text: ' ${arabicNumber.convert(verseNumber)}\n',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.normal,
              fontFamily: 'uthmanic2',
              color: ThemeProvider.themeOf(context).id == 'dark'
                  ? Colors.white
                  : const Color(0xff161f07),
            ),
          ),
        ],
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify
  );
  textPainter.layout(maxWidth: 800);

  final padding = 32.0;
  // final imagePadding = 20.0;

  // Load the PNG image
  final pngBytes = await rootBundle.load('assets/share_images/Sorah_name_ba.png');
  final codec = await ui.instantiateImageCodec(pngBytes.buffer.asUint8List());
  final frameInfo = await codec.getNextFrame();
  final pngImage = frameInfo.image;

  // Load the second PNG image
  final pngBytes2 = await rootBundle.load('assets/share_images/surah_name/00$surahNumber.png');
  final codec2 = await ui.instantiateImageCodec(pngBytes2.buffer.asUint8List());
  final frameInfo2 = await codec2.getNextFrame();
  final pngImage2 = frameInfo2.image;

  // Calculate the image sizes and positions
  final imageWidth = pngImage.width.toDouble() / 1.0;
  final imageHeight = pngImage.height.toDouble() / 1.0;
  final imageX = (canvasWidth - imageWidth) / 2; // Center the first image
  final imageY = padding;

  final image2Width = pngImage2.width.toDouble() / 4.0;
  final image2Height = pngImage2.height.toDouble() / 4.0;
  final image2X = (canvasWidth - image2Width) / 2; // Center the second image
  final image2Y = imageHeight + padding - 90; // Adjust this value as needed

  // Set the text position
  final textX = (canvasWidth - textPainter.width) / 2; // Center the text horizontally
  final textY = image2Y + image2Height + padding + 20; // Position the text below the second image

  final pngBytes3 = await rootBundle.load('assets/share_images/Logo_line2.png');
  final codec3 = await ui.instantiateImageCodec(pngBytes3.buffer.asUint8List());
  final frameInfo3 = await codec3.getNextFrame();
  final pngImage3 = frameInfo3.image;

  // Calculate the canvas width and height
  double canvasHeight = textPainter.height + imageHeight + 3 * padding;

  // Calculate the new image sizes and positions
  final image3Width = pngImage3.width.toDouble() / 5.0;
  final image3Height = pngImage3.height.toDouble() / 5.0;
  final image3X = (canvasWidth - image3Width) / 2; // Center the image horizontally

  List<String> transName = <String>[
    'English',
    'Spanish',
  ];
  String? tafseerName;
  if (cubit.shareTafseerValue == 1) {
    tafseerName = cubit.radioValue != 3 ? null : AppLocalizations.of(context)!.tafSaadiN;
  } else if (cubit.shareTafseerValue == 2) {
    tafseerName = transName[cubit.transIndex!];
  }
  final tafseerNamePainter = TextPainter(
      text: TextSpan(
        text: tafseerName,
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.normal,
            fontFamily: 'kufi',
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Colors.white
                : const Color(0xff161f07),
            backgroundColor: Theme.of(context).dividerColor
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center
  );
  tafseerNamePainter.layout(maxWidth: 800);

  final tafseerNameX = padding + 628;
  final tafseerNameY = textY + textPainter.height + padding - 50;

  // Calculate the position of the new image to be below the new text
  // final image3Y = tafseerNameY + tafseerNamePainter.height + padding - 20;

  // Create the new text painter
  final newTextPainter = TextPainter(
      text: TextSpan(
        text: '$textTranslate\n',
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.normal,
            fontFamily: 'kufi',
            color: ThemeProvider.themeOf(context).id == 'dark'
                ? Colors.white
                : const Color(0xff161f07),
            backgroundColor: const Color(0xff91a57d).withOpacity(.3)
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify
  );
  newTextPainter.layout(maxWidth: 800);

  final newTextX = padding + 50;
  final newTextY = textY + textPainter.height + padding + 20;

  // Calculate the position of the new image to be below the new text
  final image3Y = newTextY + newTextPainter.height + padding - 50;

  // Calculate the minimum height
  final minHeight = imageHeight + image2Height + image3Height + 4 * padding;

  // Set the canvas width and height
  canvasHeight = textPainter.height + newTextPainter.height + imageHeight + image2Height + image3Height + 5 * padding;

  // Check if the total height is less than the minimum height
  if (canvasHeight < minHeight) {
    canvasHeight = minHeight;
  }

  // Update the canvas height
  canvasHeight += image3Height + newTextPainter.height + 3 + padding;

  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder, Rect.fromLTWH(0, 0, canvasWidth, canvasHeight)); // Add Rect to fix the canvas size

  final borderRadius = 25.0;
  final borderPaint = Paint()
    ..color = const Color(0xff91a57d)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 25;

  final backgroundPaint = Paint()..color = const Color(0xfff3efdf);

  final rRect = RRect.fromLTRBR(0, 0, canvasWidth, canvasHeight, Radius.circular(borderRadius));

  canvas.drawRRect(rRect, backgroundPaint);
  canvas.drawRRect(rRect, borderPaint);

  textPainter.paint(canvas, Offset(textX, textY));
  canvas.drawImageRect(
    pngImage,
    Rect.fromLTWH(0, 0, pngImage.width.toDouble(), pngImage.height.toDouble()),
    Rect.fromLTWH(imageX, imageY, imageWidth, imageHeight),
    Paint(),
  );

  canvas.drawImageRect(
    pngImage2,
    Rect.fromLTWH(0, 0, pngImage2.width.toDouble(), pngImage2.height.toDouble()),
    Rect.fromLTWH(image2X, image2Y, image2Width, image2Height),
    Paint(),
  );

  canvas.drawImageRect(
    pngImage3,
    Rect.fromLTWH(0, 0, pngImage3.width.toDouble(), pngImage3.height.toDouble()),
    Rect.fromLTWH(image3X, image3Y, image3Width, image3Height),
    Paint(),
  );

  newTextPainter.paint(canvas, Offset(newTextX, newTextY));
  tafseerNamePainter.paint(canvas, Offset(tafseerNameX, tafseerNameY));

  final picture = pictureRecorder.endRecording();
  final imgWidth = canvasWidth.toInt(); // Use canvasWidth instead of (textPainter.width + 2 * padding)
  final imgHeight = (textPainter.height + newTextPainter.height + imageHeight + image3Height + 4 * padding).toInt();
  final imgScaleFactor = 1; // Increase this value for a higher resolution image
  final imgScaled = await picture.toImage(imgWidth * imgScaleFactor, imgHeight * imgScaleFactor);

  // Convert the image to PNG bytes
  final pngResultBytes = await imgScaled.toByteData(format: ui.ImageByteFormat.png);

  // Decode the PNG bytes to an image object
  final decodedImage = img.decodePng(pngResultBytes!.buffer.asUint8List());

  // Scale down the image to the desired resolution
  final resizedImage = img.copyResize(decodedImage!, width: imgWidth, height: imgHeight);

  // Convert the resized image back to PNG bytes
  final resizedPngBytes = img.encodePng(resizedImage);

  return resizedPngBytes;
}

shareText(String verseText, surahName, int verseNumber) {
  Share.share(
      '﴿$verseText﴾ '
          '[$surahName-'
          '$verseNumber]',
      subject: '$surahName');
}

Future<void> shareVerseWithTranslate(BuildContext context, int verseNumber,
    surahNumber, String verseText, textTranslate) async {
  final imageData = await createVerseWithTranslateImage(context, verseNumber,
      surahNumber, verseText, textTranslate);

  // Save the image to a temporary directory
  final directory = await getTemporaryDirectory();
  final filename = 'verse_${DateTime.now().millisecondsSinceEpoch}.png';
  final imagePath = '${directory.path}/$filename';
  final imageFile = File(imagePath);
  await imageFile.writeAsBytes(imageData);

  if (imageFile.existsSync()) {
    await Share.shareXFiles([XFile((imagePath))], text: AppLocalizations.of(context)!.appName);
  } else {
    print('Failed to save and share image');
  }
}

Future<void> shareVerse(BuildContext context, int verseNumber,
    surahNumber, String verseText) async {
  final imageData2 = await createVerseImage(verseNumber,
      surahNumber, verseText);

  // Save the image to a temporary directory
  final directory = await getTemporaryDirectory();
  final filename = 'verse_${DateTime.now().millisecondsSinceEpoch}.png';
  final imagePath = '${directory.path}/$filename';
  final imageFile = File(imagePath);
  await imageFile.writeAsBytes(imageData2);

  if (imageFile.existsSync()) {
    await Share.shareXFiles([XFile((imagePath))], text: AppLocalizations.of(context)!.appName);
  } else {
    print('Failed to save and share image');
  }
}

void showVerseOptionsBottomSheet(BuildContext context,
    int verseNumber, surahNumber, String verseText,
    textTranslate, surahName) async {
  // Call createVerseWithTranslateImage and get the image data
  Uint8List imageData = await createVerseWithTranslateImage(context, verseNumber, surahNumber, verseText, textTranslate);
  Uint8List imageData2 = await createVerseImage(verseNumber, surahNumber, verseText);

  allModalBottomSheet(
    context,
    MediaQuery.of(context).size.height / 1/2,
    MediaQuery.of(context).size.width,
    Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                          width: 2,
                          color: Theme.of(context).dividerColor)),
                  child: Icon(
                    Icons.close_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: shareLottie(120.0, 120.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: orientation(context, MediaQuery.of(context).size.width * .6, MediaQuery.of(context).size.width / 1/3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context)!.shareText,
                          style: TextStyle(
                              color: ThemeProvider.themeOf(context).id ==
                                  'dark'
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).primaryColorDark,
                              fontSize: 16,
                              fontFamily: 'kufi'
                          ),),
                        Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: MediaQuery.of(context).size.width / 1/3,
                          color: Theme.of(context).dividerColor,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    // height: 60,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor.withOpacity(.3),
                        borderRadius: const BorderRadius.all(Radius.circular(4))
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.text_fields,
                          color: Theme.of(context).colorScheme.surface,
                          size: 24,
                        ),
                        SizedBox(
                          width: orientation(context, MediaQuery.of(context).size.width * .7, MediaQuery.of(context).size.width / 1/3),
                          child: Text("﴿ $verseText ﴾",
                            style: TextStyle(
                                color: ThemeProvider.themeOf(context).id ==
                                    'dark'
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(context).primaryColorDark,
                                fontSize: 16,
                                fontFamily: 'uthmanic2'
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    shareText(verseText, surahName, verseNumber);
                    Navigator.pop(context);
                  },
                ),
                Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  width: MediaQuery.of(context).size.width * .3,
                  color: Theme.of(context).dividerColor,
                ),
                Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1/2,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(AppLocalizations.of(context)!.shareImage,
                              style: TextStyle(
                                  color: ThemeProvider.themeOf(context).id ==
                                      'dark'
                                      ? Theme.of(context).colorScheme.surface
                                      : Theme.of(context).primaryColorDark,
                                  fontSize: 16,
                                  fontFamily: 'kufi'
                              ),),
                          ),
                          GestureDetector(
                            child: Container(
                              // width: MediaQuery.of(context).size.width * .4,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              margin: const EdgeInsets.only(top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).dividerColor.withOpacity(.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(4))
                              ),
                              child: Image.memory(imageData2,
                                // height: 150,
                                // width: 150,
                              ),
                            ),
                            onTap: () {
                              shareVerse(
                                  context, verseNumber, surahNumber, verseText
                              );
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1/2,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1/3,
                              child: Text(AppLocalizations.of(context)!.shareImageWTrans,
                                style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                        'dark'
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context).primaryColorDark,
                                    fontSize: 16,
                                    fontFamily: 'kufi'
                                ),),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              // width: MediaQuery.of(context).size.width * .4,
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              margin: const EdgeInsets.only(top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).dividerColor.withOpacity(.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(4))
                              ),
                              child: Image.memory(imageData,
                                // height: 150,
                                // width: 150,
                              ),
                            ),
                            onTap: () {
                              shareVerseWithTranslate(
                                  context, verseNumber, surahNumber, verseText, textTranslate
                              );
                              Navigator.pop(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1/3,
                              child: Text(AppLocalizations.of(context)!.shareTrans,
                                style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                        'dark'
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context).primaryColorDark,
                                    fontSize: 12,
                                    fontFamily: 'kufi'
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
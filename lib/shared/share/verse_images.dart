import 'package:flutter/material.dart';


class VerseImage extends StatelessWidget {
  final String surahName;
  final int verseNumber;
  final String verseText;
  final GlobalKey repaintBoundaryKey;

  VerseImage({required this.surahName, required this.verseNumber, required this.verseText, required this.repaintBoundaryKey});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: Container(
        width: 500,
        color: const Color(0xfff3efdf),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              surahName,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontFamily: 'uthmanic2',
                color: Color(0xff161f07),
              ),
            ),
            Text(
              verseText,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontFamily: 'uthmanic2',
                color: Color(0xff161f07),
              ),
            ),
            Text(
              verseNumber.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontFamily: 'uthmanic2',
                color: Color(0xff161f07),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

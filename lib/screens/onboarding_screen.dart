import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../home_page.dart';
import '../shared/widgets/widgets.dart';



class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  int? pageNumber;


  List<String> images = <String>[
    'assets/onboarding/onboarding_p.png',
    'assets/onboarding/onboarding_p2.png',
    'assets/onboarding/onboarding_p3.png',
    'assets/onboarding/onboarding_p4.png',
  ];

  List<String> imagesL = <String>[
    'assets/onboarding/onboarding_l.png',
    'assets/onboarding/onboarding_l2.png',
    'assets/onboarding/onboarding_l3.png',
    'assets/onboarding/onboarding_l4.png',
  ];

  List<String> imagesD = <String>[
    'assets/onboarding/onboarding_d.png',
    'assets/onboarding/onboarding_d2.png',
    'assets/onboarding/onboarding_d3.png',
    'assets/onboarding/onboarding_d4.png',
  ];


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: const Color(0xfff3efdf),
          body: Padding(
            padding: const EdgeInsets.only(
                right: 16.0, left: 16.0, top: 56.0, bottom: 32.0),
            child: (Platform.isMacOS || Platform.isWindows || Platform.isLinux)
                ? Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 56.0,
                        ),
                        child: PageView.builder(
                            controller: controller,
                            itemCount: imagesD.length,
                            onPageChanged: (page) {
                              setState(() {
                                pageNumber = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Center(
                                child: Image.asset(
                                  imagesD[index],
                                  // scale: 6,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              );
                            }),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SmoothPageIndicator(
                          textDirection: TextDirection.rtl,
                          controller: controller,
                          count: imagesD.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 13,
                            paintStyle: PaintingStyle.fill,
                            dotColor: const Color(0xff39412a).withOpacity(.5),
                            activeDotColor: const Color(0xff232c13),
                            // strokeWidth: 5,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          child: ClipPath(
                            clipper: const ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xff91a57d).withOpacity(.2),
                                  border: Border.symmetric(
                                      vertical: BorderSide(
                                          color: const Color(0xff91a57d),
                                          width: 2))),
                              child: Text(
                                'تخطي',
                                style: TextStyle(
                                  color: const Color(0xff91a57d),
                                  fontSize: 18.0,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0),
                          onPressed: () {
                            Get.off(() => HomePage());
                          },
                        ),
                      ),
                      pageNumber == 3
                          ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: const Color(0xff91a57d),),
                              child: Center(
                                child: Text(
                                    'أبدأ',
                                    style: TextStyle(
                                        fontFamily: 'kufi',
                                        fontSize: 20,
                                        color: Theme.of(context).canvasColor
                                    )
                                ),
                              ),

                            ),
                            onTap: () {
                              if (pageNumber == 3) {
                                Get.off(() => HomePage());
                              } else {
                                controller.animateToPage(controller.page!.toInt() + 1,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn);
                              }
                            },
                          ),
                        ),
                      )
                          : Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            child: Container(
                              height: 50,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: const Color(0xff91a57d),),
                              child: Icon(
                                Icons.arrow_forward,
                                color: const Color(0xfff3efdf),
                              ),
                            ),
                            onTap: () {
                              controller.animateToPage(controller.page!.toInt() + 1,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 56.0,
                        ),
                        child: PageView.builder(
                            controller: controller,
                            itemCount: images.length,
                            onPageChanged: (page) {
                              setState(() {
                                pageNumber = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ListView(
                                    children: [
                                      orientation(context,
                                          Center(
                                        child: Image.asset(
                                          images[index],
                                          width: orientation(context,
                                              MediaQuery.of(context).size.width *
                                                  3 /
                                                  4,
                                              MediaQuery.of(context).size.width),
                                        ),
                                      ),
                                          Center(
                                        child: Image.asset(
                                          imagesL[index],
                                          width: MediaQuery.of(context).size.width / 1/2,
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SmoothPageIndicator(
                          textDirection: TextDirection.rtl,
                          controller: controller,
                          count: images.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 13,
                            paintStyle: PaintingStyle.fill,
                            dotColor: const Color(0xff39412a).withOpacity(.5),
                            activeDotColor: const Color(0xff232c13),
                            // strokeWidth: 5,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          child: ClipPath(
                            clipper: const ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xff91a57d).withOpacity(.2),
                                  border: Border.symmetric(
                                      vertical: BorderSide(
                                          color: const Color(0xff91a57d),
                                          width: 2))),
                              child: Text(
                                'تخطي',
                                style: TextStyle(
                                  color: const Color(0xff91a57d),
                                  fontSize: 18.0,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0),
                          onPressed: () {
                            Get.off(() => HomePage());
                          },
                        ),
                      ),
                      pageNumber == 3
                          ? Align(
                        alignment: Alignment.bottomLeft,
                            child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          child: Container(
                            height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: const Color(0xff91a57d),),
                              child: Center(
                                child: Text(
                                  'أبدأ',
                                  style: TextStyle(
                                    fontFamily: 'kufi',
                                    fontSize: 20,
                                    color: Theme.of(context).canvasColor
                                  )
                                ),
                              ),

                          ),
                          onTap: () {
                            if (pageNumber == 3) {
                              Get.off(() => HomePage());
                            } else {
                              controller.animateToPage(controller.page!.toInt() + 1,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            }
                          },
                        ),
                      ),
                          )
                          : Align(
                        alignment: Alignment.bottomLeft,
                            child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          child: Container(
                            height: 50,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: const Color(0xff91a57d),),
                              child: Icon(
                                Icons.arrow_forward,
                                color: const Color(0xfff3efdf),
                              ),
                          ),
                          onTap: () {
                            controller.animateToPage(controller.page!.toInt() + 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                          },
                        ),
                      ),
                          ),
                    ],
                  ),
          ),
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: FloatingActionButton(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(8))),
          //     backgroundColor: const Color(0xff91a57d),
          //     child: Icon(
          //       Icons.arrow_forward,
          //       color: const Color(0xfff3efdf),
          //     ),
          //     onPressed: () {
          //       if (controller.page == 3) {
          //         Get.off(() => HomePage());
          //       } else {
          //         controller.animateToPage(controller.page!.toInt() + 1,
          //             duration: Duration(milliseconds: 400),
          //             curve: Curves.easeIn);
          //       }
          //     },
          //   ),
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked
      ),
    );
  }
}

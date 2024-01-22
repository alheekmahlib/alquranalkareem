import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';

import '/core/services/languages/dependency_inj.dart' as dep;
// import 'quran_page/data/data_client.dart';
// import 'quran_page/data/tafseer_data_client.dart';
import 'core/services/services_locator.dart';
import 'myApp.dart';

// void main() async {
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   await ServicesLocator().init();
//   runApp(MyApp(theme: ThemeData.light()));
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await dep.init();
  runApp(LoadingScreen());
  initializeApp().then((_) {
    runApp(MyApp(
      languages: languages,
    ));
  });
}

// late AudioPlayerHandler audioHandler;
Future<void> initializeApp() async {
  // DataBaseClient dataBaseClient = DataBaseClient.instance;
  // dataBaseClient.initDatabase();
  // TafseerDataBaseClient tafseerDataBaseClient = TafseerDataBaseClient.instance;
  // tafseerDataBaseClient.initDatabase();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 0));
  FlutterNativeSplash.remove();
  await ServicesLocator().init();
  // audioHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
  //     androidNotificationChannelName: 'Audio playback',
  //     androidNotificationOngoing: true,
  //   ),
  // );
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xfff3efdf),
        body: Center(
            child: Lottie.asset('assets/lottie/loading.json',
                width: 150, height: 150)),
      ),
    );
  }
}

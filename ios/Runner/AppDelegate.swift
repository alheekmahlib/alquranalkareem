import UIKit
import Flutter
import workmanager
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*20))
        WorkmanagerPlugin.register(with: self.registrar(forPlugin: "com.alheekmah.alquranalkareem.alquranalkareem.dailyPrayerNotification")!)
        WorkmanagerPlugin.register(with: self.registrar(forPlugin: "com.alheekmah.alquranalkareem.alquranalkareem.hijriWidget")!)
        WorkmanagerPlugin.register(with: self.registrar(forPlugin: "com.alheekmah.alquranalkareem.alquranalkareem.currentPrayerTime")!)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)

//    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
//      GeneratedPluginRegistrant.register(with: registry)
//    // In AppDelegate.application method
////    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "com.alheekmah.alquranalkareem.alquranalkareem.dailyPrayerNotification")
////    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "com.alheekmah.alquranalkareem.alquranalkareem.hijriWidget")
////    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "com.alheekmah.alquranalkareem.alquranalkareem.currentPrayerTime")
//
//    // Register a periodic task in iOS 13+
////    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "com.alheekmah.alquranalkareem.alquranalkareem.dailyPrayerNotification", frequency: NSNumber(value: 20 * 60))
////    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "com.alheekmah.alquranalkareem.alquranalkareem.hijriWidget", frequency: NSNumber(value: 20 * 60))
////    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "com.alheekmah.alquranalkareem.alquranalkareem.currentPrayerTime", frequency: NSNumber(value: 20 * 60))
//
//    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         completionHandler(.alert) // shows banner even if app is in foreground
        }
}

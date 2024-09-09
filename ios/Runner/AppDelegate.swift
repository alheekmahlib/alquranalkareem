import UIKit
import Flutter
// awesome_notifications
import awesome_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // awsome_notifications
      // This function registers the desired plugins to be used within a notification background action
        SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
            SwiftAwesomeNotificationsPlugin.register(
              with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
        }
      // awsome_notifications
    if #available(iOS 10.0, *) {
       UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
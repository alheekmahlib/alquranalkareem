import Cocoa
import FlutterMacOS
import WidgetKit

class MainFlutterWindow: NSWindow {
  private var widgetChannel: FlutterMethodChannel?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // MethodChannel for macOS widget UserDefaults
    let channel = FlutterMethodChannel(
      name: "com.alheekmah.quran_widget/macos_widget",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    channel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "saveWidgetData":
        guard let args = call.arguments as? [String: Any],
              let key = args["key"] as? String,
              let groupId = args["groupId"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing key or groupId", details: nil))
          return
        }
        guard let defaults = UserDefaults(suiteName: groupId) else {
          result(FlutterError(code: "NO_SUITE", message: "Cannot open suite \(groupId)", details: nil))
          return
        }
        defaults.set(args["value"], forKey: key)
        defaults.synchronize()
        result(nil)

      case "updateWidget":
        if #available(macOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
    self.widgetChannel = channel

    super.awakeFromNib()
    RegisterGeneratedPlugins(registry: flutterViewController)
  }
}

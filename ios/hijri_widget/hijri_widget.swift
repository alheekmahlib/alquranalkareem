import WidgetKit
import SwiftUI

@available(iOS 14.0, *)
struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> HijriWidgetEntry {
        HijriWidgetEntry(date: Date(), hijriDateImage: "No screenshot available", displaySize: context.displaySize)
    }

    func getSnapshot(in context: Context, completion: @escaping (HijriWidgetEntry) -> ()) {
        let entry: HijriWidgetEntry
        if context.isPreview {
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: "group.com.alheekmah.alquranalkareem.widget")
            let filename = userDefaults?.string(forKey: "hijriDateImage") ?? "No screenshot available"
            entry = HijriWidgetEntry(date: Date(), hijriDateImage: filename, displaySize: context.displaySize)
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct HijriWidgetEntry: TimelineEntry {
    let date: Date
    let hijriDateImage: String
    let displaySize: CGSize
}

@available(iOS 14.0, *)
struct HijriWidgetEntryView: View {
    var entry: Provider.Entry

    var ChartImage: some View {
        if let uiImage = UIImage(contentsOfFile: entry.hijriDateImage) {
            return AnyView(
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: entry.displaySize.width, height: entry.displaySize.height)
            )
        } else {
            print("The image file could not be loaded")
            return AnyView(EmptyView())
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "#404C6E")
            ChartImage
        }
        .frame(width: entry.displaySize.width, height: entry.displaySize.height)
    }
}

@available(iOS 14.0, *)
struct HijriWidget: Widget {
    let kind: String = "NewsWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HijriWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

@available(iOS 14.0, *)
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0xff00) >> 8) / 255.0
        let b = Double(rgbValue & 0xff) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

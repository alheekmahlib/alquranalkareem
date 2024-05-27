import WidgetKit
import SwiftUI

@available(iOS 14.0, *)
struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> PrayerWidgetEntry {
        PrayerWidgetEntry(date: Date(), prayerDateImage: "No screenshot available", remainingTime: "Calculating...",  displaySize: context.displaySize)
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerWidgetEntry) -> ()) {
            let entry = createEntry()
            completion(entry)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            var entries: [PrayerWidgetEntry] = []

            // Generate a timeline consisting of entries updated every second
            for secondOffset in 0 ..< 60 {
                let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: Date())!
                let entry = createEntry(date: entryDate)
                entries.append(entry)
            }

            // Schedule the next refresh after the last entry
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }

    func createEntry(date: Date = Date()) -> PrayerWidgetEntry {
        let userDefaults = UserDefaults(suiteName: "group.com.alheekmah.alquranalkareem.widget")
        let filename = userDefaults?.string(forKey: "prayerDateImage") ?? "No screenshot available"
        let remainingTime = userDefaults?.string(forKey: "remainingTime") ?? "Calculating..."
        return PrayerWidgetEntry(date: Date(), prayerDateImage: filename, remainingTime: remainingTime, displaySize: CGSize(width: 300, height: 300))
    }
}

struct PrayerWidgetEntry: TimelineEntry {
    let date: Date
    let prayerDateImage: String
    let remainingTime: String
    let displaySize: CGSize
}

@available(iOS 14.0, *)
struct PrayerWidgetEntryView: View {
    var entry: Provider.Entry

    var ChartImage: some View {
        if let uiImage = UIImage(contentsOfFile: entry.prayerDateImage) {
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
                ChartImage
                Text("\(entry.remainingTime)")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
        }
        .frame(width: entry.displaySize.width, height: entry.displaySize.height)
    }
}

@available(iOS 14.0, *)
struct PrayerWidget: Widget {
    let kind: String = "prayerWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PrayerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("أوقات الصلاة")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

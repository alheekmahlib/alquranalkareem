import WidgetKit
import SwiftUI

@available(iOS 14.0, *)
struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> PrayerWidgetEntry {
        PrayerWidgetEntry(date: Date(), prayerDateImage: "No screenshot available", nextPrayerDate: Date().addingTimeInterval(3600), displaySize: context.displaySize)
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerWidgetEntry) -> ()) {
        let entry = createEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = createEntry()

        // Schedule the next refresh after 1 minute
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }

    func createEntry(date: Date = Date()) -> PrayerWidgetEntry {
        let userDefaults = UserDefaults(suiteName: "group.com.alheekmah.alquranalkareem.widget")
        let filename = userDefaults?.string(forKey: "prayerDateImage") ?? "No screenshot available"

        // Get the next prayer time from UserDefaults
        let nextPrayerTimeString = userDefaults?.string(forKey: "nextPrayerTime") ?? "2024-01-01T00:00:00.000"
        print("Next prayer time string from UserDefaults: \(nextPrayerTimeString)")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone.current // Use the user's current time zone

        guard let nextPrayerDate = dateFormatter.date(from: nextPrayerTimeString) else {
            print("Failed to parse next prayer date, using fallback date")
            return PrayerWidgetEntry(date: date, prayerDateImage: filename, nextPrayerDate: Date().addingTimeInterval(3600), displaySize: CGSize(width: 300, height: 300))
        }

        // Log the parsed date to verify correctness
        print("Parsed next prayer date: \(nextPrayerDate)")

        return PrayerWidgetEntry(date: date, prayerDateImage: filename, nextPrayerDate: nextPrayerDate, displaySize: CGSize(width: 300, height: 300))
    }
}

struct PrayerWidgetEntry: TimelineEntry {
    let date: Date
    let prayerDateImage: String
    let nextPrayerDate: Date
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
            Color("BlueColor")
                    .aspectRatio(contentMode: .fill)
                ChartImage
                Text(entry.nextPrayerDate, style: .timer)
                    .foregroundColor(.white)
                    .offset(x: 78, y: 8)
                    .frame(width: 80, alignment: .center)
                    .multilineTextAlignment(.center)
            }
            .frame(width: entry.displaySize.width, height:
                    entry.displaySize.height)
            .widgetBackground(backgroundView: Color.clear)
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

extension View {
    func widgetBackground(backgroundView: some View) -> some View {
        if #available(watchOS 10.0, iOSApplicationExtension 17.0, iOS 17.0, macOSApplicationExtension 14.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

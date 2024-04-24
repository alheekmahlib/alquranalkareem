//
//  hijri_widget.swift
//  hijri_widget
//
//  Created by Hawazen Mahmood on 4/20/24.
//


import WidgetKit
import SwiftUI

// TimelineProvider has three methods
@available(iOS 14.0, *)
struct Provider: TimelineProvider {

// Placeholder is used as a placeholder when the widget is first displayed
    func placeholder(in context: Context) -> HijriWidgetEntry {
//      Add some placeholder title and description, and get the current date
        HijriWidgetEntry(date: Date(), hijriDateImage: "No screenshot available",  displaySize: context.displaySize)
    }

// Snapshot entry represents the current time and state
    func getSnapshot(in context: Context, completion: @escaping (HijriWidgetEntry) -> ()) {
      let entry: HijriWidgetEntry
      if context.isPreview{
        entry = placeholder(in: context)
      }
      else{
        //      Get the data from the user defaults to display
        let userDefaults = UserDefaults(suiteName: "group.com.alheekmah.alquranalkareem.widget")
        let filename = userDefaults?.string(forKey: "hijriDateImage") ?? "No screenshot available"
        print(filename)
        entry = HijriWidgetEntry(date: Date(), hijriDateImage: filename,  displaySize: context.displaySize)
      }
        completion(entry)
    }

//    getTimeline is called for the current and optionally future times to update the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//      This just uses the snapshot function you defined earlier
      getSnapshot(in: context) { (entry) in
// atEnd policy tells widgetkit to request a new entry after the date has passed
        let timeline = Timeline(entries: [entry], policy: .atEnd)
                  completion(timeline)
              }
    }
}

// The date and any data you want to pass into your app must conform to TimelineEntry
struct HijriWidgetEntry: TimelineEntry {
    let date: Date
    let hijriDateImage: String
    let displaySize: CGSize
}

//View that holds the contents of the widget
@available(iOS 14.0, *)
struct HijriWidgetEntryView : View {
    var entry: Provider.Entry
    
    var ChartImage: some View {
            if let uiImage = UIImage(contentsOfFile: entry.hijriDateImage) {
                let image = Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: entry.displaySize.width, height: entry.displaySize.height, alignment: .center)
                return AnyView(image)
            }
            print("The image file could not be loaded")
            return AnyView(EmptyView())
        }


    var body: some View {
        ChartImage
    }
}



@available(iOS 14.0, *)
struct HijriWidget: Widget {
//  Identifier for the widget
    let kind: String = "NewsWidgets"

// Configuration for the widget
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HijriWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//struct NewsWidgets_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsWidgetsEntryView(entry: NewsArticleEntry(date: Date(), title: "Preview Title", description: "Preview description", filename: "No Screenshot available"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

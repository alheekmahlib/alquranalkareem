//
//  HomeWidgetExample.swift
//  HomeWidgetExample
//
//  Created by Hawazen Mahmood on 3/27/23.
//

import WidgetKit
import SwiftUI



typealias SwiftUIColor = SwiftUI.Color
private let widgetGroupId = "group.com.alheekmah.alquranalkareem.widget"


class WidgetData: ObservableObject {
    @Published var zikr: String

    init(zikr: String) {
        self.zikr = zikr
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ZikerEntry {
        ZikerEntry(date: Date(), zikr: "Placeholder Zikr")
    }

    func getSnapshot(in context: Context, completion: @escaping (ZikerEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        let entry = ZikerEntry(date: Date(), zikr: data?.string(forKey: "zikr") ?? "بِسـمِ اللهِ الذي لا يَضُـرُّ مَعَ اسمِـهِ شَيءٌ في الأرْضِ وَلا في السّمـاءِ وَهـوَ السّمـيعُ العَلـيم.")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}


struct ZikerEntry: TimelineEntry {
    let date: Date
    let zikr: String
}

extension SwiftUIColor {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000ff) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

struct ZikerWidgetEntryView: View {
    @ObservedObject var widgetData: WidgetData

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack(alignment: .center) {
                Image("ios_widget")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .center)
                
                Text(widgetData.zikr)
                    .font(.custom("Kufam-Regular", size: height * 0.04))
                    .foregroundColor(SwiftUIColor(.label))
                    .environment(\.layoutDirection, .rightToLeft)
                    .lineSpacing(10)
                    .frame(width: width * 0.65, height: height * 0.6, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(SwiftUIColor(hex: "f3efdf"))
            .cornerRadius(10)
        }
    }
}

//@main
struct ZikerWidget: Widget {
    let kind: String = "HomeWidgetExample"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ZikerWidgetEntryView(widgetData: WidgetData(zikr: entry.zikr))
        }
        .configurationDisplayName("الأذكار")
        .description("تعرض لك هذه الخاصية مجموعة من الأذكار من كتاب حصن المسلم")
        .supportedFamilies([.systemLarge])
    }
}

struct ZikerWidget_Previews: PreviewProvider {
    static var previews: some View {
        ZikerWidgetEntryView(widgetData: WidgetData(zikr: "Example Zikr"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

func arabicNumber(from numberString: String) -> String {
    let arabicLocale = Locale(identifier: "ar")
    let formatter = NumberFormatter()
    formatter.locale = arabicLocale
    if let number = formatter.number(from: numberString) {
        if let arabicNumberString = formatter.string(from: number) {
            return arabicNumberString
        }
    }
    return numberString
}



// Add HijriDateEntry struct
struct HijriDateEntry: TimelineEntry {
    let date: Date
    let hijriDay: String
    let hijriMonth: String
    let hijriYear: String
}

class HijriWidgetData: ObservableObject {
    @Published var hijriDay: String
    @Published var hijriMonth: String
    @Published var hijriYear: String

    init(hijriDay: String, hijriMonth: String, hijriYear: String) {
        self.hijriDay = hijriDay
        self.hijriMonth = hijriMonth
        self.hijriYear = hijriYear
    }
}

// Create a new HijriDateProvider
struct HijriDateProvider: TimelineProvider {
    typealias Entry = HijriDateEntry

    func placeholder(in context: Context) -> HijriDateEntry {
        HijriDateEntry(date: Date(), hijriDay: "Placeholder Hijri Date", hijriMonth: "Placeholder Hijri Date", hijriYear: "Placeholder Hijri Date")
    }

    func getSnapshot(in context: Context, completion: @escaping (HijriDateEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        let entry = HijriDateEntry(date: Date(), hijriDay: data?.string(forKey: "hijriDay") ?? "1", hijriMonth: data?.string(forKey: "hijriMonth") ?? "1", hijriYear: data?.string(forKey: "hijriYear") ?? "1444")
//        let entry2 = HijriDateEntry(date: Date(), hijriMonth: data?.string(forKey: "hijriMoth") ?? "No Hijri Month Set")
//        let entry3 = HijriDateEntry(date: Date(), hijriYear: data?.string(forKey: "hijriYear") ?? "No Hijri Year Set")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct CustomRoundedRectangle: SwiftUI.Shape {
    var topLeft: CGFloat
    var bottomRight: CGFloat
    
    func path(in rect: CGRect) -> SwiftUI.Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft), radius: topLeft, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - bottomRight, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRight, y: rect.minY + bottomRight), radius: bottomRight, startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight), radius: bottomRight, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + topLeft, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.maxY - topLeft), radius: topLeft, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.closeSubpath()
        
        return path
    }
}

// Create the HijriDateWidgetEntryView
struct HijriDateWidgetEntryView: View {
    @ObservedObject var hijriWidgetData: HijriWidgetData

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            ZStack {
                HStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(SwiftUIColor(hex: "91a57d")).opacity(0.3)
                            .frame(width: 100, height: .infinity)
                        
                        Image("hijri_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 70)
                            .offset(x: 0, y: 0)
                    }
                }
                
                HStack {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(SwiftUIColor(hex: "91a57d"))
                            .frame(width: width * 0.35, height: 35)
                        
                        Text(arabicNumber(from: hijriWidgetData.hijriDay))
                            .font(.custom("Kufam-Regular", size: height * 0.25))
                            .foregroundColor(SwiftUIColor(hex: "606c38"))
                            .environment(\.layoutDirection, .rightToLeft)
                            .lineSpacing(10)
                            .background(
                                Text(arabicNumber(from: hijriWidgetData.hijriDay))
                                    .font(.custom("Kufam-Regular", size: height * 0.25))
                                    .environment(\.layoutDirection, .rightToLeft)
                                    .lineSpacing(10)
                                    .foregroundColor(SwiftUIColor(hex: "f3efdf"))
                                    .offset(x: 2, y: 2)
                            )
                    }
                    Spacer()
                }
                .offset(x: 0, y: height * 0.2)
                
                Image(hijriWidgetData.hijriMonth)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70)
                    .offset(x: width * -0.1, y: 0)
                
                Text("\(arabicNumber(from: hijriWidgetData.hijriYear)) هـ")
                    .font(.custom("Kufam-Regular", size: height * 0.15))
                    .foregroundColor(SwiftUIColor(hex: "606c38"))
                    .environment(\.layoutDirection, .rightToLeft)
                    .lineSpacing(10)
                    .offset(x: width * -0.32, y: height * -0.21)
                    .background(
                        Text("\(arabicNumber(from: hijriWidgetData.hijriYear)) هـ")
                            .font(.custom("Kufam-Regular", size: height * 0.15))
                            .environment(\.layoutDirection, .rightToLeft)
                            .lineSpacing(10)
                            .foregroundColor(SwiftUIColor(hex: "91a57d"))
                            .opacity(0.5)
                            .offset(x: width * -0.33, y: height * -0.19)
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(SwiftUIColor(hex: "f3efdf"))
            .cornerRadius(10)
        }
    }

}

// Add the HijriDateWidget
//@main
struct HijriDateWidget: Widget {
    let kind: String = "HijriDateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HijriDateProvider()) { entry in
            HijriDateWidgetEntryView(hijriWidgetData: HijriWidgetData(hijriDay: entry.hijriDay, hijriMonth: entry.hijriMonth, hijriYear: entry.hijriYear))
        }
        .configurationDisplayName("التاريخ الهجري")
        .description("تمكنك هذه الخاصية من عرض التاريخ الهجري")
        .supportedFamilies([.systemMedium])
    }
}

// Update the ZikerWidget to only support the Ziker
//@main
//struct ZikerWidget: Widget {
//    let kind: String = "ZikerWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            ZikerWidgetEntryView(widgetData: WidgetData(zikr: entry.zikr))
//        }
//        .configurationDisplayName("Ziker Widget")
//        .description("This is a widget for displaying Ziker.")
//        .supportedFamilies([.systemLarge])
//    }
//}
//
//struct ZikerWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        ZikerWidgetEntryView(widgetData: WidgetData(zikr: "Example Zikr"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}


struct HijriDateWidget_Previews: PreviewProvider {
    static var previews: some View {
        HijriDateWidgetEntryView(hijriWidgetData: HijriWidgetData(hijriDay: "Example Hijri Date", hijriMonth: "Example Hijri Date", hijriYear: "Example Hijri Date"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


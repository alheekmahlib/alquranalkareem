//
//  quran_widget.swift
//  quran_widget
//
//  التقويم الهجري + تقدم القراءة - Widget
//

import WidgetKit
import SwiftUI

// MARK: - Data Model

struct QuranWidgetData {
    let hijriDay: Int
    let hijriMonth: Int
    let hijriYear: Int
    let hijriMonthName: String
    let gregorianDate: String
    let lengthOfMonth: Int
    let lastReadPage: Int
    let lastSurahNumber: Int
    let totalPages: Int
    let readingProgress: Int
    let theme: String
    let lastRead: String
    let page: String
    let languageCode: String
    let useEnglishNumbers: Bool

    /// هل اللغة من اليمين لليسار
    var isRTL: Bool {
        ["ar", "ur", "ku"].contains(languageCode)
    }

    /// تحويل الأرقام حسب لغة التطبيق
    func num(_ number: Int) -> String {
        let str = "\(number)"
        if useEnglishNumbers { return str }

        let base: Int
        switch languageCode {
        case "ar", "ku": base = 0x0660
        case "bn": base = 0x09E6
        case "ur": base = 0x06F0
        default: return str
        }

        return String(str.map { ch in
            if let v = ch.asciiValue, v >= 0x30, v <= 0x39 {
                return Character(UnicodeScalar(base + Int(v) - 0x30)!)
            }
            return ch
        })
    }

    static let placeholder = QuranWidgetData(
        hijriDay: 16,
        hijriMonth: 9,
        hijriYear: 1447,
        hijriMonthName: "9",
        gregorianDate: "6 March",
        lengthOfMonth: 30,
        lastReadPage: 106,
        lastSurahNumber: 4,
        totalPages: 604,
        readingProgress: 18,
        theme: "AppTheme.green",
        lastRead: "آخر قراءة",
        page: "صفحة",
        languageCode: "ar",
        useEnglishNumbers: false
    )
}

// MARK: - Theme Colors

struct WidgetThemeColors {
    let primary: Color
    let primaryLight: Color
    let accent: Color
    let background: Color
    let cardBackground: Color
    let textPrimary: Color
    let textSecondary: Color

    static func from(theme: String) -> WidgetThemeColors {
        switch theme {
        case "AppTheme.blue":
            return WidgetThemeColors(
                primary: Color(red: 0x40/255, green: 0x4C/255, blue: 0x6E/255),
                primaryLight: Color(red: 0x53/255, green: 0x61/255, blue: 0x8C/255),
                accent: Color(red: 0xBC/255, green: 0x8A/255, blue: 0x5F/255),
                background: Color(red: 0xFA/255, green: 0xF7/255, blue: 0xF3/255),
                cardBackground: Color(red: 0xFF/255, green: 0xFF/255, blue: 0xFF/255),
                textPrimary: Color(red: 0x40/255, green: 0x4C/255, blue: 0x6E/255),
                textSecondary: Color(red: 0xBC/255, green: 0x8A/255, blue: 0x5F/255)
            )
        case "AppTheme.brown":
            return WidgetThemeColors(
                primary: Color(red: 0x58/255, green: 0x31/255, blue: 0x01/255),
                primaryLight: Color(red: 0x85/255, green: 0x46/255, blue: 0x21/255),
                accent: Color(red: 0xA4/255, green: 0x71/255, blue: 0x48/255),
                background: Color(red: 0xFD/255, green: 0xF7/255, blue: 0xF4/255),
                cardBackground: Color(red: 0xFD/255, green: 0xF7/255, blue: 0xF4/255),
                textPrimary: Color(red: 0x58/255, green: 0x31/255, blue: 0x01/255),
                textSecondary: Color(red: 0xA4/255, green: 0x71/255, blue: 0x48/255)
            )
        case "AppTheme.dark":
            return WidgetThemeColors(
                primary: Color(red: 0x1E/255, green: 0x1E/255, blue: 0x1E/255),
                primaryLight: Color(red: 0x60/255, green: 0x6C/255, blue: 0x38/255),
                accent: Color(red: 0x60/255, green: 0x6C/255, blue: 0x38/255),
                background: Color(red: 0x1E/255, green: 0x1E/255, blue: 0x1E/255),
                cardBackground: Color(red: 0x2A/255, green: 0x2A/255, blue: 0x2A/255),
                textPrimary: Color(red: 0xF6/255, green: 0xF6/255, blue: 0xEE/255),
                textSecondary: Color(red: 0x60/255, green: 0x6C/255, blue: 0x38/255)
            )
        default: // green
            return WidgetThemeColors(
                primary: Color(red: 0x28/255, green: 0x36/255, blue: 0x18/255),
                primaryLight: Color(red: 0x60/255, green: 0x6C/255, blue: 0x38/255),
                accent: Color(red: 0xDD/255, green: 0xA1/255, blue: 0x5E/255),
                background: Color(red: 0xFE/255, green: 0xFA/255, blue: 0xE0/255),
                cardBackground: Color(red: 0xFE/255, green: 0xFA/255, blue: 0xE0/255),
                textPrimary: Color(red: 0x28/255, green: 0x36/255, blue: 0x18/255),
                textSecondary: Color(red: 0x60/255, green: 0x6C/255, blue: 0x38/255)
            )
        }
    }
}

// MARK: - Data Reader

struct WidgetDataReader {
    static let appGroupId = "group.com.alheekmah.quran_widget"

    static func read() -> QuranWidgetData {
        guard let userDefaults = UserDefaults(suiteName: appGroupId) else {
            return .placeholder
        }

        let hijriDay = userDefaults.integer(forKey: "hijri_day")
        let hijriMonth = userDefaults.integer(forKey: "hijri_month")
        let hijriYear = userDefaults.integer(forKey: "hijri_year")
        let hijriMonthName = userDefaults.string(forKey: "hijri_month_name") ?? ""
        let gregorianDate = userDefaults.string(forKey: "gregorian_date") ?? ""
        let lengthOfMonth = userDefaults.integer(forKey: "length_of_month")
        let lastReadPage = userDefaults.integer(forKey: "last_read_page")
        let lastSurahNumber = userDefaults.integer(forKey: "last_surah_number")
        let totalPages = userDefaults.integer(forKey: "total_pages")
        let readingProgress = userDefaults.integer(forKey: "reading_progress")
        let theme = userDefaults.string(forKey: "theme") ?? "AppTheme.green"
        let lastReadText = userDefaults.string(forKey: "last_read_text") ?? "آخر قراءة"
        let pageText = userDefaults.string(forKey: "page_text") ?? "صفحة"
        let languageCode = userDefaults.string(forKey: "language_code") ?? "ar"
        let useEnglishNumbers = userDefaults.bool(forKey: "use_english_numbers")

        return QuranWidgetData(
            hijriDay: hijriDay > 0 ? hijriDay : 1,
            hijriMonth: hijriMonth > 0 ? hijriMonth : 1,
            hijriYear: hijriYear > 0 ? hijriYear : 1447,
            hijriMonthName: hijriMonthName,
            gregorianDate: gregorianDate.isEmpty ? "1 January" : gregorianDate,
            lengthOfMonth: lengthOfMonth > 0 ? lengthOfMonth : 30,
            lastReadPage: lastReadPage > 0 ? lastReadPage : 1,
            lastSurahNumber: lastSurahNumber > 0 ? lastSurahNumber : 1,
            totalPages: totalPages > 0 ? totalPages : 604,
            readingProgress: readingProgress,
            theme: theme,
            lastRead: lastReadText,
            page: pageText,
            languageCode: languageCode,
            useEnglishNumbers: useEnglishNumbers
        )
    }
}

// MARK: - Timeline Provider

struct QuranWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuranWidgetEntry {
        QuranWidgetEntry(date: Date(), data: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (QuranWidgetEntry) -> Void) {
        let data = WidgetDataReader.read()
        completion(QuranWidgetEntry(date: Date(), data: data))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuranWidgetEntry>) -> Void) {
        let data = WidgetDataReader.read()
        let entry = QuranWidgetEntry(date: Date(), data: data)

        // تحديث كل ساعة
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct QuranWidgetEntry: TimelineEntry {
    let date: Date
    let data: QuranWidgetData
}

// MARK: - Asset Name Helpers

/// اسم أصل صورة الشهر الهجري في Assets.xcassets (hijri/1 .. hijri/12)
func hijriMonthAssetName(_ month: Int) -> String {
    return "\(month)"
}

/// اسم أصل صورة السورة في Assets.xcassets (surahs/001..009, 0010..0099, 00100..00114)
func surahAssetName(_ surahNumber: Int) -> String {
    switch surahNumber {
    case 1...9:
        return String(format: "00%d", surahNumber)
    case 10...99:
        return String(format: "00%d", surahNumber)
    case 100...114:
        return String(format: "00%d", surahNumber)
    default:
        return "001"
    }
}

// MARK: - Small Widget View (التاريخ الهجري)

struct SmallWidgetView: View {
    let data: QuranWidgetData
    let theme: WidgetThemeColors
    let logoImg = Image("quran_logo")

    var body: some View {

        ZStack {
            
            logoImg
                .resizable()
                .frame(width: 16, height: 16, alignment: .bottom)
                .offset(y: 70)
                .padding(.top, 4)
                .padding(.bottom, 4)
            
            ZStack {
                theme.background
                
                // رقم اليوم الهجري - مرتفع قليلاً عن المنتصف
                Text(data.num(data.hijriDay))
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundColor(theme.accent.opacity(0.4))
                    .minimumScaleFactor(0.6)
                    .offset(y: -25)
                
                // مخطوطة الشهر الهجري (في المنتصف)
                Image(hijriMonthAssetName(data.hijriMonth))
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70)
                    .foregroundColor(theme.textPrimary)
                
                // التاريخ الميلادي والسنة الهجرية - ملتصقين بالأسفل
                HStack(spacing: 4) {
                    Text(data.gregorianDate)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(theme.accent)
                    
                    Text("\(data.num(data.hijriYear)) هـ")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(theme.accent)
                }
                .frame(maxHeight: .infinity)
                .offset(y: 55)
                .padding(.bottom, 16)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(8)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Medium Widget View (التاريخ الهجري + تقدم القراءة)

struct MediumWidgetView: View {
    let data: QuranWidgetData
    let theme: WidgetThemeColors
    let logoImg = Image("quran_logo")

    var body: some View {
        
        ZStack {
            
            logoImg
                .resizable()
                .frame(width: 16, height: 16, alignment: .bottom)
                .offset(y: 70)
                .padding(.top, 4)
                .padding(.bottom, 4)
            ZStack {
                theme.background
                
                HStack(spacing: 12) {
                    
                    // القسم الأيمن: تقدم القراءة
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 12))
                                .foregroundColor(theme.accent)
                            
                            Text(data.lastRead)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(theme.textPrimary)
                        }
                        .padding(.bottom, 4)
                        
                        Image(surahAssetName(data.lastSurahNumber))
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 34, alignment: .center)
                            .foregroundColor(theme.textPrimary)
                        
                        // شريط التقدم
                        VStack(alignment: .leading, spacing: 2) {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(theme.accent.opacity(0.1))
                                        .frame(height: 26)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(theme.accent)
                                        .frame(
                                            width: geo.size.width * CGFloat(data.readingProgress) / 100,
                                            height: 22
                                        )
                                    
                                    Text("\(data.page) \(data.num(data.lastReadPage))")
                                        .frame(alignment: .leading)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(theme.textPrimary)
                                        .padding(.horizontal, 4)
                                }
                            }
                            .frame(height: 22)
                            
                            Text("\(data.num(data.readingProgress))٪")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(theme.textPrimary.opacity(0.7))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // الفاصل
                    RoundedRectangle(cornerRadius: 1)
                        .fill(theme.accent.opacity(0.3))
                        .frame(width: 2, height: 80)
                    
                    // القسم الأيسر: التاريخ الهجري
                    ZStack() {
                        // رقم اليوم الهجري - مرتفع قليلاً عن المنتصف
                        Text(data.num(data.hijriDay))
                            .font(.system(size: 46, weight: .bold, design: .rounded))
                            .foregroundColor(theme.accent.opacity(0.4))
                            .minimumScaleFactor(0.6)
                            .offset(y: -25)
                        
                        // مخطوطة الشهر الهجري (في المنتصف)
                        Image(hijriMonthAssetName(data.hijriMonth))
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 70)
                            .foregroundColor(theme.textPrimary)
                        
                        // التاريخ الميلادي والسنة الهجرية - ملتصقين بالأسفل
                        HStack(spacing: 4) {
                            Text(data.gregorianDate)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(theme.accent)
                            
                            Circle()
                                .fill(theme.textSecondary)
                                .frame(width: 4, height: 4)

                            
                            Text("\(data.num(data.hijriMonth)) \(data.num(data.hijriYear)) هـ")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(theme.accent)
                        }
                        .frame(maxHeight: .infinity)
                        .offset(y: 55)
                        .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(8)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Adaptive Widget View

struct QuranWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let data: QuranWidgetData
    let theme: WidgetThemeColors

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                MediumWidgetView(data: data, theme: theme)
            default:
                SmallWidgetView(data: data, theme: theme)
            }
        }
        .environment(\.layoutDirection, data.isRTL ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Widget Definition

struct QuranWidget: Widget {
    let kind: String = "quran_macos_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuranWidgetProvider()) { entry in
            let theme = WidgetThemeColors.from(theme: entry.data.theme)
            QuranWidgetEntryView(data: entry.data, theme: theme)
                .containerBackground(theme.primary, for: .widget)
        }
        .configurationDisplayName("القرآن الكريم")
        .description("التاريخ الهجري مع تقدم القراءة")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

// MARK: - Preview

#Preview("Small", as: .systemSmall) {
    QuranWidget()
} timeline: {
    QuranWidgetEntry(date: .now, data: .placeholder)
}

#Preview("Medium", as: .systemMedium) {
    QuranWidget()
} timeline: {
    QuranWidgetEntry(date: .now, data: .placeholder)
}

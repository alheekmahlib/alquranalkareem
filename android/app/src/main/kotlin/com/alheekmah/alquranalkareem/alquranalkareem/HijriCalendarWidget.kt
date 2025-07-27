package com.alheekmah.alquranalkareem.alquranalkareem

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality for Hijri Calendar.
 * تنفيذ وظيفة Widget للتقويم الهجري
 */
class HijriCalendarWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        // قد يكون هناك عدة widgets نشطة، لذا نحدثها جميعاً
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
        // إدخال الوظائف ذات الصلة عند إنشاء أول widget
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
        // إدخال الوظائف ذات الصلة عند تعطيل آخر widget
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // Get widget data from Flutter app - الحصول على بيانات الـ widget من تطبيق Flutter
    val widgetData = HomeWidgetPlugin.getData(context)
    
    // Construct the RemoteViews object - إنشاء كائن RemoteViews
    val views = RemoteViews(context.packageName, R.layout.hijri_calendar_widget)

    // Calculate remaining days - حساب الأيام المتبقية
    val currentDay = widgetData?.getString("hijri_day", "1")?.toIntOrNull() ?: 1
    val monthLength = widgetData?.getString("length_of_month", "30")?.toIntOrNull() ?: 30
    val remainingDays = monthLength - currentDay
    
    // Set remaining days count - عرض عدد الأيام المتبقية
    views.setTextViewText(
        R.id.remaining_days,
        remainingDays.toString().convertToArabicNumerals()
    )
    
    // Set day name - اسم اليوم
    val dayName = widgetData?.getString("hijri_day_name", "الأحد") ?: "الأحد"
    views.setTextViewText(R.id.hijri_day_name, dayName)
    
    // Set month name - اسم الشهر
    val monthName = widgetData?.getString("hijri_month", "محرم") ?: "محرم"
    views.setTextViewText(R.id.hijri_month, monthName)
    
    // Set Hijri date in header - التاريخ الهجري في الرأس
    val hijriDay = widgetData?.getString("hijri_day", "١") ?: "١"
    val hijriYear = widgetData?.getString("hijri_year", "١٤٤٦") ?: "١٤٤٦"
    views.setTextViewText(R.id.hijri_date_display, "$hijriDay - $hijriYear")
    
    // Set Hijri year in footer - السنة الهجرية في التذييل
    views.setTextViewText(R.id.hijri_year, "$hijriYear هـ")
    
    // Update main text to show remaining days message
    // تحديث النص الرئيسي لعرض رسالة الأيام المتبقية
    views.setTextViewText(R.id.remaining_text, "تبقى على إنتهاء $monthName")

    // Set click intent for widget - تعيين action للنقر على الـ widget
    val intent = Intent(context, HijriCalendarWidget::class.java)
    intent.action = "hijri_calendar_clicked"
    val pendingIntent = PendingIntent.getBroadcast(
        context, 
        0, 
        intent, 
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
    views.setOnClickPendingIntent(R.id.main_content_card, pendingIntent)

    // Instruct the widget manager to update the widget - تحديث الـ widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}

/**
 * Returns the drawable resource name for the corresponding Hijri month
 * إرجاع اسم مورد الرسم للشهر الهجري المقابل
 */
private fun getHijriMonthIcon(monthNumber: Int): String {
    return when (monthNumber) {
        1 -> "hijri_1"    // محرم - Muharram
        2 -> "hijri_2"    // صفر - Safar
        3 -> "hijri_3"    // ربيع الأول - Rabi' al-awwal
        4 -> "hijri_4"    // ربيع الثاني - Rabi' al-thani
        5 -> "hijri_5"    // جمادى الأولى - Jumada al-awwal
        6 -> "hijri_6"    // جمادى الثانية - Jumada al-thani
        7 -> "hijri_7"    // رجب - Rajab
        8 -> "hijri_8"    // شعبان - Sha'ban
        9 -> "hijri_9"    // رمضان - Ramadan
        10 -> "hijri_10"  // شوال - Shawwal
        11 -> "hijri_11"  // ذو القعدة - Dhu al-Qi'dah
        12 -> "hijri_12"  // ذو الحجة - Dhu al-Hijjah
        else -> "hijri_1"
    }
}

/**
 * تحويل الأرقام الإنجليزية إلى أرقام عربية
 * Convert English numerals to Arabic numerals
 */
private fun String.convertToArabicNumerals(): String {
    val englishDigits = charArrayOf('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
    val arabicDigits = charArrayOf('٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩')
    
    var result = this
    for (i in englishDigits.indices) {
        result = result.replace(englishDigits[i], arabicDigits[i])
    }
    return result
}

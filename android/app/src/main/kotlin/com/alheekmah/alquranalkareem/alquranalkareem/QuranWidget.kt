package com.alheekmah.alquranalkareem.alquranalkareem

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Widget Provider - يدعم حجمين (صغير، متوسط)
 * يستخدم ملفات VectorDrawable المحلية لعرض أسماء الأشهر والسور
 */
open class QuranWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            doUpdate(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        doUpdate(context, appWidgetManager, appWidgetId)
    }

    override fun onEnabled(context: Context) {}
    override fun onDisabled(context: Context) {}

    // ═══════ ألوان الثيم ═══════
    data class ThemeColors(
        val primary: Int,
        val primaryLight: Int,
        val accent: Int,
        val bg: Int,
        val cardBg: Int,
        val textPrimary: Int,
        val textSecondary: Int
    )

    private fun getThemeColors(theme: String): ThemeColors {
        return when (theme) {
            "AppTheme.blue" -> ThemeColors(
                primary = Color.parseColor("#404C6E"),
                primaryLight = Color.parseColor("#404C6E"),
                accent = Color.parseColor("#BC8A5F"),
                bg = Color.parseColor("#404C6E"),
                cardBg = Color.parseColor("#FAF7F3"),
                textPrimary = Color.parseColor("#404C6E"),
                textSecondary = Color.parseColor("#BC8A5F")
            )
            "AppTheme.brown" -> ThemeColors(
                primary = Color.parseColor("#583101"),
                primaryLight = Color.parseColor("#583101"),
                accent = Color.parseColor("#A47148"),
                bg = Color.parseColor("#583101"),
                cardBg = Color.parseColor("#FDF7F4"),
                textPrimary = Color.parseColor("#583101"),
                textSecondary = Color.parseColor("#A47148")
            )
            "AppTheme.dark" -> ThemeColors(
                primary = Color.parseColor("#1E1E1E"),
                primaryLight = Color.parseColor("#606C38"),
                accent = Color.parseColor("#606C38"),
                bg = Color.parseColor("#1E1E1E"),
                cardBg = Color.parseColor("#2A2A2A"),
                textPrimary = Color.parseColor("#F6F6EE"),
                textSecondary = Color.parseColor("#606C38")
            )
            else -> ThemeColors( // green
                primary = Color.parseColor("#283618"),
                primaryLight = Color.parseColor("#606C38"),
                accent = Color.parseColor("#DDA15E"),
                bg = Color.parseColor("#283618"),
                cardBg = Color.parseColor("#FEFAE0"),
                textPrimary = Color.parseColor("#283618"),
                textSecondary = Color.parseColor("#DDA15E")
            )
        }
    }

    private fun doUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0)

        val layoutId = when {
            minWidth >= 250 -> R.layout.quran_widget_medium
            else -> R.layout.quran_widget_small
        }

        val views = RemoteViews(context.packageName, layoutId)

        val hijriDay = safeGetInt(widgetData, "hijri_day", 1)
        val hijriMonth = safeGetInt(widgetData, "hijri_month", 1)
        val hijriYear = safeGetInt(widgetData, "hijri_year", 1447)
        val hijriMonthName = widgetData?.getString("hijri_month_name", "") ?: ""
        val gregorianDate = widgetData?.getString("gregorian_date", "") ?: ""
        val lastReadPage = safeGetInt(widgetData, "last_read_page", 1)
        val lastSurahNumber = safeGetInt(widgetData, "last_surah_number", 1)
        val readingProgress = safeGetInt(widgetData, "reading_progress", 0)
        val theme = widgetData?.getString("theme", "AppTheme.green") ?: "AppTheme.green"
        val lang = widgetData?.getString("language_code", "ar") ?: "ar"
        val useEnglishNumbers = widgetData?.getBoolean("use_english_numbers", false) ?: false

        val colors = getThemeColors(theme)
        val isRtl = lang in listOf("ar", "ur", "ku")
        val direction = if (isRtl) View.LAYOUT_DIRECTION_RTL else View.LAYOUT_DIRECTION_LTR
        views.setInt(R.id.widget_root, "setLayoutDirection", direction)

        // ═══════ خلفيات الثيم (drawables مخصصة لكل ثيم) ═══════
        views.setInt(R.id.widget_root, "setBackgroundResource", getOuterBgDrawable(theme))
        if (layoutId == R.layout.quran_widget_small) {
            views.setInt(R.id.hijri_card, "setBackgroundResource", getCardBgDrawable(theme))
        } else {
            views.setInt(R.id.content_card, "setBackgroundResource", getCardBgDrawable(theme))
        }

        // ═══════ بيانات التاريخ الهجري (مشتركة بين الحجمين) ═══════
        views.setTextViewText(R.id.hijri_day_number, localizedNumber(hijriDay, lang, useEnglishNumbers))
        views.setTextColor(R.id.hijri_day_number, colors.textSecondary)
        views.setTextViewText(R.id.hijri_month_name, hijriMonthName)
        views.setTextColor(R.id.hijri_month_name, colors.textPrimary)
        views.setTextViewText(R.id.gregorian_date, gregorianDate)
        views.setTextColor(R.id.gregorian_date, colors.textSecondary)
        views.setTextViewText(R.id.hijri_year_text, "${localizedNumber(hijriYear, lang, useEnglishNumbers)} \u0647\u0640")
        views.setTextColor(R.id.hijri_year_text, colors.textSecondary)

        // مخطوطة الشهر الهجري
        val hijriDrawable = getHijriMonthDrawable(context, hijriMonth)
        if (hijriDrawable != 0) {
            views.setImageViewResource(R.id.hijri_month_image, hijriDrawable)
            views.setInt(R.id.hijri_month_image, "setColorFilter", colors.textPrimary)
            views.setViewVisibility(R.id.hijri_month_image, View.VISIBLE)
            views.setViewVisibility(R.id.hijri_month_name, View.GONE)
        } else {
            views.setViewVisibility(R.id.hijri_month_image, View.GONE)
            views.setViewVisibility(R.id.hijri_month_name, View.VISIBLE)
        }

        // شعار القرآن
        views.setInt(R.id.quran_logo, "setColorFilter", colors.accent)

        // ═══════ بيانات القراءة (الحجم المتوسط فقط) ═══════
        if (layoutId == R.layout.quran_widget_medium) {
            val pageLabel = widgetData?.getString("page_text", "") ?: ""
            val pageText = if (pageLabel.isNotEmpty()) "$pageLabel ${localizedNumber(lastReadPage, lang, useEnglishNumbers)}" else localizedNumber(lastReadPage, lang, useEnglishNumbers).toString()
            views.setTextViewText(R.id.page_number, pageText)
            views.setTextColor(R.id.page_number, colors.textPrimary)
            views.setTextViewText(R.id.progress_text, "${localizedNumber(readingProgress, lang, useEnglishNumbers)}\u066A")
            views.setTextColor(R.id.progress_text, setAlpha(colors.textPrimary, 0x80))
            views.setProgressBar(R.id.reading_progress_bar, 100, readingProgress, false)
            // تلوين خلفية حاوية شريط التقدم وشريط التقدم حسب الثيم
            views.setInt(R.id.progress_container, "setBackgroundResource", getProgressBgDrawable(theme))
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                views.setColorStateList(R.id.reading_progress_bar, "setProgressTintList", ColorStateList.valueOf(colors.accent))
                views.setColorStateList(R.id.reading_progress_bar, "setProgressBackgroundTintList", ColorStateList.valueOf(android.graphics.Color.TRANSPARENT))
            }
            views.setTextColor(R.id.last_read_label, colors.textPrimary)
            val lastReadText = widgetData?.getString("last_read_text", "") ?: ""
            if (lastReadText.isNotEmpty()) {
                views.setTextViewText(R.id.last_read_label, lastReadText)
            }

            // لون الفاصل
            views.setInt(R.id.divider, "setBackgroundColor", setAlpha(colors.textSecondary, 0x30))

            // مخطوطة اسم السورة
            val surahDrawable = getSurahNameDrawable(context, lastSurahNumber)
            if (surahDrawable != 0) {
                views.setImageViewResource(R.id.surah_name_image, surahDrawable)
                views.setInt(R.id.surah_name_image, "setColorFilter", colors.textPrimary)
                views.setViewVisibility(R.id.surah_name_image, View.VISIBLE)
                views.setViewVisibility(R.id.surah_name, View.GONE)
            } else {
                views.setViewVisibility(R.id.surah_name_image, View.GONE)
                val surahName = widgetData?.getString("last_surah_name", "") ?: ""
                if (surahName.isNotEmpty()) {
                    views.setTextViewText(R.id.surah_name, surahName)
                    views.setTextColor(R.id.surah_name, colors.textPrimary)
                    views.setViewVisibility(R.id.surah_name, View.VISIBLE)
                } else {
                    views.setViewVisibility(R.id.surah_name, View.GONE)
                }
            }
        }

        // ═══════ فتح التطبيق عند الضغط ═══════
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        if (launchIntent != null) {
            val pendingIntent = PendingIntent.getActivity(
                context, appWidgetId, launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun setAlpha(color: Int, alpha: Int): Int {
        return Color.argb(alpha, Color.red(color), Color.green(color), Color.blue(color))
    }

    private fun safeGetInt(prefs: android.content.SharedPreferences?, key: String, defValue: Int): Int {
        if (prefs == null) return defValue
        return try {
            prefs.getInt(key, defValue)
        } catch (_: ClassCastException) {
            prefs.getString(key, null)?.toIntOrNull() ?: defValue
        }
    }

    private fun getHijriMonthDrawable(context: Context, month: Int): Int {
        val resName = "hijri_$month"
        return context.resources.getIdentifier(resName, "drawable", context.packageName)
    }

    private fun getSurahNameDrawable(context: Context, surahNumber: Int): Int {
        val resName = "surah_%03d".format(surahNumber)
        return context.resources.getIdentifier(resName, "drawable", context.packageName)
    }

    private fun getOuterBgDrawable(theme: String): Int {
        return when (theme) {
            "AppTheme.blue" -> R.drawable.widget_outer_bg_blue
            "AppTheme.brown" -> R.drawable.widget_outer_bg_brown
            "AppTheme.dark" -> R.drawable.widget_outer_bg_dark
            else -> R.drawable.widget_outer_bg
        }
    }

    private fun getCardBgDrawable(theme: String): Int {
        return when (theme) {
            "AppTheme.blue" -> R.drawable.widget_hijri_card_bg_blue
            "AppTheme.brown" -> R.drawable.widget_hijri_card_bg_brown
            "AppTheme.dark" -> R.drawable.widget_hijri_card_bg_dark
            else -> R.drawable.widget_hijri_card_bg
        }
    }

    private fun getProgressBgDrawable(theme: String): Int {
        return when (theme) {
            "AppTheme.blue" -> R.drawable.widget_progress_bg_blue
            "AppTheme.brown" -> R.drawable.widget_progress_bg_brown
            "AppTheme.dark" -> R.drawable.widget_progress_bg_dark
            else -> R.drawable.widget_progress_overlay_bg
        }
    }

    private fun localizedNumber(number: Int, lang: String, useEnglish: Boolean): String {
        val str = number.toString()
        if (useEnglish) return str

        val base = when (lang) {
            "ar", "ku" -> '\u0660'.code
            "bn" -> '\u09E6'.code
            "ur" -> '\u06F0'.code
            else -> return str
        }

        return str.map { ch ->
            if (ch in '0'..'9') (base + (ch.code - '0'.code)).toChar()
            else ch
        }.joinToString("")
    }
}

class QuranWidget : QuranWidgetProvider()

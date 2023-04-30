package com.alheekmah.alquranalkareem.alquranalkareem

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Typeface
import android.widget.RemoteViews
import android.util.TypedValue
import android.app.PendingIntent
import android.appwidget.AppWidgetProvider
import android.content.Intent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider



class HijriWidget : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.hijri_widget_layout)
            views.apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_hijri, pendingIntent)

                // Set Day TextView
                val hijriDay = widgetData.getString("hijriDay", "1")
                setTextViewText(R.id.hijri_widget_text_day, hijriDay)

                // Set Month TextView
                val hijriMonth = widgetData.getString("hijriMonth", "1")
//                setTextViewText(R.id.hijri_widget_text_month, hijriMonth)

                // Set Year TextView
                val hijriYear = widgetData.getString("hijriYear", "1444")
                setTextViewText(R.id.hijri_widget_text_year, "$hijriYear هـ")

                // Set ImageView based on the Hijri month
                val monthImageResourceId = context.resources.getIdentifier("hijri_month_$hijriMonth", "drawable", context.packageName)
                setImageViewResource(R.id.hijri_widget_image, monthImageResourceId)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}


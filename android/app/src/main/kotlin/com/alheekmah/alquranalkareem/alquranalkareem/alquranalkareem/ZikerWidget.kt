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
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class ZikerWidget : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.ziker_widget_layout)
            views.apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                // Set Counter TextView
                val counter = widgetData.getString("zikr", "اللّهُـمَّ بِكَ أَصْـبَحْنا وَبِكَ أَمْسَـينا ، وَبِكَ نَحْـيا وَبِكَ نَمُـوتُ وَإِلَـيْكَ النُّـشُور.")
                var counterText = "$counter"
                if (counter == "0") {
                    counterText = "اللّهُـمَّ بِكَ أَصْـبَحْنا وَبِكَ أَمْسَـينا ، وَبِكَ نَحْـيا وَبِكَ نَمُـوتُ وَإِلَـيْكَ النُّـشُور."
                }
                setTextViewText(R.id.ziker_widget_text, counterText)

                // Set ImageView
                setImageViewBitmap(R.id.ziker_widget_image, BitmapFactory.decodeResource(context.resources, R.drawable.ios_widget))
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

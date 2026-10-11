package com.pabushabi.challenger

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

open class ChallengerWidgetProvider(
    private val layoutRes: Int,
    private val showDays: Boolean = false,
    private val showExtraStats: Boolean = false,
    private val showAddButton: Boolean = false,
) : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, layoutRes)

            val progress = widgetData.getString("progress", "0/0") ?: "0/0"
            val daysLeft = widgetData.getInt("daysLeft", 0)
            val pace = widgetData.getString("pace", "—") ?: "—"
            val projected = widgetData.getString("projected", "—") ?: "—"
            val periodicity = widgetData.getString("periodicity", "—") ?: "—"
            val percent = widgetData.getInt("progressPercent", 0)

            views.setTextViewText(R.id.widget_progress, progress)
            views.setProgressBar(R.id.widget_progress_bar, 100, percent, false)

            if (showDays) {
                views.setViewVisibility(R.id.widget_days, View.VISIBLE)
                views.setTextViewText(R.id.widget_days, "Осталось: $daysLeft дн.")
            }

            if (showExtraStats) {
                views.setViewVisibility(R.id.widget_stats, View.VISIBLE)
                views.setTextViewText(
                    R.id.widget_stats,
                    "Темп: $pace\nПрогноз: $projected\n$periodicity",
                )
            }

            val openIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
            )
            views.setOnClickPendingIntent(R.id.widget_root, openIntent)

            if (showAddButton) {
                views.setViewVisibility(R.id.widget_add, View.VISIBLE)
                val addIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("challenger://add"),
                )
                views.setOnClickPendingIntent(R.id.widget_add, addIntent)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

class Widget1x1Provider : ChallengerWidgetProvider(R.layout.widget_1x1)

class Widget1x2Provider : ChallengerWidgetProvider(
    R.layout.widget_1x2,
    showDays = true,
)

class Widget2x2Provider : ChallengerWidgetProvider(
    R.layout.widget_2x2,
    showDays = true,
)

class Widget1x4Provider : ChallengerWidgetProvider(
    R.layout.widget_1x4,
    showDays = true,
    showExtraStats = true,
    showAddButton = true,
)

class Widget2x4Provider : ChallengerWidgetProvider(
    R.layout.widget_2x4,
    showDays = true,
    showExtraStats = true,
    showAddButton = true,
)

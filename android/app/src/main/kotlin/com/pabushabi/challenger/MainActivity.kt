package com.pabushabi.challenger

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.res.Configuration
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        refreshWidgets()
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        refreshWidgets()
    }

    private fun refreshWidgets() {
        val manager = AppWidgetManager.getInstance(this)
        val providers = listOf(
            Widget1x1Provider::class.java,
            Widget1x2Provider::class.java,
            Widget2x2Provider::class.java,
            Widget1x4Provider::class.java,
            Widget2x4Provider::class.java,
        )

        for (provider in providers) {
            val ids = manager.getAppWidgetIds(ComponentName(this, provider))
            if (ids.isNotEmpty()) {
                val intent = android.content.Intent(this, provider).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                }
                sendBroadcast(intent)
            }
        }
    }
}

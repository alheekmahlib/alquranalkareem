package com.alheekmah.alquranalkareem.alquranalkareem

import android.app.Application
import com.ryanheise.audioservice.AudioServicePlugin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugins.GeneratedPluginRegistrant

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        // التسجيل التلقائي للإضافات يفشل انعكاسيًا داخل مُنشئ FlutterEngine
        // (E/GeneratedPluginsRegister: ... could not find or invoke the
        // GeneratedPluginRegistrant) فيبقى محرك audio_service المخزّن بلا قنوات
        // منصة. ننشئه مبكرًا ونسجّل الإضافات بنداء مباشر قبل بدء Dart.
        if (FlutterEngineCache.getInstance()
                .get(AudioServicePlugin.getFlutterEngineId()) == null
        ) {
            val engine = FlutterEngine(this)
            GeneratedPluginRegistrant.registerWith(engine)
            engine.getDartExecutor()
                .executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            FlutterEngineCache.getInstance()
                .put(AudioServicePlugin.getFlutterEngineId(), engine)
        }
    }
}

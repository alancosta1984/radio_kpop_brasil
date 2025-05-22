package com.example.radio_kpop_brasil // Substitua pelo pacote correto do seu aplicativo

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MyApplication : Application() {
    lateinit var flutterEngine: FlutterEngine

    override fun onCreate() {
        super.onCreate()

        // Inicializa o FlutterEngine
        flutterEngine = FlutterEngine(this)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Opcional: Cache da engine para ser usada em FlutterActivity
        FlutterEngineCache.getInstance().put("my_engine", flutterEngine)
    }
}
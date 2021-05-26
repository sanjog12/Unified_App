package com.example.unified_reminder

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry



class Application : FlutterApplication(){
    override fun onCreate() {
        super.onCreate()
//        setPluginRegistrant(this)
    }

    fun registerWith(registry: PluginRegistry) {
//        FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    }
}
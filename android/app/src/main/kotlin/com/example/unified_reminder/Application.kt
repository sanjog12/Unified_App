package com.unifiedsolutions.reminder

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService.setPluginRegistrant

class Application : FlutterApplication(){
    override fun onCreate() {
        super.onCreate()
//        setPluginRegistrant(this)
    }

    fun registerWith(registry: PluginRegistry) {
//        FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    }
}
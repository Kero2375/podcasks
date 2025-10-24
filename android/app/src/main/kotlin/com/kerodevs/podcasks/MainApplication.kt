//package com.kerodevs.podcasks
//
//// In your Application class
//import android.app.Application
//import dev.fluttercommunity.workmanager.NotificationDebugHandler
//import dev.fluttercommunity.workmanager.LoggingDebugHandler
//import dev.fluttercommunity.workmanager.WorkmanagerDebug
//
//class MainApplication : Application() {
//    override fun onCreate() {
//        super.onCreate()
//        WorkmanagerDebug.setCurrent(LoggingDebugHandler())
//        WorkmanagerDebug.setCurrent(NotificationDebugHandler())
//    }
//}
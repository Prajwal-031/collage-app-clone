package edu.amity.my_flutter_web_app

import android.app.Application
import androidx.multidex.MultiDexApplication
import com.google.firebase.FirebaseApp
import io.flutter.app.FlutterApplication

class FlutterWebApp : MultiDexApplication() {
    override fun onCreate() {
        super.onCreate()
        FirebaseApp.initializeApp(this)
    }
} 
package com.example.lab_3

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            val nav = flutterEngine?.navigationChannel
            if (nav != null) {
                nav.popRoute()
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onBackPressed() {
        val nav = flutterEngine?.navigationChannel
        if (nav != null) {
            nav.popRoute()
        } else {
            @Suppress("DEPRECATION")
            super.onBackPressed()
        }
    }
}

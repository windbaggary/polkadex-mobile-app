package com.trade.polkadex.android
import android.view.View;
import io.flutter.embedding.android.FlutterFragmentActivity;

class MainActivity: FlutterFragmentActivity() {
    override fun onStart() {
        super.onStart()

        val view = findViewById<View>(android.R.id.content).rootView
        view.filterTouchesWhenObscured = true
    }
}

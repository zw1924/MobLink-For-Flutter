package com.example.moblinkexample;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.mob.moblink.MobLink;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    Log.e("QQQ", " MainActivity ");
  }

    // 必须重写该方法，防止MobLink在某些情景下无法还原
    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        MobLink.updateNewIntent(getIntent(), this);
    }
}

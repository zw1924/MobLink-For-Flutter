package com.example.moblink;

import android.util.Log;

import com.mob.moblink.ActionListener;
import com.mob.moblink.MobLink;
import com.mob.moblink.Scene;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** MoblinkPlugin */
public class MoblinkPlugin implements MethodCallHandler {
  private static final String getMobId = "getMobId";
  private static final String restoreScene = "restoreScene";

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.yoozoo.mob/moblink");
    channel.setMethodCallHandler(new MoblinkPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    //TODO test
    Log.e("QQQ", " onMethodCall " + call.method);

   /* if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }*/

    switch (call.method) {
      case getMobId:
        getMobId(call, result);
        break;
      case restoreScene:
        break;
    }

  }

  private void getMobId(MethodCall call, final Result result) {
    HashMap<String, Object> map = call.arguments();
    HashMap<String, Object> params = (HashMap<String, Object>) map.get("params");
    String path = String.valueOf(map.get("path"));

    // 新建场景
    Scene s = new Scene();
    s.path = path;
    //s.source = null;
    s.params = params;

    // 请求场景ID
    MobLink.getMobID(s, new ActionListener() {
      @Override
      public void onResult(Object o) {
        Log.e("QQQ", " onResult ===> " + o);
        result.success(o);
      }

      public void onError(Throwable throwable) {
        // TODO 处理错误结果
        Log.e("QQQ", " onError ===> "  + throwable.getMessage().toString());
        result.error(throwable.getMessage().toString(), null, null);
      }
    });
  }

  private void restoreScene(MethodCall call, Result result) {

  }


}

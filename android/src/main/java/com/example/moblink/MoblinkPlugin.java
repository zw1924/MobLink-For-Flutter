package com.example.moblink;

import android.app.Activity;
import android.util.Log;

import com.mob.moblink.ActionListener;
import com.mob.moblink.MobLink;
import com.mob.moblink.Scene;
import com.mob.moblink.SceneRestorable;

import java.util.HashMap;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** MoblinkPlugin */
public class MoblinkPlugin extends Object implements MethodCallHandler, SceneRestorable, EventChannel.StreamHandler {
  private static final String getMobId = "getMobId";
  private static final String restoreScene = "restoreScene";

  private static final String EventChannel = "JAVA_TO_FLUTTER";
  private EventChannel.EventSink eventSink;

  private static Activity activity;

  private Result mresult; //时间紧，暂时写一个比较low的回调

  private Activity mActivity;

  private HashMap<String, Object> onReturnSceneDataMap;

  private MoblinkPlugin(Activity activity) {
    this.mActivity = activity;
  }

  /**
   * 提供给java层传递数据到flutter层的方法
   * **/
  public void setEvent(Object data) {
    if (eventSink != null) {
      eventSink.success(data);
    } else {
      Log.e("QQQ", " ===== FlutterEventChannel.eventSink 为空 需要检查一下 ===== ");
    }
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.yoozoo.mob/moblink");
    channel.setMethodCallHandler(new MoblinkPlugin(registrar.activity()));
    activity = registrar.activity();

    final EventChannel eventChannel = new EventChannel(registrar.messenger(), EventChannel);
    MoblinkPlugin instance = new MoblinkPlugin(registrar.activity());
    eventChannel.setStreamHandler(instance);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    MobLink.setActivityDelegate(activity, MoblinkPlugin.this);
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
        restoreScene(call, result);
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
        HashMap resposon =new HashMap<String,String>();
        resposon.put("mobid",o);
        resposon.put("domain","");
        result.success(resposon);
      }

      public void onError(Throwable throwable) {
        // TODO 处理错误结果
        Log.e("QQQ", " onError ===> "  + throwable.getMessage().toString());
        result.error(throwable.getMessage().toString(), null, null);
      }
    });
  }

  private void restoreScene(MethodCall call, Result result) {
    this.mresult = result;
    Log.e("QQQ", " 测试result " + result);
    if (result != null) {
        if (onReturnSceneDataMap != null) {
          result.success(onReturnSceneDataMap);
          Log.e("QQQ", " onReturnSceneDataMap 回调成功");
        } else {
          Log.e("QQQ", " onReturnSceneDataMap 为空 不需要回调");
        }
    } else {
      Log.e("QQQ", " result 未空");
    }
  }

  @Override
  public void onReturnSceneData(Scene scene) {
    Log.e("QQQ", " onReturnSceneData path===> " + scene.getPath() + " params===> " + scene.getParams());
    onReturnSceneDataMap = new HashMap<>();
    onReturnSceneDataMap.put("path", scene.getPath());
    onReturnSceneDataMap.put("params", scene.getParams());
    //setEvent(hashMap);

    /*if (mresult != null) {
      if (onReturnSceneDataMap != null) {
        mresult.success(onReturnSceneDataMap);
        Log.e("QQQ", "onReturnSceneData 执行完成，回调到flutter层 " );
      } else {
        Log.e("QQQ", "onReturnSceneDataMap 为空 " );
      }
    } else {
      Log.e("QQQ", " mresult 为空 " + mresult);
    }*/

  }

  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {
    this.eventSink = eventSink;
    Log.e("QQQ", " onListen " + eventSink.toString());
  }

  @Override
  public void onCancel(Object o) {
    //this.eventSink = null;
    Log.e("QQQ", " onCancel ");
  }
}

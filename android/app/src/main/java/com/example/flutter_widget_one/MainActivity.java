package com.example.flutter_widget_one;

import com.example.flutter_widget_one.plugins.UpdateVersionPlugin;
import android.os.Bundle;
import android.net.Uri;
import android.content.Intent;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  String C_NAME = "samples.flutter.sdudy/call_native";
  String routeId = "0";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
      Intent i_getvalue = getIntent();
      String action = i_getvalue.getAction();

      if(Intent.ACTION_VIEW.equals(action)){
          Uri uri = i_getvalue.getData();
          if(uri != null){
              routeId = uri.getQueryParameter("data");
          }
      }
      new MethodChannel(getFlutterView(),C_NAME).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @java.lang.Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if( methodCall.method.equals("call_native_method")){
                  result.success(new String(routeId));
                }else{
                  result.success(new String("0"));
                }
              }
            }
    );
    GeneratedPluginRegistrant.registerWith(this);
      // 注册更新组件
      UpdateVersionPlugin.registerWith(registrarFor("iwubida.com/update_version"));
  }
}

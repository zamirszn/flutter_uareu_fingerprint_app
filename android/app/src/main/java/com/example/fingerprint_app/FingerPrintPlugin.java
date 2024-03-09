package com.example.fingerprint_app;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.embedding.engine.FlutterEngine;
import android.util.Log;
import java.util.HashMap;
import java.util.Map;


import com.example.fingerprint_app.uareu4500library.Fingerprint;
import com.example.fingerprint_app.uareu4500library.Status;







public class FingerPrintPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;

    private Context pluginContext;

    public String scanTextError;

    private String scanText;





    private byte[] image;




  public void attachToEngine(MainActivity context, FlutterEngine flutterEngine) {
    channel =
      new MethodChannel(
        flutterEngine.getDartExecutor().getBinaryMessenger(),
        "fingerPrintMethodChannel"
      );
    channel.setMethodCallHandler(this);
    pluginContext = context;
  }

//



  private Fingerprint fingerprint;

  public boolean init() {
    fingerprint = new Fingerprint();

    
    return true;
  }

  public void dispose() {
    fingerprint.turnOffReader();
  }

  public void scan() {

      fingerprint.scan(pluginContext, printHandler, updateHandler );


  }




   Handler updateHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(Message msg) {
            int status = msg.getData().getInt("status");
            scanTextError ="";

            switch (status) {
                case Status.INITIALISED:
                    scanText ="Setting up reader";
                    break;
                case Status.SCANNER_POWERED_ON:
                    scanText="Reader powered on";
                    break;
                case Status.READY_TO_SCAN:
                    scanText="Ready to scan finger";
                    break;
                case Status.FINGER_DETECTED:
                    scanText="Finger detected";
                    break;
                case Status.RECEIVING_IMAGE:
                    scanText ="Receiving image";
                    break;
                case Status.FINGER_LIFTED:
                    scanText ="Finger has been lifted off reader";
                    break;
                case Status.SCANNER_POWERED_OFF:
                    scanText ="Reader is off";
                    break;
                case Status.SUCCESS:
                    scanText ="Fingerprint successfully captured";
                    break;
                case Status.ERROR:
                    scanText ="Error";
                    scanTextError = msg.getData().getString("errorMessage");
                    break;
                default:
                    scanText = String.valueOf(status);
                    scanTextError =msg.getData().getString("errorMessage");
                    break;




            }
            public  Map<String, Object> scanDataMap = new HashMap<>();

            scanDataMap.put("scanTextError", scanTextError);
            scanDataMap.put("imgData", image);
            scanDataMap.put("scanText", scanText);


            channel.invokeMethod("onScanMethod", scanDataMap);

            


            




        }
    };

    Handler printHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(Message msg) {


            int status = msg.getData().getInt("status");
            if (status == Status.SUCCESS) {
                image = msg.getData().getByteArray("img");
            } else {
                scanTextError = msg.getData().getString("errorMessage");
            }

        }
    };


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {

        Log.d("fingerprint_app", "onAttachedToEngine");
    pluginContext = binding.getApplicationContext();

    }

    @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
          
          case "init":
            result.success(init());
            break;

          case "scan":
            scan();
            break;



          default:
            throw new IllegalArgumentException("Unknown method " + call.method);
        }
    }
}

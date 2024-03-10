package com.example.fingerprint_app;

import static android.os.Environment.getExternalStorageDirectory;

import android.content.Context;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import androidx.annotation.NonNull;
import com.example.fingerprint_app.uareu4500library.Fingerprint;
import com.example.fingerprint_app.uareu4500library.Status;
import com.machinezoo.sourceafis.FingerprintImage;
import com.machinezoo.sourceafis.FingerprintMatcher;
import com.machinezoo.sourceafis.FingerprintTemplate;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.fingerprint_app.DatabaseHelper.FingerprintModel;

public class FingerPrintPlugin implements FlutterPlugin, MethodCallHandler {

  private MethodChannel channel;

  private Context pluginContext;

  public String scanTextError;

  private byte[] image;

  public void attachToEngine(
    MainActivity context,
    FlutterEngine flutterEngine
  ) {
    channel =
      new MethodChannel(
        flutterEngine.getDartExecutor().getBinaryMessenger(),
        "fingerPrintMethodChannel"
      );
    channel.setMethodCallHandler(this);
    pluginContext = context;
  }

  private Fingerprint fingerprint;
  public Map<String, Object> scanDataMap = new HashMap<>();

  public boolean init() {
    fingerprint = new Fingerprint();
    return true;
  }

  public void dispose() {
    fingerprint.turnOffReader();
  }

  public void scan() {
    fingerprint.scan(pluginContext, printHandler, updateHandler);
  }

  Handler updateHandler = new Handler(Looper.getMainLooper()) {
    @Override
    public void handleMessage(Message msg) {
      int status = msg.getData().getInt("status");
      scanTextError = "";

      String scanText;
      switch (status) {
        case Status.INITIALISED:
          scanText = "Setting up reader";
          break;
        case Status.SCANNER_POWERED_ON:
          scanText = "Reader powered on";
          break;
        case Status.READY_TO_SCAN:
          scanText = "Ready to scan finger";
          break;
        case Status.FINGER_DETECTED:
          scanText = "Finger detected";
          break;
        case Status.RECEIVING_IMAGE:
          scanText = "Receiving image";
          break;
        case Status.FINGER_LIFTED:
          scanText = "Finger has been lifted off reader";
          break;
        case Status.SCANNER_POWERED_OFF:
          scanText = "Reader is off";
          break;
        case Status.SUCCESS:
          scanText = "Fingerprint successfully captured";

          break;
        case Status.ERROR:
          scanText = "Error";
          scanTextError = msg.getData().getString("errorMessage");
          break;
        default:
          scanText = String.valueOf(status);
          scanTextError = msg.getData().getString("errorMessage");
          break;
      }
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

  public FingerprintTemplate probe;

  public FingerprintTemplate candidate;

  public File externalStorageDir;


  private double matchFingerprints(String queryFingerprint) {

    DatabaseHelper dbHelper = new DatabaseHelper(pluginContext);




    List<FingerprintModel> records= dbHelper.queryFingerprintRecords();




      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        // For Android 10 (API level 29) and above
        externalStorageDir = pluginContext.getExternalFilesDir(null);
      } else {
        // For Android 9 (API level 28) and below
        externalStorageDir = Environment.getExternalStorageDirectory();
      }



    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                      probe = new FingerprintTemplate(
                              new FingerprintImage(Files.readAllBytes(Paths.get(queryFingerprint))));

                  }


      return  0;


//      FingerprintMatcher matcher = new FingerprintMatcher(probe);
//
//      for (FingerprintModel fingerprint : records) {
//        Log.d("fingerprint_app", fingerprint.getFingerprintPath());
//
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//          candidate = new FingerprintTemplate(
//                  new FingerprintImage(Files.readAllBytes(Paths.get(fingerprint.getFingerprintPath()))));
//        }
//
//
//
//
//      }
//
//
//      return matcher.match(candidate);






    } catch (Exception e) {
      e.printStackTrace();
      return -1.0; // or any value indicating failure
    }
  }

  @Override
  public void onMethodCall(
    @NonNull MethodCall call,
    @NonNull MethodChannel.Result result
  ) {
    switch (call.method) {
      case "init":
        result.success(init());
        break;
      case "scan":
        scan();
        break;
      case "match":
        String queryFingerprint = call.argument("queryFingerprint");

        double matchScore = matchFingerprints(queryFingerprint);
        result.success(matchScore);
        break;
      default:
        throw new IllegalArgumentException("Unknown method " + call.method);
    }
  }
}

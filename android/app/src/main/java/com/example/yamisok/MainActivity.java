package com.yamisok.appsv2;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "https.yamisok.com/channel";
    private static final String EVENTS = "https.yamisok.com/events";
    private String startString;
    private BroadcastReceiver linksReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        Intent intent = getIntent();
        Uri data = intent.getData();

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("getAppLink")) {

                        if (startString != null) {
                            result.success(startString);
                        } else {
                            result.success("null");
                        }

                    } else {
                        result.notImplemented();
                    }
                });

        new EventChannel(getFlutterView(), EVENTS).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, final EventChannel.EventSink events) {
                        linksReceiver = createChangeReceiver(events);
                    }

                    @Override
                    public void onCancel(Object args) {
                        linksReceiver = null;
                    }
                }
        );

        if (data != null) {
            startString = data.toString();
        }
    }

    @Override
    public void onNewIntent(Intent intent){
        super.onNewIntent(intent);
        if(intent.getAction() == android.content.Intent.ACTION_VIEW && linksReceiver != null) {
            linksReceiver.onReceive(this.getApplicationContext(), intent);
        }
    }

    private BroadcastReceiver createChangeReceiver(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW

                String dataString = intent.getDataString();

                if (dataString == null) {
                    events.error("UNAVAILABLE", "Link unavailable", null);
                } else {
                    events.success(dataString);
                }
                ;
            }
        };
    }

}
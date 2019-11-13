package com.sandm.flutter_app;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import vn.hunghd.flutterdownloader.FlutterDownloaderPlugin;

public class MyApplication extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @java.lang.Override
    public void registerWith(PluginRegistry pluginRegistry) {
        GeneratedPluginRegistrant.registerWith(pluginRegistry);
    }
}

package com.kasem.flutter_absolute_path

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import android.content.Context
import android.app.Activity
import android.net.Uri


class FlutterAbsolutePathPlugin : FlutterPlugin, ActivityAware, MethodCallHandler{
    private lateinit var channel : MethodChannel

    private lateinit var context: Context
    private lateinit var activity: Activity

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_absolute_path")
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // TODO: your plugin is no longer attached to a Flutter experience.
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivity() {
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "getAbsolutePath" -> {
                val uriString = call.argument<Any>("uri") as String
                val uri = Uri.parse(uriString)
                result.success(FileDirectory.getDataColumn(this.context, uri, null, null))
            }
            else -> result.notImplemented()
        }
    }
}

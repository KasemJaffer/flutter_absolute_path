package com.kasem.flutter_absolute_path

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import android.content.Context
import android.app.Activity
import android.net.Uri

import io.flutter.plugin.common.BinaryMessenger

class FlutterAbsolutePathPlugin : FlutterPlugin, ActivityAware, MethodCallHandler{
    private lateinit var channel : MethodChannel

    private lateinit var context: Context
    private lateinit var activity: Activity

    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var methodChannel: MethodChannel? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_absolute_path")
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.applicationContext

        // From flutter file picker
        pluginBinding = flutterPluginBinding
        val messenger = pluginBinding?.binaryMessenger
        doOnAttachedToEngine(messenger!!)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // TODO: your plugin is no longer attached to a Flutter experience.
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;

        // From flutter file picker
        doOnAttachedToActivity(binding)
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
                result.success(FileDirectory.getAbsolutePath(this.context, uri))
            }
            else -> result.notImplemented()
        }
    }

    // V1 only
    private var registrar: Registrar? = null
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            if (registrar.activity() != null) {
                val plugin = FlutterAbsolutePathPlugin()
                plugin.doOnAttachedToEngine(registrar.messenger())
                plugin.doOnAttachedToActivity(null, registrar)
            }
        }
    }
    private fun doOnAttachedToActivity(activityBinding: ActivityPluginBinding?,
                                       registrar: Registrar? = null) {
        this.activityBinding = activityBinding
        this.registrar = registrar
    }
    private fun doOnAttachedToEngine(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, "flutter_absolute_path")
        methodChannel?.setMethodCallHandler(this)
        context = pluginBinding!!.applicationContext
    }
}

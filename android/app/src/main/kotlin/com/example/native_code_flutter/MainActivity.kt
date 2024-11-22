package com.example.native_code_flutter

import android.content.Context
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val METHOD_CHANNEL_NAME = "com.light.barometer/method"
    private val EVENT_CHANNEL_NAME = "com.light.barometer/event"
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventChannelHandler: StreamHandler? = null
    private var sensorManager: SensorManager? = null
    private var sensorId: Int = 1


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //setup channels
        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)

    }

    override fun onDestroy() {
        teardownChannels()
        super.onDestroy()
    }

    private fun setupChannels(context:Context, messenger: BinaryMessenger){
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel!!.setMethodCallHandler {
                call, result ->
            if(call.method == "isSensorAvailable"){
                sensorId = call.argument<Int>("sensor_id")!!
                result.success(sensorManager!!.getDefaultSensor(sensorId!!) != null)
            }else{
                result.notImplemented()
            }
        }

        eventChannel = EventChannel(messenger, EVENT_CHANNEL_NAME)
        eventChannelHandler = StreamHandler(sensorManager!!, sensorId!!)
        eventChannel!!.setStreamHandler(eventChannelHandler)
    }

    private fun teardownChannels(){
        methodChannel!!.setMethodCallHandler(null)
        eventChannel!!.setStreamHandler(null)
    }
}

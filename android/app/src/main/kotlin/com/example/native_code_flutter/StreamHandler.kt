package com.example.native_code_flutter

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink

class StreamHandler(private val sensorManager: SensorManager, private val sensorType: Int, private var interval: Int = SensorManager.SENSOR_DELAY_NORMAL) :
    EventChannel.StreamHandler, SensorEventListener {

    private var sensor: Sensor? = null
    private var eventSink:EventSink? = null
    private var sensorId: Int = sensorType

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

        if (arguments is Map<*, *>) {
            val sensor_id = arguments["sensor_id"] as? Int
            if (sensor_id != null) {
                sensorId = sensor_id
            }
        }
        sensor = sensorManager.getDefaultSensor(sensorId)
        if(sensor != null){
            eventSink = events
            sensorManager.registerListener(this, sensor, interval)
        }
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this)
        eventSink = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        val sensorValues = event!!.values[0]
        eventSink?.success(sensorValues)
//        Log.e( "onSensorChanged: ", sensorId.toString())
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {

    }
}
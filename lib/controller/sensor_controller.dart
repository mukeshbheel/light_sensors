import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SensorController extends GetxController{

  final channel = MethodChannel("com.light.barometer/method");
  final eventChannel = EventChannel("com.light.barometer/event");
  RxString availability = 'Unknown'.obs;
  StreamSubscription? readingsStream;
  RxDouble readings = 0.0.obs;
  double startingReadingValue = 0.0;
  RxInt sensor_id = 1.obs;

  initFunctions({required int sensorId}) async{
    sensor_id.value = sensorId;
    await checkAvailability();
    if(availability.value == "true"){
      startReading();
    }
  }

  checkAvailability() async{
    try{
      var isAvailable = await channel.invokeMethod("isSensorAvailable", {"sensor_id":sensor_id.value});
        availability.value = isAvailable.toString();
    }on PlatformException catch(e){
      print(e);
    }
  }

  startReading(){
    readingsStream = eventChannel.receiveBroadcastStream({"sensor_id":sensor_id.value}).listen((event){
      readings.value = event;
    });
  }

  stopReading(){
    readings.value = startingReadingValue;
    readingsStream?.cancel();
  }

  cancelSubscription(){
    readingsStream?.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    readingsStream?.cancel();
    super.dispose();
  }
}
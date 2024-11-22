import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:native_code_flutter/view/feature_listing.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FeaturesListings(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final channel = MethodChannel("com.light.barometer/method");
  final eventChannel = EventChannel("com.light.barometer/event");
  String availability = 'Unknown';
  StreamSubscription? readingsStream;
  double readings = 0.0;
  double startingReadingValue = 0.0;
  final int sensor_id = 2;

  _checkAvailability() async{
    try{
      var isAvailable = await channel.invokeMethod("isSensorAvailable", {"sensor_id":sensor_id});
      setState(() {
        availability = isAvailable.toString();
      });
    }on PlatformException catch(e){
      print(e);
    }
  }

  _startReading(){
    readingsStream = eventChannel.receiveBroadcastStream({"sensor_id":sensor_id}).listen((event){
      setState(() {
        readings = event;
      });
    });
  }

  _stopReading(){
    setState(() {
      readings = startingReadingValue;
    });

    readingsStream?.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    readingsStream?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sensor Available? : $availability"),
            ElevatedButton(onPressed: _checkAvailability, child: Text("Check Sensor Availability")),
            SizedBox(height: 20,),
            if(readings != startingReadingValue)Text("Readings : $readings \u2103"),
            if(availability == "true" && readings == startingReadingValue)ElevatedButton(onPressed: _startReading, child: Text("Start Reading")),
            if(readings != startingReadingValue)ElevatedButton(onPressed: _stopReading, child: Text("Stop Reading"))
          ],
        ),
      ),
    );
  }
}


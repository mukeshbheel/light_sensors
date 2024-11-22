import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/sensor_controller.dart';

class IlluminanceBulb extends StatefulWidget {
  final int sensor_id;

  const IlluminanceBulb({super.key, required this.sensor_id});

  @override
  _IlluminanceBulbState createState() => _IlluminanceBulbState();
}

class _IlluminanceBulbState extends State<IlluminanceBulb> {
  final controller = Get.put(SensorController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.initFunctions(sensorId: widget.sensor_id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _getBulbColor(double lux) {
    // Map the lux value to a color intensity
    int intensity = (lux.clamp(0, 1000) / 4).toInt(); // Scale lux to [0, 255]
    return Color.fromARGB(255, intensity, intensity, 0); // Yellowish glow
  }

  double _getBulbSize(double lux) {
    // Scale the bulb size dynamically based on lux
    return lux.clamp(50, 500); // Minimum and maximum size
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Illuminance Bulb',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() => controller.availability.value == "true"
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Light Intensity: ${controller.readings.value.toStringAsFixed(1)} lux',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: _getBulbSize(controller.readings.value) < 150
                        ? 150
                        : _getBulbSize(controller.readings.value),
                    height: _getBulbSize(controller.readings.value) < 150
                        ? 150
                        : _getBulbSize(controller.readings.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getBulbColor(controller.readings.value),
                      boxShadow: [
                        BoxShadow(
                          color: _getBulbColor(controller.readings.value)
                              .withOpacity(0.7),
                          blurRadius: 30,
                          spreadRadius: 200,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lightbulb,
                        size: 150,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon or Image
                  const Icon(
                    Icons.lightbulb_circle_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  // Message
                  const Text(
                    'Light Sensor Not Available',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Sub-message
                  const Text(
                    'No light sensor found on this device.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // Button to go back or retry
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Return to the previous screen
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

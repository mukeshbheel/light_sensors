import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_code_flutter/controller/sensor_controller.dart';

class ThermometerScreen extends StatefulWidget {

  final int sensor_id;

  const ThermometerScreen({super.key, required this.sensor_id});
  @override
  _ThermometerScreenState createState() => _ThermometerScreenState();
}

class _ThermometerScreenState extends State<ThermometerScreen> {

  final controller = Get.put(SensorController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.initFunctions(sensorId: widget.sensor_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Thermometer Screen'),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.availability.value == "true"
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Thermometer Visualization
                      Container(
                        width: 100,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Background of the thermometer
                            Container(
                              width: 80,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            // Temperature level
                            Container(
                              width: 80,
                              height: controller.readings.value > 0 ? (controller.readings.value / 50) * 300 : 100,
                              // Adjust height dynamically
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Temperature Display
                      Text(
                        '${controller.readings.value.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // Slider to simulate temperature change
                      Slider(
                        value: controller.readings.value,
                        min: 0,
                        max: 100,
                        divisions: 50,
                        label: '${controller.readings.value.toStringAsFixed(1)}°C',
                        onChanged: (value) {
                          setState(() {
                            controller.readings.value = value;
                          });
                        },
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
                      Icons.device_thermostat_outlined,
                      size: 100,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    // Message
                    const Text(
                      'Thermometer Not Available',
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
                      'This device does not support thermometer functionality.',
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

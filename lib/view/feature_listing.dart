import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_code_flutter/view/termometer.dart';

import '../utils/constants.dart';
import 'light_meter.dart';


class FeaturesListings extends StatelessWidget {
  FeaturesListings({super.key});

  List features = [
    {
      'title': 'Thermometer',
      'screen': ThermometerScreen(sensor_id: 13,),
      'showWidget': false,
      'component': null,
    },
    {
      'title': 'Illuminance meter',
      'screen': IlluminanceBulb(sensor_id: 5,),
      'showWidget': false,
      'component': null
    },

  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Features',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  children: [
                    ...features.map((item) => InkWell(
                      onTap: () {
                        Get.to(item['screen']);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(2),
                        width: (MediaQuery.of(context).size.width - 60) / 3,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: getRandomColor(),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['title'].toString().capitalizeFirst!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

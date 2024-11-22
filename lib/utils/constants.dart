import 'dart:math';

import 'package:flutter/material.dart';

Color getRandomColor(){
  return Color(
      0xFF000000 + Random().nextInt(0x00FFFFFF)
  );
}
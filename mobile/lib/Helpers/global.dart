import 'package:flutter/material.dart';

import 'data.dart';

class MyGlobal{
  static const int duration = 2;
  static const String appName = 'kImages';
  static Future<String> dataUrl() async => "${await MyData.getCurrentServerUrl()}/api/Upload";
}
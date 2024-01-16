import 'package:flutter/material.dart';

import 'data.dart';

class MyGlobal{
  static const int duration = 2;
  static const String appName = 'kInventory';
  static Future<String> loginUrl() async => "${await MyData.getCurrentServerUrl()}/api/User";
  static Future<String> dataUrl() async => "${await MyData.getCurrentServerUrl()}/api/Data";
  static Future<String> reportProbUrl() async => "${await MyData.getCurrentServerUrl()}/Home/ReportProb";

  //static Future<String> preparationsUrl() async => "${await MyData.getCurrentServerUrl()}/getPreparations";
  static Future<String> addedPreparationUrl() async => "${await MyData.getCurrentServerUrl()}/getAddedPreparation";
  static Future<String> setPreparationsUrl() async => "${await MyData.getCurrentServerUrl()}/setPreparationItemQuantity";
  static Future<String> addPreparationsUrl() async => "${await MyData.getCurrentServerUrl()}/addPreparationItem";
  static Future<String> setPreparationValidation() async => "${await MyData.getCurrentServerUrl()}/setPreparationValidation";
  static List<Color> colorsList(){
    var list = List<Color>.empty(growable: true);
    list.add(Colors.orange);
    list.add(Colors.limeAccent);
    list.add(Colors.orangeAccent);
    list.add(Colors.lightBlueAccent);
    list.add(Colors.lightGreen);
    list.add(Colors.deepOrangeAccent);
    list.add(Colors.yellow);
    list.add(Colors.lightGreenAccent);
    list.add(Colors.deepOrange);
    list.add(Colors.lime);
    list.add(Colors.yellowAccent);
    list.add(Colors.lightBlue);
    return list;
  }
}
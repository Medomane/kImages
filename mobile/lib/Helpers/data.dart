import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyData{
  String _serverUrl = '';

  MyData();

  static Future<String> get _localPath async => (await getApplicationDocumentsDirectory()).path;
  static Future<File> get data async {
    final path = await _localPath;
    var f = File('$path/data.txt');
    return (await f.exists()) ? f : await f.create();
  }
  static Future<MyData?> get() async{
    try{
      return MyData.fromJson(jsonDecode(await (await data).readAsString()));
    }
    catch(ex){
      return null;
    }
  }

  static Future<String?> getCurrentServerUrl() async => (await get())?._serverUrl;
  static Future<void> setCurrentServerUrl(String serverUrl) async {
    var data = await get();
    data ??= MyData();
    data._serverUrl = serverUrl;
    await data.save();
  }

  Future<void> save() async => await (await data).writeAsString(jsonEncode(toJson()));
  static Future<void> clearData() async {
    var res = await get();
    var f = await data;
    await f.delete(recursive: true);
    if(res != null){
      var data = MyData();
      data._serverUrl = res._serverUrl;
      await data.save();
    }
  }

  Map<String, dynamic> toJson() => { 'serverUrl': _serverUrl };
  MyData.fromJson(Map<String, dynamic> json) : _serverUrl =  json['serverUrl'];
}
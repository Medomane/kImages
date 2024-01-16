import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'data.dart';
import 'global.dart';
import 'func.dart';

class Http{
  //Login
  static Future<dynamic> login(String username, String password) async {
    try{
      final base64Str = base64.encode(utf8.encode('$username:$password'));
      var response = await Dio().get(Uri.encodeFull(await MyGlobal.loginUrl()),options: Options(headers: {"Authorization": 'Basic $base64Str'}));
      Map<String,dynamic> res = response.data;
      if(res["Type"].toString() == "error") {
        await Func.showError(res["Content"].toString());
      } else {
        return res["Content"] ;
      }
    }
    catch(er){
      await Func.showError("Utilisateur n'existe pas !!!");
    }
    return null;
  }

  //set url
  static Future<bool> setUrl(String url) async {
    try{
      var link = Uri.parse(url);
      var baseUrl = '${link.scheme}://${link.host}';
      if(link.hasPort) baseUrl += ":${link.port}";
      var response = await Dio().get(Uri.encodeFull(baseUrl)).timeout(const Duration(seconds: 10));
      var res = response.data;
      if(res.toString() == "kImages"){
        await MyData.setCurrentServerUrl(baseUrl);
        return true ;
      }
      else {
        await Func.showError("Le lien est érroné !!!");
      }
    }
    catch(er){
      await Func.showError("Une erreur est survenue veuillez réessayer ultérieurement (${er.toString()}) !!!");
    }
    return false;
  }
  //Upload SqLite Database
  static Future<bool> refreshData(GlobalKey<ScaffoldState> key,BuildContext context,RoundedLoadingButtonController btn) async {
    if(!await Func.checkConnection(btn:btn)) return false;
    var pd = ProgressDialog(context,isDismissible: false);
    pd.style(maxProgress: 100,progress: 0,message: "Chargement ...");
    await pd.show();
    try{
      /*final Dio dio = Dio();
      var file = await SqLite.getDbPath();
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file,filename: SqLite.dbName)
      });
      var response = await dio.post(await MyGlobal.dataUrl(),
        data: formData,
        options: Options(headers: {"Authorization": (await MyData.getAuth())}),
        onSendProgress: (int received, int total){
          if (total == -1) return ;
          if(received == total) {
            pd.update(message:"Mise à jour ...");
          } else {
            var progress = "Chargement : ${(received / total * 100).toStringAsFixed(0)}%";
            pd.update(message:progress);
          }
        }
      );
      if(response.statusCode == 200) {
        await Func.endLoading(pd: pd,btnController: btn);
        return await downloadDb(key);
      }
      else {
        await Func.showError('Erreur avec le statut: ${response.statusCode} ${response.statusMessage}.',pd: pd,btn: btn);
      }*/
    }
    catch(er){
      if (kDebugMode) {
        print(er.toString());
      }
      await Func.showError("une erreur est survenue veuillez réessayer ultérieurement !!!",pd: pd,btn: btn);
    }
    return false;
  }
}
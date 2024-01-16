import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class Func{
  static bool isNumeric(String? s) {
    if(s == null) return false;
    if(isNull(s)) return false;
    return double.tryParse(s) != null;
  }
  static bool isNull(String? val) => val == null || val.trim() == "" || val.trim() == "null";

  static Future<void> clearTempDir() async {
    Directory dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
  }

  static double getContainerWidth(BuildContext context){
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return (h > w) ? w : h ;
  }
  static double getImageWidth(BuildContext context){
    double width;
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    if(h > w) {
      width = w-20;
    } else if(h < w) {
      width = h - 300;
    } else {
      width = w - 50;
    }
    return width ;
  }
  static double getImageHeight(BuildContext context) => MediaQuery.of(context).size.height-300;

  static String formatDate(DateTime date,{bool seconds = true}){
    var formatter = DateFormat('yyyy-MM-dd${(seconds?' HH:mm:ss':'')}');
    return formatter.format(date);
  }

  static Future<void> showError(String error,{RoundedLoadingButtonController? btn,ProgressDialog? pd}) async {
    Fluttertoast.showToast(msg: error,toastLength: Toast.LENGTH_LONG);
    endLoading(btnController: btn,pd: pd);
  }

  static Future<void> copy(String text) async {
    Clipboard.setData(ClipboardData(text: text)).then((value) { Fluttertoast.showToast(msg: '"$text" est Copié',toastLength: Toast.LENGTH_SHORT);  });
  }

  static Future<bool> checkConnection({RoundedLoadingButtonController? btn,bool showMsg = true}) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool res ;
    if (connectivityResult == ConnectivityResult.mobile) {
      res = await _checkInternet(showMsg);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      res = true ;
    } else {
      res = await _checkInternet(showMsg);
    }
    if(!res && btn != null) btn.stop();
    return res ;
  }
  static Future<bool> _checkInternet(bool showMsg) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
    } on SocketException catch (_) {
      if(showMsg) Fluttertoast.showToast(msg: "Pas de connexion !!!",toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }

  static String trimEnd(String str,String c) => str[str.length-1] == c ? str.substring(0, str.length - 1) : str;

  static Future<void> endLoading({ProgressDialog? pd,RoundedLoadingButtonController? btnController}) async {
    if(btnController != null) btnController.stop();
    if(pd != null) await pd.hide();
  }

  static Text hTxt(String txt) => Text(txt,style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold));

  static Future<File> getImageFileFromAssets(String fileName) async {
    final byteData = await rootBundle.load('images/$fileName');
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  static Widget getImage(BuildContext context,dynamic image,{Function()? func}){
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: Func.getImageWidth(context),
          maxHeight: Func.getImageHeight(context),
        ),
        child: InkWell(
          onTap: func,
          child: Image(image: image,fit: BoxFit.fitHeight,),
        ),
      ) ,
    );
  }

  static Widget getCopyText(String desc){
    return Row(
      children: [
        Text(desc),
        IconButton(
            icon: const Icon(Icons.copy_all),
            iconSize: 16,
            padding: const EdgeInsets.all(5),
            constraints: const BoxConstraints(),
            onPressed: () => Func.copy(desc)
        )
      ],
    );
  }
  static Widget getDescCard(String title, List<String> descriptions, IconData icon){
    return Card(child:
      ListTile(
        title: Text(title),
        subtitle: descriptions.length == 1 ? getCopyText(descriptions[0]) : Column(children: descriptions.map((desc) => getCopyText(desc)).toList()),
        trailing: Icon(icon)
      )
    );
  }
}
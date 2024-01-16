import 'package:flutter/material.dart';

import 'home.dart';
import 'splash.dart';
import '../Helpers/global.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: null,
        future: getData(),
        builder: (ctx,snap){
          if(snap.hasData && snap.connectionState == ConnectionState.done && snap.data != null) {
            return const HomeState();
          }  else {
            return const SplashState();
          }
        }
    );
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(seconds: MyGlobal.duration));
    return true;
  }
}
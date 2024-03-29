import 'package:flutter/material.dart';

class SplashState extends StatelessWidget {
  const SplashState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(image: AssetImage("images/icon.png"),fit: BoxFit.fill),
                  SizedBox(height: 50,),
                  Text("Par KSoft SARL")
                ],
              ),
            )
        )
    );
  }
}
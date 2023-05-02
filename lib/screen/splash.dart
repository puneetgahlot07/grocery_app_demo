import 'package:flutter/material.dart';
import 'package:grocery_app/utils/ui_helper.dart';

class Splash extends StatefulWidget {
  static String routeName = "/Splash";
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 5), () {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: UiHepler.getSize(context).height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Spacer(
                flex: 2,
              ),
              CircularProgressIndicator(),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

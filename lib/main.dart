import 'package:flutter/material.dart';
import 'package:grocery_app/screen/home.dart';
import 'package:grocery_app/screen/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Home.routeName,
      routes: {
        // Splash.routeName: (context) => Splash(),
        // LoginScreen.routeName: (context) => LoginScreen(),
        Home.routeName: (context) => Home(),
      },
    );
  }
}

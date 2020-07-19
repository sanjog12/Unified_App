import 'package:flutter/material.dart';
import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/screens/Wrapper.dart';
import 'package:unified_reminder/styles/colors.dart';

void main() {
  runApp(Bootstrapper());
}

class Bootstrapper extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: buttonColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          title: TextStyle(fontFamily: "ProximaNova"),
          body1: TextStyle(
            fontFamily: "ProximaNova",
            fontSize: 16.0,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      onGenerateRoute: onGenerateRoute,
      home: Wrapper(),
    );
  }
}
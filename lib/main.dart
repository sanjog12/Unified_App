import 'package:flutter/material.dart';
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
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Color(0xff4D5163);
                return null; // Use the component's default.
              },
            ),
          ),
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          headline6: TextStyle(fontFamily: "ProximaNova"),
          bodyText2: TextStyle(
            fontFamily: "ProximaNova",
            fontSize: 16.0,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: Wrapper(),
    );
  }
}
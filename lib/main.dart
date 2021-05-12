import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:unified_reminder/Bloc/AdsProvider.dart';
import 'package:unified_reminder/Bloc/DashboardProvider.dart';
import 'package:unified_reminder/screens/Wrapper.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';




void main() {
  // Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  // MobileAds.instance.initialize();
  final initAds = MobileAds.instance.initialize();
  final adState = AdState(initAds);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>DashboardProvider()),
        Provider.value(value: adState),
      ],
      child: Bootstrapper(),)
  );
}

class Bootstrapper extends StatefulWidget {
  @override
  _BootstrapperState createState() => _BootstrapperState();
}

class _BootstrapperState extends State<Bootstrapper>{
  
  bool initialized = false;
  bool error = false;
  
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // await MobileAds.instance.initialize();
      await Firebase.initializeApp();
      // String host = '10.0.2.2:8080';
      //
      // FirebaseFirestore firestore = FirebaseFirestore.instance;
      // firestore.settings = Settings(
      //   host: host,
      //   sslEnabled: false,
      // );
      
      setState(() {
        initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }
  
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
      home: initialized ? Wrapper():Container(),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unified_reminder/Bloc/AdsProvider.dart';
import 'package:unified_reminder/Bloc/DashboardProvider.dart';
import 'package:unified_reminder/screens/Wrapper.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';




void main() {
  // Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.init(
      "ab05a4ae-8f33-4fe5-a2a8-a1ae584e0b37",
      iOSSettings: {
        OSiOSSettings.autoPrompt: false,
        OSiOSSettings.inAppLaunchUrl: false
      }
  );
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

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
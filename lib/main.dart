import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:unified_reminder/Bloc/AdsProvider.dart';
import 'package:unified_reminder/Bloc/DashboardProvider.dart';
import 'package:unified_reminder/screens/Wrapper.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/NotificationWork.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';


final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  final initAds = MobileAds.instance.initialize();
  final adState = AdState(initAds);

  FirebaseMessaging.onBackgroundMessage(backGroundNotificationHandler);
  
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
      // FirebaseDatabase.instance.setPersistenceCacheSizeBytes(cacheSize)
      // await MobileAds.instance.initialize();
      await Firebase.initializeApp();
      // FirebaseFirestore.instance.settings = const Settings(
      //   host: 'http://10.0.2.2:9000',
      //   sslEnabled: false,
      //   persistenceEnabled: false,
      // );
      //
      // FirebaseDatabase(
      //   app: Firebase.app(),
      //   databaseURL: 'http://10.0.2.2:9000'
      // );
      AwesomeNotifications().initialize(
          'resource://drawable/ic_stat_name',
          [
            NotificationChannel(
                channelKey: 'basic_channel',
                channelName: 'Basic notifications',
                channelDescription: 'Notification channel for basic tests',
                defaultColor: Color(0xFF9D50DD),
                ledColor: Colors.white
            )
          ]
      );
      

      setState(() {
        initialized = true;
      });
    } catch(e) {
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    AwesomeNotifications().actionStream.forEach((element) {print(element.buttonKeyPressed);});
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
          headline6: TextStyle( fontFamily: "ProximaNova"),
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
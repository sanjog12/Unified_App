import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/screens/LoginPage.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/LocalNotificationServices.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';



class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  NotificationServices notificationServices = NotificationServices();
  DatabaseReference dbf;
  String firebaseUserId;
  FirebaseAuth user;
  FirebaseAuth auth;
  
  static Future<dynamic> backgroundMessage(Map<String, dynamic> message) async{
    print("background");
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
    }
    return Future<void>.value();
  }

  firebaseMessagingFCM() async{
    notificationServices.initializeSetting();
    print("called");
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    // firebaseMessaging.(
    //   onMessage: (Map<String,dynamic> message) async{
    //     print("on Message" + message.toString());
    //     for(var v in message.values){
    //       title = v["title"];
    //       body = v["body"];
    //     }
    //     notificationServices.setReminderNotification(id: 90,titleString: title,bodyString: body,scheduleTime: DateTime.now().add(Duration(seconds: 5)));
    //   },
    //   onBackgroundMessage:backgroundMessage,
    //   onLaunch: (Map<String,dynamic> message) async{
    //     print("on Launch" + message.toString());
    //   },
    //   onResume: (Map<String,dynamic> message) async{
    //     print("on Resume" + message.toString());
    //   },
    // );
    firebaseMessaging.requestPermission(sound: true, criticalAlert: true);
    await firebaseMessaging.getToken().then((value){
      print(value);
      dbf = firebaseDatabase.reference();
      dbf
          .child("FCMTokens")
          .child(value)
          .set({
        'token':value
      });
    });
    print("conpleted");
  }
  
  
  @override
  void initState() {
    super.initState();
    firebaseMessagingFCM();
    getUserFirebaseId();
//    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4569649492742996~2564391573');
  }

  Future<String> getUserFirebaseId() async {
    String _firebaseUserId = await SharedPrefs.getStringPreference("uid");
    this.setState(() {
      firebaseUserId = _firebaseUserId;
    });
    return _firebaseUserId;
  }

  @override
  Widget build(BuildContext context) {
    return firebaseUserId == null ? ShowCaseWidget(
      builder: Builder(
        builder: (context)=>LoginPage()
      ),
    )
        : StreamBuilder(
            stream: firestoreService.getUserDetails(firebaseUserId),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                print("hash data");
                return ShowCaseWidget(
                  builder: Builder(
                    builder: (context)=>Dashboard(),
                  ),
                );
              }
              return ShowCaseWidget(
                builder: Builder(
                  builder: (context)=>Dashboard(),
                ),
              );
            },
          );
  }
}

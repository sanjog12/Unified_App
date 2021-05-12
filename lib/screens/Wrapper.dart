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
  static NotificationServices notificationServices = NotificationServices();
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

  
  static firebaseMessagingFCM() async{
  
    final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference dbf;
    notificationServices.initializeSetting();
    print("called");
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    RemoteMessage initialMessage = await firebaseMessaging.getInitialMessage();
    
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    
    // FirebaseMessaging.onMessage.forEach((element) {element.notification.android.color})
    NotificationSettings settings = await firebaseMessaging.requestPermission(sound: true, criticalAlert: true,alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      provisional: false,);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    
    
    await firebaseMessaging.getToken().then(( String value){
      String uid = FirebaseAuth.instance.currentUser.uid?? "null";
      if(uid != "null") {
        dbf = firebaseDatabase.reference();
        dbf
            .child("FCMTokens")
            .child(uid)
            .set({value.substring(0, 10): value});
      }
    });
  }
  
  
  @override
  void initState() {
    super.initState();
    getUserFirebaseId();
    firebaseMessagingFCM();
  }

  Future<String> getUserFirebaseId() async {
    String _firebaseUserId = FirebaseAuth.instance.currentUser.uid;
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

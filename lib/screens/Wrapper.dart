
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/screens/LoginPage.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/NotificationWork.dart';



class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirestoreService firestoreService = FirestoreService();
  String firebaseUserId;
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if(snapshot.data.uid != null) {
            NotificationServices.firebaseMessagingFCM();
            return ShowCaseWidget(
              builder: Builder(
                builder: (context) => Dashboard(),
              ),
            );
          }
          return ShowCaseWidget(
            builder: Builder(
              builder: (context)=>LoginPage(),
            ),
          );
        }
        return ShowCaseWidget(
          builder: Builder(
            builder: (context)=>LoginPage(),
          ),
        );
      },
    );
  }
}

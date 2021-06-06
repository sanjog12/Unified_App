
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcase_widget.dart';
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
  void initState() {
    super.initState();
    getUserFirebaseId();
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
    ):
    StreamBuilder(
      stream: firestoreService.getUserDetails(firebaseUserId),
      builder: (BuildContext context, snapshot) {
        NotificationServices.firebaseMessagingFCM();
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

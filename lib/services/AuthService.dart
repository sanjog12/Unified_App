import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unified_reminder/models/personalDetail.dart';
import 'package:unified_reminder/models/userauth.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  UserBasic fromFirebaseUser(FirebaseUser user) {
    return user != null ? UserBasic(email: user.email, uid: user.uid) : null;
  }

  Stream<UserBasic> get user {
    return _auth.onAuthStateChanged.map(fromFirebaseUser);
  }

  Future<void> logOutUser() async {
  	try{
		  _auth.signOut();
      _googleSignIn.signOut();
		  SharedPrefs.setStringPreference("uid",null);
		  print("done");
	  }catch(e){
  	  print("error");
  		print(e);
	  }
  }
  
  
  Future<void> resetPassword(st,context) async{
    try {
      await _auth.sendPasswordResetEmail(email: st);
      flutterToast(message: "A link has been sent to your registered Email id for resetting your password");
      Navigator.pop(context);
    }on PlatformException catch(e){
      print("error");
      print(e.toString());
      flutterToast(message: "Looks like something went wrong.\nTry Again");
    }
  }

  Future<FirebaseUser> getFirebaseUser() async {
    return _auth.currentUser();
  }

  Future<UserBasic> registerProUser(UserBasic user) async {
    try {
      AuthResult newUser = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      await newUser.user.sendEmailVerification();
      flutterToast(message: "A verification link has been send to your Entered mail");
      _firestore.collection(FsUsersPath).document(newUser.user.uid).setData({
        "fullname": user.fullName,
        "phone": user.phoneNumber,
        "password": user.password,
        "progress": 1,
      });
      print('67');
      FirebaseMessaging firebaseMessaging = FirebaseMessaging();
      dbf = firebaseDatabase.reference();
      await firebaseMessaging.getToken().then((value){
        dbf
            .child("FCMTokens")
            .child(value)
            .set({
          'token':value
        });
      });
      print('12');
      AuthResult loginUser = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      SharedPrefs.setStringPreference("uid", loginUser.user.uid);
      print('34');
      return UserBasic(
        email: newUser.user.email,
        uid: newUser.user.uid,
        fullName: user.fullName,
      );
    } catch (e) {
      print("error");
      print(e);
      return null;
    }
  }
  
  
  Future<UserBasic> googlesignup(userType) async{
  	try{
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    AuthCredential authCredential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    
    
    AuthResult loginUser = await _auth.signInWithCredential(authCredential);
    _firestore.collection(FsUsersPath).document(loginUser.user.uid).setData({
      "fullname": loginUser.user.displayName,
      "phone": loginUser.user.phoneNumber,
      "password": "gooogle user",
      "progress": 1,
    });
    
    SharedPrefs.setStringPreference("uid", loginUser.user.uid);
    return UserBasic(
      email: loginUser.user.email,
      uid: loginUser.user.uid,
      fullName: loginUser.user.displayName,);
  	}
  	on PlatformException catch(e){
      flutterToast(message: 'Google Sign In failed');
      return null;
    }
    catch(e){
  	  print(e);
      flutterToast(message: "Something went wrong");
      return null;
    }
  }
  

  Future<UserBasic> loginUser(UserAuth authDetails) async {
    try {
      
      AuthResult user = await _auth.signInWithEmailAndPassword(
          email: authDetails.email, password: authDetails.password);
      SharedPrefs.setStringPreference("uid", user.user.uid);

      return UserBasic(
        email: user.user.email,
        uid: user.user.uid,
      );
    } on PlatformException catch (e) {
      print(e);
      throw PlatformException(
        message: "Wrong username / password",
        code: "403",
      );
    } catch (e) {
      return null;
    }
  }
  
  
  Future<UserBasic> googleLogIn() async {
    try{
      bool t = await _googleSignIn.isSignedIn();
      print(t);
      if(t== true){
        _googleSignIn.signOut();
      }
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential authCredential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      AuthResult loginUser = await _auth.signInWithCredential(authCredential);
      print(loginUser.user.uid);
      bool temp = loginUser.additionalUserInfo.isNewUser;
      if(temp){
        _firestore.collection(FsUsersPath).document(loginUser.user.uid).setData({
          "fullname": loginUser.user.displayName,
          "phone": loginUser.user.phoneNumber,
          "password": "gooogle user",
          "progress": 1,
        });
      }
      SharedPrefs.setStringPreference("uid", loginUser.user.uid);
      return UserBasic(
        email: loginUser.user.email,
        uid: loginUser.user.uid,
        fullName: loginUser.user.displayName,
      );
    }
    catch(e) {
      print(e);
      flutterToast(message: "Something went Wrong");
    }
  }

  Future<bool> setPersonalInformation(PersonalDetail personalDetail) async {
    String userFirebaseId = await SharedPrefs.getStringPreference("uid");
    try {
      await _firestore
          .collection(FsUsersPath)
          .document(userFirebaseId)
          .updateData(
        {
          "company_name": personalDetail.companyName,
          "constitution": personalDetail.constitution,
          "nature_of_business": personalDetail.natureOfBusiness,
          "progress": 2
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

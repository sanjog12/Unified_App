import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unified_reminder/models/personalDetail.dart';
import 'package:unified_reminder/models/userauth.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/services/GeneralServices/DocumentPaths.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  UserBasic fromFirebaseUser(User user) {
    return user != null ? UserBasic(email: user.email, uid: user.uid) : null;
  }

  Stream<UserBasic> get user {
    return _auth.authStateChanges().map(fromFirebaseUser);
  }

  Future<void> logOutUser() async {
  	try{
		  _auth.signOut();
      _googleSignIn.signOut();
	  } on FirebaseException catch(e){
  	  flutterToast(message: e.message);
    } on PlatformException catch(e){
  	  flutterToast(message: e.message);
    } catch(e){
  	  print("error");
  		print(e);
	  }
  }
  
  
  Future<void> resetPassword(st,context) async{
    try {
      await _auth.sendPasswordResetEmail(email: st);
      flutterToast(message: "A link has been sent to your registered Email id for resetting your password");
      Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      flutterToast(message: e.message);
    } on PlatformException catch(e){
      print("error");
      print(e.toString());
      flutterToast(message: "Looks like something went wrong.\nTry Again");
    }
  }

  Future<User> getFirebaseUser() async {
    return _auth.currentUser;
  }

  Future<UserBasic> registerProUser(UserBasic user) async {
    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      // await newUser.user.sendEmailVerification();
      flutterToast(message: "A verification link has been send to your Entered mail");
      _firestore.collection(FsUsersPath).doc(newUser.user.uid).set({
        "fullname": user.fullName,
        "phone": user.phoneNumber,
        "password": user.password,
        "progress": 1,
      });
      // print('67');
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      dbf = firebaseDatabase.reference();
      await firebaseMessaging.getToken().then(( String value){
        String uid = FirebaseAuth.instance.currentUser.uid?? null;
        if(uid != "null") {
          dbf = firebaseDatabase.reference();
          dbf
              .child("FCMTokens")
              .child(uid)
              .set({value.substring(0, 10): value});
        }
      });
      // print('12');
      UserCredential loginUser = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      // print('34');
      return UserBasic(
        email: newUser.user.email,
        uid: newUser.user.uid,
        fullName: user.fullName,
      );
    } on FirebaseAuthException catch(e){
      flutterToast(message: e.message);
    } on FirebaseException catch(e){
      flutterToast(message: e.message);
    } on PlatformException catch(e){
      flutterToast(message: e.message);
    } catch (e) {
      print("error");
      print(e);
      return null;
    }
  }
  
  
  Future<UserBasic> googleSignup(userType) async{
  	try{
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    
    
    var loginUser = await _auth.signInWithCredential(authCredential);
    _firestore.collection(FsUsersPath).doc(loginUser.user.uid).set({
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
  	} on FirebaseAuthException catch(e){
  	  flutterToast(message: e.message);
    } on PlatformException catch(e){
      flutterToast(message: 'Google Sign In failed');
      return null;
    }
    catch(e){
  	  print(e);
      flutterToast(message: "Something went wrong");
      return null;
    }
  }
  

  Future<UserBasic> loginUser(UserAuth authDetails, BuildContext context) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: authDetails.email, password: authDetails.password);
      bool temp = user.user.emailVerified;
      return UserBasic(
        email: user.user.email,
        uid: user.user.uid,
      );
    } on FirebaseAuthException catch(e){
      flutterToast(message: e.message);
    } on PlatformException catch (e) {
      flutterToast(message: e.message);
    } catch (e) {
      flutterToast(message: "");
    }
    return null;
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
      AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential loginUser = await _auth.signInWithCredential(authCredential);
      print(loginUser.user.uid);
      bool temp = loginUser.additionalUserInfo.isNewUser;
      if(temp){
        _firestore.collection(FsUsersPath).doc(loginUser.user.uid).set({
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
      );
    } on FirebaseAuthException catch(e){
      flutterToast(message: e.message);
    } on PlatformException catch (e) {
      flutterToast(message: e.message);
    } catch (e) {
      flutterToast(message: "");
    }
    return null;
  }

  Future<bool> setPersonalInformation(PersonalDetail personalDetail) async {
    String userFirebaseId = await SharedPrefs.getStringPreference("uid");
    try {
      await _firestore
          .collection(FsUsersPath)
          .doc(userFirebaseId)
          .update({
          "company_name": personalDetail.companyName,
          "constitution": personalDetail.constitution,
          "nature_of_business": personalDetail.natureOfBusiness,
          "progress": 2
        });
      return true;
    } catch (e) {
      return false;
    }
  }
}

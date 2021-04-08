import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  Future<bool> saveCompliances(List compliances) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    try {
      _firestore
          .collection(FsUserCompliances)
          .doc(firebaseUserId)
          .set({"compliances": compliances});
      return true;
    } catch (e) {
      return false;
    }
  }

//  Future<dynamic> getUserCompliances() async {
//    String userFirebaseId = await SharedPrefs.getStringPreference("uid");
//
//    return _firestore
//        .collection(FsUserCompliances)
//        .document(userFirebaseId)
//        .snapshots();
//  }

  Stream<List<Client>> getClients(String firebaseUserId) async* {
    List<Client> clientsData = [];
    dbf = firebaseDatabase
        .reference()
        .child(FsUserClients)
        .child(firebaseUserId)
        .child('clients');
    
    
    
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      for(var v in map.entries){
        Client client = Client(
            v.value["name"],
            v.value["constitution"],
            v.value["company"],
            v.value["natureOfBusiness"],
            v.value["email"],
            v.value["phone"],
            v.key
        );
        clientsData.add(client);
      }
    });
    
    
    
    yield clientsData;
  }
  
  Future<void> editClientData(Client client,String firebaseUID, List<String> temp, List<Compliance> compliances) async{
    
    try {
      dbf = firebaseDatabase.reference();
  
      dbf
          .child(FsUserClients)
          .child(firebaseUID)
          .child('clients')
          .child(client.key)
          .update({
        'name': client.name,
        'constitution': client.constitution,
        'company': client.company,
        'natureOfBusiness': client.natureOfBusiness,
        'email': client.email,
        'phone': client.phone.toString(),
      });

      String clientEmail = client.email.replaceAll('.', ',');

      for (var items in compliances){
        if (items.checked && !temp.contains(items.title)) {
          print(items.title);
          Map<String, String> clientCompliances = {
            'clientEmail': client.email,
            'title': items.title,
            'value': items.value
          };
          dbf
              .child(FsUserCompliances)
              .child(firebaseUID)
              .child('compliances')
              .child(clientEmail)
              .push()
              .set(clientCompliances);
        }
      }
    }catch(e){
      print(e);
    }
  }

  String getUserProgress(String firebaseUserId) {
    return _firestore
        .collection(FsUserClients)
        .doc(firebaseUserId)
        .collection('progress')
        .toString();
  }

  dynamic getUserDetails(firebaseUserId) {
    return _firestore
        .collection(FsUsersPath)
        .doc('firebaseUserId')
        .snapshots();
    
  }

//  Future<bool> addClientRecord(Client )

  Future<bool> addClient(Client client, List<Compliance> compliances, String code) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    
    try {
      Map<String, String> clientData = {
        'name': client.name,
        'constitution': client.constitution,
        'company': client.company,
        'natureOfBusiness': client.natureOfBusiness,
        'email': client.email,
        'phone': client.phone
      };
      
      String clientEmail = client.email.replaceAll('.', ',');
      print(clientEmail);
      dbf
          .child(FsUserClients)
          .child(firebaseUserId)
          .child('clients')
          .push()
          .set(clientData);

      for (var items in compliances){
        if (items.checked) {
          Map<String, String> clientCompliances = {
            'clientEmail': client.email,
            'title': items.title,
            'value': items.value
          };
          dbf
              .child(FsUserCompliances)
              .child(firebaseUserId)
              .child('compliances')
              .child(clientEmail)
              .push()
              .set(clientCompliances);
        }
      }
      
      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }
}

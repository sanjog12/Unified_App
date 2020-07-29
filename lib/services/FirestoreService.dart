import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';

class FirestoreService {
  final Firestore _firestore = Firestore.instance;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  Future<bool> saveCompliances(List compliances) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    try {
      _firestore
          .collection(FsUserCompliances)
          .document(firebaseUserId)
          .setData({"compliances": compliances});
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

  Future<List<Client>> getClients(String firebaseUserId) async {
    List<Client> clientsData = [];
    dbf = firebaseDatabase
        .reference()
        .child(FsUserClients)
        .child(firebaseUserId)
        .child('clients');
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
//        print(key);
        Client client = Client(
            values["name"],
            values["constitution"],
            values["company"],
            values["natureOfBusiness"],
            values["email"],
            values["phone"],
            key
        );
//        print(client.phone.toString());
        clientsData.add(client);
      });
    });
    return clientsData;
  }
  
  editClientData(Client client,String firebaseUID){
    
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
        'phone': client.phone
      });
    }catch(e){
      print(e);
    }
  }

  String getUserProgress(String firebaseUserId) {
    return _firestore
        .collection(FsUserClients)
        .document(firebaseUserId)
        .collection('progress')
        .toString();
  }

  dynamic getUserDetails(firebaseUserId) {
    return _firestore
        .collection(FsUsersPath)
        .document('firebaseUserId')
        .snapshots();
    
  }

//  Future<bool> addClientRecord(Client )

  Future<bool> addClient(Client client, List<Compliance> compliances) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    
    List mails = [];
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

      for (var items in compliances) {
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

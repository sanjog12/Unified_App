import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
import 'package:unified_reminder/services/GeneralServices/DocumentPaths.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';

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
  
  
  
  Future<void> deleteOtherUserDetails(List<Client> clientList) async{
  
    List<String> clientEmail = [];
    
    for(var client in clientList){
      clientEmail.add(client.email);
    }
  
    DatabaseReference databaseReference = firebaseDatabase
        .reference()
        .child(FsUserCompliances)
        .child(FirebaseAuth.instance.currentUser.uid.toString())
        .child('compliances');
    
    databaseReference.once().then((value){
      Map map = value.value;
      for(var key in map.keys){
        if(!clientEmail.contains(key)){
          databaseReference.child(key).remove();
          firebaseDatabase.reference()
              .child('usersUpcomingCompliances')
              .child('ZYESNIU7vnfmfL8CqfZPJIsNbNd2')
              .child(key).remove();
        }
      }
    });
    
  }
  
}

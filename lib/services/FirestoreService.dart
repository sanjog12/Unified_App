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

//
//  Stream getUserCompliances(String firebaseUserId) {
//    dbf = firebaseDatabase
//        .reference()
//        .child(FsUserCompliances)
//        .child(firebaseUserId)
//        .child('compliances');
//
//    dbf.once().then((DataSnapshot snapshot) {
//      Map<dynamic, dynamic> values = snapshot.value;
//      values.forEach((key, values) {
//        print(values["name"]);
//      });
//    });

//    return _firestore
//        .collection(FsUserCompliances)
//        .document(firebaseUserId)
//        .snapshots();
//  }

//  Future<dynamic> getClints() async {
//    String userFirebaseId = await SharedPrefs.getStringPreference("uid");
//
//    return _firestore
//        .collection(FsUserClients)
//        .document(userFirebaseId)
//        .snapshots();
//  }

//  Future<dynamic> getClientsData(String firebaseUserId) {
//    dbf = firebaseDatabase
//        .reference()
//        .child(FsUserClients)
//        .child(firebaseUserId)
//        .child('clients');
////    Stream data = dbf.onValue;
//    dbf.once().then((DataSnapshot snapshot) {
//      Map<dynamic, dynamic> values = snapshot.value;
//      values.forEach((key, values) {
//        print(values["name"]);
//      });
//    });
//  }

//  Stream getClients(String firebaseUserId) {
////    return _firestore
////        .collection(FsUserClients)
////        .document(firebaseUserId)
////        .collection('clients')
////        .snapshots();
//  }

  String getUserProgress(String firebaseUserId) {
    return _firestore
        .collection(FsUserClients)
        .document(firebaseUserId)
        .collection('progress')
        .toString();
  }

  dynamic getUserDetails(firebaseUserId) {
//    print(_firestore
//        .collection(FsUsersPath)
//        .document(firebaseUserId)
//        .snapshots()
//        .toString());
    return _firestore
        .collection(FsUsersPath)
        .document('firebaseUserId')
        .snapshots();
  }

//  Future<bool> addClientRecord(Client )

  Future<bool> addClient(Client client, List<Compliance> compliances) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

//    List _clients = clients.map<Client>((client) {
//      return client["client"];
//    }).toList();
//    List _compliances = client.map((compliance) {
//      return (compliance["compliances"]
//          .where((Compliance comp) => comp.checked)).toList();
//    }).toList();
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
//          _firestore
//              .collection(FsUserCompliances)
//              .document(firebaseUserId)
//              .collection('compliances')
//              .add(clientCompliances);
        }
      }

//          .collection(FsUserClients)
//          .document(firebaseUserId)
//          .collection('clients')
//          .add(clientData);
//          .({"clients": Client.clientListToMap(_clients)});

//      for (int j = 0; j < _compliances.length; j++) {
//        mails.add(_clients[j].email);
//      }
//      _firestore
//          .collection(FsUserCompliances)
//          .document(firebaseUserId)
//          .collection("compliances")
//          .add();
//              {"compliances": Compliance.complianceToMap(_compliances, mails)});
//              {"compliances": Compliance.complianceToMap(_compliances, mails)});
      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }
//
//  Future<bool> saveClients(List clients) async {
//    // String firebaseUserId = await SharedPrefs.getStringPreference("uid");
//    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
//    List _clients = clients.map<Client>((client) {
//      return client["client"];
//    }).toList();
//    List _compliances = clients.map((compliance) {
//      return (compliance["compliances"]
//          .where((Compliance comp) => comp.checked)).toList();
//    }).toList();
//    List mails = [];
//    try {
//      _firestore
//          .collection(FsUserClients)
//          .document(firebaseUserId)
//          .setData({"clients": Client.clientListToMap(_clients)});
//
//      for (int j = 0; j < _compliances.length; j++) {
//        mails.add(_clients[j].email);
//      }
//      _firestore.collection(FsUserCompliances).document(firebaseUserId).setData(
//          {"compliances": Compliance.complianceToMap(_compliances, mails)});
//      return true;
//    } catch (e) {
//      print("Here");
//      print(e);
//      return false;
//    }
//  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
import 'package:unified_reminder/models/TodayDateObject.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/DoneComplianceObject.dart';
import 'GeneralServices/DocumentPaths.dart';
import 'GeneralServices/SharedPrefs.dart';



class UpComingComplianceDatabaseHelper {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  static DateTime now = new DateTime.now();
  static DateTime date = new DateTime(now.year, now.month, now.day);

  static List<String> dateData = date.toString().split(' ');
  static String firebaseUID;
  static String fullDate = dateData[0];
  List<String> todayDateData = fullDate.toString().split('-');
  TodayDateObject todayDateObject;

  Future<List<DoneComplianceObject>> getClientDoneCompliances(
    String clientEmail,
    TodayDateObject todayDate,
    String snapshotKey,
  ) async {
    List<DoneComplianceObject> clientDone = [];
//    print('values1');

    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;
    dbf = firebaseDatabase
        .reference()
        .child('usersUpcomingCompliances')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(DateTime.now().year.toString())
        .child(DateTime.now().month.toString())
        .child(snapshotKey);

    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      
      if (values != null) {

        values.forEach((key, value) {
          clientDone.add(DoneComplianceObject(key: key, value: value));
        });
      }

      clientDone.add(DoneComplianceObject(key: null, value: null));
    });
    return clientDone;
  }
  
  
  
  

  Future<List<UpComingComplianceObject>> getUpComingCompliancesForMonth(List<Client> clientList) async {
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
    print("1");
    List<UpComingComplianceObject> upComingComplianceData = List.empty(growable: true);
  
    firebaseUID = FirebaseAuth.instance.currentUser.uid;
    
    
    for(var client in clientList){
      // print(client.name);
      dbf = firebaseDatabase
          .reference()
          .child(FsUserCompliances)
          .child(firebaseUID)
          .child('compliances')
          .child(client.email);
    
      await dbf.once().then((DataSnapshot snapshot) async{
        Map<dynamic, dynamic> map = snapshot.value;
        print(map);
        if(map != null){
        for(var registeredCompliancesData in map.values){
          // print(registeredCompliancesData.toString());
          
          if(registeredCompliancesData['title'] == 'LIC'){
            // print("LIC");
            await firebaseDatabase
                .reference()
                .child('complinces')
                .child('LICUserUpcomingCompliances')
                .child(firebaseUID)
                .child(client.email.replaceAll('.', ','))
                .orderByChild('date')
                .startAt('${todayDateObject.year}-${todayDateObject.month}-01')
                .endAt('${todayDateObject.year}-${todayDateObject.month}-31')
                .once().then((DataSnapshot snapshot) async{
                Map<dynamic, dynamic> valuesDate = await snapshot.value;
                if (valuesDate != null) {
                  for(var v in valuesDate.entries){
                    UpComingComplianceObject upComingComplianceObject =
                    UpComingComplianceObject(
                      key: "LIC",
                      name: client.name,
                      date: v.value['due'].toString().split(' ')[0],
                      label: 'LIC ' + v.value['label'].toString(),
                    );
                    bool isPassedDueDate = DateTime.now().isAfter(
                        DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),
                            int.parse(v.value['due'].toString().split(' ')[0])));
                    if(!isPassedDueDate){
                      upComingComplianceObject.notMissed = true;
                      upComingComplianceData.add(upComingComplianceObject);
                    }else{
                      upComingComplianceObject.notMissed = false;
                      upComingComplianceData.add(upComingComplianceObject);
                    }
                  }
                }
              },
            );
          }
          
          if(registeredCompliancesData['title'] == 'Income Tax'){
            List<DoneComplianceObject> doneCompliances = [];
            try {
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email, todayDateObject, "INCOME_TAX");
            }catch(e,stack){
              print(e);
              print(stack);
            }
            // print('Income Tax');
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('INCOME_TAX');
            
            await dbf.once().then((DataSnapshot snapshot) async{
              Map<dynamic, dynamic> valuesData = await snapshot.value;
              if (valuesData != null) {
                for(var v in doneCompliances){
                  valuesData.remove(v.key);
                }
                for(var v in valuesData.entries){
                  // print(client.name + "Income Tax added1");

                  bool isPassedDueDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(v.value['date'])));
                  if(!isPassedDueDate){
                  upComingComplianceData.add(
                      UpComingComplianceObject(
                      name: client.name, key: "Income Tax", date: v.value['date'].toString(),
                      label: v.value['label'] , notMissed: true,
                  ));
                  }else{
                    upComingComplianceData.add(
                        UpComingComplianceObject(
                            name: client.name, key: "Income Tax", notMissed: false,
                            date: v.value['date'].toString(), label: v.value['label']
                        ));
                  }
                  
                }
              }
            });
          }
  
          if(registeredCompliancesData['title']=='TDS'){
            // print("TDS");
            List<DoneComplianceObject> doneCompliances = [];
            try {
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email, todayDateObject, "TDS");
            }catch(e,stack){
              print(e);
              print(stack);
            }
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('TDS');
            
            await dbf.once().then((DataSnapshot snapshot) {
              Map<dynamic, dynamic> valuesDate = snapshot.value;
              if (valuesDate != null) {
                for(var v in doneCompliances){
                  valuesDate.remove(v.key);
                }
                for(var v in valuesDate.entries){
                  // print(client.name + "TDS added1");
                  bool isPassedDueDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(v.value['date'])));
                  if(!isPassedDueDate){
                    upComingComplianceData.add(UpComingComplianceObject(
                      name: client.name, date: v.value['date'].toString(),
                      label:v.value['label'], key: "TDS", notMissed: true,
                    ));
                  } else{
                    upComingComplianceData.add(UpComingComplianceObject(
                      name: client.name, date: v.value['date'].toString(),
                      label:v.value['label'], key: "TDS", notMissed: false,
                    ));
                  }
                  // print(client.name + "TDS added2");
                }
              }
              },
            );
          }
          
          if(registeredCompliancesData['title'] == 'GST'){
            List<DoneComplianceObject> doneCompliances = [];
            try{
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email.replaceAll('.', ','),
                  todayDateObject, "GST");
            }catch(e,stack){
              print(e);
              print(stack);
            }
            // print("GST");
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('GST');
            
            await dbf.once().then((DataSnapshot snapshot) async{
              Map<dynamic, dynamic> valuesDate = await snapshot.value;
              
              if (valuesDate != null) {
                for(var v in doneCompliances){
                  valuesDate.remove(v.key);
                }
                for(var v in valuesDate.entries){
                  // print(client.name + "GST added1");
                  bool isPassedDueDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(v.value['date'].toString())));
                  if(!isPassedDueDate){
                    upComingComplianceData.add(UpComingComplianceObject(
                      name: client.name, date: v.value['date'].toString(),
                      label: v.value['label'], key: "GST", notMissed: true,
                    ));
                  }else{
                    upComingComplianceData.add(UpComingComplianceObject(
                      name: client.name, date: v.value['date'].toString(),
                      label: v.value['label'], key: "GST", notMissed: false,
                    ));
                  }
                }
              }
              },
            );
          }
          
          if(registeredCompliancesData['title'] == 'ROC'){
            // print("ROC");
            
            dbf = firebaseDatabase.reference()
                .child('usersUpcomingCompliances')
                .child(firebaseUID)
                .child(client.email.replaceAll('.', ','))
                .child('ROC')
                .child(todayDateObject.month.toString());
            dbf.once().then((DataSnapshot snapshot) async{
              Map<dynamic,dynamic> valuesData = await snapshot.value;
              if(valuesData != null){
                for(var data in valuesData.entries){
                  UpComingComplianceObject upComingComplianceObject =UpComingComplianceObject(
                    name: client.name, key: "ROC",
                    date: data.value['date'], label: data.value['label'], notMissed: true,
                  );
                  bool isPassedDueDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),
                      int.parse(todayDateObject.month),
                      int.parse(upComingComplianceObject.date)));

                  if(!isPassedDueDate) {
                    upComingComplianceObject.notMissed = true;
                    upComingComplianceData.add(upComingComplianceObject);
                  }else{
                    upComingComplianceObject.notMissed = false;
                    upComingComplianceData.add(upComingComplianceObject);
                  }
                };
              }
            });
          }
          
          if(registeredCompliancesData['title'] == 'EPF'){
            List<DoneComplianceObject> doneCompliances = [];
            try {
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email, todayDateObject, "ESI");
            }catch(e,stack){
              print(e);
              print(stack);
            }
            
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('EPF');
  
            await dbf.once().then((DataSnapshot snapshot) async{
                Map<dynamic, dynamic> valuesDate = await snapshot.value;
                if (valuesDate != null) {
                  for(var compliances in doneCompliances){
                    valuesDate.remove(compliances.key);
                  }
                  for(var v in valuesDate.entries){
                    UpComingComplianceObject upComingComplianceObject =
                    UpComingComplianceObject(
                        date: v.value['date'].toString(),
                        label: v.value['label'],
                        key: "EPF",
                        name: client.name);
                    bool isPassedDueDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),
                        int.parse(todayDateObject.month),
                        int.parse(upComingComplianceObject.date)));

                    if(!isPassedDueDate) {
                      upComingComplianceObject.notMissed = true;
                      upComingComplianceData.add(upComingComplianceObject);
                    }else{
                      upComingComplianceObject.notMissed = false;
                      upComingComplianceData.add(upComingComplianceObject);
                    }
                  }
                }
              },
            );
          }
          
          if(registeredCompliancesData['title'] == 'ESI'){
            List<DoneComplianceObject> doneCompliances = [];
            try {
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email, todayDateObject, "ESI");
            }catch(e,stack){
              print(e);
              print(stack);
            }
            
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('ESI');
  
            await dbf.once().then((DataSnapshot snapshot) async{
              Map<dynamic, dynamic> valuesDate = await snapshot.value;
              if (valuesDate != null) {
                for(var compliances in doneCompliances){
                  valuesDate.remove(compliances.key);
                }
                for(var data in valuesDate.entries){
                  // print(data.value["date"]);
                  UpComingComplianceObject upComingComplianceObject =
                  UpComingComplianceObject(
                      date: data.value['date'].toString()  ?? '',
                      label: data.value['label'] ?? '',
                      name: client.name ?? '',
                      key: "ESI" ?? '');
                  // print(upComingComplianceObject.label);
                  bool isPassedDueDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
                  if(!isPassedDueDate) {
                    upComingComplianceObject.notMissed = true;
                    upComingComplianceData.add(upComingComplianceObject);
                  }else{
                    upComingComplianceObject.notMissed = false;
                    upComingComplianceData.add(upComingComplianceObject);
                  }
                  
                }
              }
            });
          }
        }}
      });
      
    }
    
    print("2");
    upComingComplianceData.sort((a,b){
      return int.tryParse(a.date).compareTo(int.tryParse(b.date,));
    });
    if(upComingComplianceData.length == 0){
      upComingComplianceData.add(UpComingComplianceObject(date: '', label: '', name: '', key: ''));
    }
    return upComingComplianceData;
  }

  
  
  
  Future<List<UpComingComplianceObject>>
      getUpComingCompliancesForMonthOfIncomeTax(Client client) async {
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
    
    List<UpComingComplianceObject> upComingComplianceData = [];

    List<DoneComplianceObject> doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email,
        todayDateObject, "INCOME_TAX");

    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('INCOME_TAX');

    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic, dynamic> valuesdata = await snapshot.value;
      print('15');
      if (valuesdata == null) {
        print('values5');
        UpComingComplianceObject upComingComplianceObject =
            UpComingComplianceObject(
                key: 'nothing',
                date: ' ',
                name: ' ',
                label: 'No Income-Tax Compliance in this month');
        upComingComplianceData.add(upComingComplianceObject);
      }else {
        print(doneCompliances.length);
        for(var v in doneCompliances){
          valuesdata.remove(v.key);
        }
        for(var v in valuesdata.entries){
          print(v.value["date"]);
          UpComingComplianceObject upComingComplianceObject =
          UpComingComplianceObject(
              date: v.value['date'].toString() ?? '',
              label: v.value['label'] ?? '',
              key: v.key ?? '');
          print(upComingComplianceObject.label);
          bool missedDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
          if(!missedDate) {
            upComingComplianceObject.notMissed = true;
            upComingComplianceData.add(upComingComplianceObject);
          }else{
            upComingComplianceObject.notMissed = false;
            upComingComplianceData.add(upComingComplianceObject);
          }
        }
      }
    });
    return upComingComplianceData;
  }

  
  
  Future<List<UpComingComplianceObject>> getUpComingCompliancesForMonthOfTDS(Client client) async {
  
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
  
    List<DoneComplianceObject> doneCompliances = [];
    try {
      doneCompliances = await UpComingComplianceDatabaseHelper()
          .getClientDoneCompliances(client.email,
          todayDateObject, "TDS");
    }catch(e){print(e);}

    List<UpComingComplianceObject> upComingComplianceData = [];

    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('TDS');

    await dbf.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> valuesDate = snapshot.value;
        if (valuesDate == null) {
          UpComingComplianceObject upComingComplianceObject =
              UpComingComplianceObject(
                  date: 'This Month', label: 'No TDS Compliance in this month');
          
          upComingComplianceData.add(upComingComplianceObject);
        } else {
          for(var v in doneCompliances){
            valuesDate.remove(v.key);
          }
          for(var v in valuesDate.entries){
            print(v.value["date"]);
            UpComingComplianceObject upComingComplianceObject =
            UpComingComplianceObject(
                date: v.value['date'].toString() ?? '',
                label: v.value['label'] ?? '',
                key: v.key ?? '');
            print(upComingComplianceObject.label);
            bool missedDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
            if(!missedDate){
              upComingComplianceObject.notMissed = true;
              upComingComplianceData.add(upComingComplianceObject);
            }else{
              upComingComplianceObject.notMissed =false;
              upComingComplianceData.add(upComingComplianceObject);
            }
            
          }
//          valuesdate.forEach((key, values) {
//            UpComingComplianceObject upComingComplianceObject =
//                UpComingComplianceObject(
//                    date: values['date'].toString(),
//                    label: values['label'],
//                    key: key);
//            UpComingComplinceData.add(upComingComplianceObject);
//          });
        }
      },
    );
    print("Returning");
    print(upComingComplianceData.length);
    return upComingComplianceData;
  }

  
  
  Future<List<UpComingComplianceObject>> getUpComingCompliancesForMonthOfESI(Client client) async {
  
    List<DoneComplianceObject> doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email, todayDateObject, "ESI");
    
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
  
    List<UpComingComplianceObject> upComingComplianceData = [];
  
    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('ESI');
  
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic, dynamic> valuesDate = await snapshot.value;
      if (valuesDate != null) {
        for(var v in doneCompliances){
          valuesDate.remove(v.key);
        }
        for(var v in valuesDate.entries){
          print(v.value["date"]);
          UpComingComplianceObject upComingComplianceObject =
          UpComingComplianceObject(
              date: v.value['date'].toString() ?? '',
              label: v.value['label'] ?? '',
              key: v.key ?? '');
          print(upComingComplianceObject.label);
          bool missedDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
          if(!missedDate){
            upComingComplianceObject.notMissed = true;
            upComingComplianceData.add(upComingComplianceObject);
          }else{
            upComingComplianceObject.notMissed= false;
            upComingComplianceData.add(upComingComplianceObject);
          }
        }
      }
    });
    return upComingComplianceData;
  }



  Future<List<UpComingComplianceObject>> getUpComingCompliancesForMonthOfLIC(Client client) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
  
    List<UpComingComplianceObject> upComingComplianceData = [];
    
    await FirebaseDatabase.instance
        .reference()
        .child('complinces')
        .child('LICUserUpcomingCompliances')
        .child(firebaseUserId)
        .child(client.email)
        .orderByChild('date')
        .startAt('${todayDateObject.year}-${todayDateObject.month}-01')
        .endAt('${todayDateObject.year}-${todayDateObject.month}-31').once()
        .then((DataSnapshot snapshot) async{
          Map<dynamic, dynamic> valuesDate = await snapshot.value;
          UpComingComplianceObject upComingComplianceObject;
          print(valuesDate);
          if (valuesDate != null) {
          for(var compliance in valuesDate.entries) {
            print(compliance);
            upComingComplianceObject = UpComingComplianceObject(
              name: compliance.value["type"] ?? '',
              date: compliance.value["due"] ?? '',
              label: compliance.value["label"] ?? '',
              notMissed: true,
            );
  
            bool isPassedDueDate = DateTime.now().isAfter(
                DateTime(int.parse(todayDateObject.year), int.parse(todayDateObject.month),
                    int.parse(upComingComplianceObject.date.split(" ")[0])));
  
            if (isPassedDueDate) {
              upComingComplianceObject.notMissed = false;
            }
            upComingComplianceData.add(upComingComplianceObject);
          }
          
        }else {
          upComingComplianceObject =
          UpComingComplianceObject(date: 'this month of', label: 'No LIC Compliance',name: '',notMissed: true);
  
          upComingComplianceData.add(upComingComplianceObject);
        }
      },
    );
    
    return upComingComplianceData;
  }
  
  
  
  Future<List<UpComingComplianceObject>>
      getUpComingCompliancesForMonthOfGST(Client client) async {
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);


    List<DoneComplianceObject> doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email, todayDateObject, "GST");
    
    print(doneCompliances.first);
    print("done compliances length" + doneCompliances.length.toString());
    List<UpComingComplianceObject> upComingComplianceData = [];


    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('GST');
    
    print(todayDateObject.year + " / " + todayDateObject.month + " / " + todayDateObject.day);

    await dbf.once().then((DataSnapshot snapshot) async{
        Map<dynamic, dynamic> valuesData = await snapshot.value;
          if (valuesData != null) {
            print(valuesData);
            for (var v in doneCompliances) {
              valuesData.remove(v.key);
            }
            for (var v in valuesData.entries) {
              // print(v.value["date"]);
              UpComingComplianceObject upComingComplianceObject =
              UpComingComplianceObject(
                  date: v.value['date'].toString() ?? '',
                  label: v.value['label'] ?? '',
                  key: v.key ?? '',);
              bool isPassedDueDate = DateTime.now().isAfter(
                  DateTime(int.parse(todayDateObject.year),
                  int.parse(todayDateObject.month),
                  int.parse(upComingComplianceObject.date)));
              print(isPassedDueDate);
              if (!isPassedDueDate) {
                upComingComplianceObject.notMissed = true;
                upComingComplianceData.add(upComingComplianceObject);
              }else{
                upComingComplianceObject.notMissed = false;
                upComingComplianceData.add(upComingComplianceObject);
              }
            }
          }
      },
    );
    
    print("lenght returning :" + upComingComplianceData.length.toString());
    return upComingComplianceData;
  }

  
  
  Future<List<UpComingComplianceObject>> getUpcomingCompliancesForMonthEPF(Client client) async{
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);

    List<DoneComplianceObject> doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email,
        todayDateObject, "EPF");
    List<UpComingComplianceObject> upComingComplianceData = [];
  
    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('EPF');

    await dbf.once().then(
          (DataSnapshot snapshot) async{
        Map<dynamic, dynamic> valuesDate = await snapshot.value;
        if (valuesDate == null) {
          UpComingComplianceObject upComingComplianceObject =
          UpComingComplianceObject(
              date: 'This Month', label: 'No EPF Payment this month');
          upComingComplianceData.add(upComingComplianceObject);
        }else {
          for(var v in doneCompliances){
            valuesDate.remove(v.key);
          }
          for(var v in valuesDate.entries){
            print(v.value["date"]);
            UpComingComplianceObject upComingComplianceObject =
            UpComingComplianceObject(
                date: v.value['date'].toString() ?? '',
                label: v.value['label'] ?? '',
                key: v.key ?? '',
            );
            
            bool missedDate = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
            if(!missedDate){
              upComingComplianceObject.notMissed = true;
              upComingComplianceData.add(upComingComplianceObject);
            }
            else{
              upComingComplianceObject.notMissed = false;
              upComingComplianceData.add(upComingComplianceObject);
            }
            
          }
        }
      },
    );
    
//    for(int i =0 ; i<upComingComplianceData.length;i++){
//      print(i);
//      print(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceData[i].date)));
//      bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceData[i].date)));
//      print(t);
//      print(upComingComplianceData[i].date);
//      if(t){
//        print(upComingComplianceData.length);
//        upComingComplianceData.removeAt(i);
//        print(upComingComplianceData.length);
//      }
//    }
    
    return upComingComplianceData;
  }
  
}

import 'package:firebase_database/firebase_database.dart';
import 'package:unified_reminder/models/TodayDateObject.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/doneComplianceObject.dart';
import 'DocumentPaths.dart';
import 'SharedPrefs.dart';

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

  Future<List<doneComplianceObject>> getClientDoneCompliances(
    String clientEmail,
    TodayDateObject todayDate,
    String snapshotKey,
  ) async {
    List<doneComplianceObject> clientDones = [];
//    print('values1');

    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase
        .reference()
        .child('usersUpcomingCompliances')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(DateTime.now().year.toString())
        .child(DateTime.now().month.toString())
        .child(snapshotKey);
    print('values2');

    await dbf.once().then((DataSnapshot snapshot) {
      print('1122');
      print(snapshot.value);
      Map<dynamic, dynamic> values = snapshot.value;
      print(values);

      if (values != null) {
        print('values4');

        values.forEach((key, value) {
          clientDones.add(doneComplianceObject(key: key, value: value));
        });
      } else
        print('values7');

      clientDones.add(doneComplianceObject(key: null, value: null));
    });
    return clientDones;
  }
  
  
  
  

  Future<List<UpComingComplianceObject>> getUpComingComplincesForMonth(List<Client> clientList) async {
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);

    List<UpComingComplianceObject> UpComingComplinceData = [];
  
    firebaseUID = await SharedPrefs.getStringPreference('uid');
    
    
    loop(Client p) async{
      print(p.name);
      dbf = firebaseDatabase
          .reference()
          .child(FsUserCompliances)
          .child(firebaseUID)
          .child('compliances')
          .child(p.email);
    
      await dbf.once().then((DataSnapshot snapshot) async{
        Map<dynamic, dynamic> map = snapshot.value;
        for(var v in map.values){
          print(v.toString());
          
          if(v['title'] == 'LIC'){
            print("LIC");
            dbf = firebaseDatabase
                .reference()
                .child('complinces')
                .child('LICUserUpcomingCompliances')
                .child(firebaseUID)
                .child(p.email.replaceAll('.', ","))
                .child(todayDateObject.year)
                .child(todayDateObject.month);

            await dbf.once().then(
                  (DataSnapshot snapshot) {
                Map<dynamic, dynamic> valuesdate = snapshot.value;
                if (valuesdate != null) {
                  print(valuesdate);
                  for(var v in valuesdate.entries){
                    print(v.key);
                    UpComingComplianceObject upComingComplianceObject =
                    UpComingComplianceObject(
                      key: "LIC",
                      name: p.name,
                      date: v.value['date'].toString(),
                      label: v.value['label'].toString(),
                    );
                    bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(v.value['date'])));
                    if(!t)
                      UpComingComplinceData.add(upComingComplianceObject);
                  }
                }else {
                  UpComingComplianceObject upComingComplianceObject =
                  UpComingComplianceObject(
                      date: ' ', label: ' ',name: p.name);

                  UpComingComplinceData.add(upComingComplianceObject);
                }
              },
            );
          }
          
          if(v['title'] == 'Income Tax'){
            List<doneComplianceObject> doneCompliances = [];
            try {
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(p.email, todayDateObject, "INCOME_TAX");
            }catch(e){
              print(e);
            }
            print('Income Tax');
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('INCOME_TAX');
            
            await dbf.once().then((DataSnapshot snapshot) async{
              Map<dynamic, dynamic> valuesdata = await snapshot.value;
              print('15');
              if (valuesdata == null) {
                UpComingComplinceData.add(UpComingComplianceObject(
                  name: p.name,
                  date: ' ',
                  label: " ",
                ));
              } else {
                for(var v in doneCompliances){
                  valuesdata.remove(v.key);
                }
                for(var v in valuesdata.entries){
                  print(p.name + "Income Tax added1");

                  bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(v.value['date'])));
                  if(!t){
                  UpComingComplinceData.add(UpComingComplianceObject(
                      name: p.name,
                      key: "Income Tax",
                      date: v.value['date'].toString(),
                      label: v.value['label']
                  ));}
                  print(p.name + "Income Tax added2");
                }
              }
            });
          }
  
          if(v['title']=='TDS'){
            print("TDS");
            List<doneComplianceObject> doneCompliances = [];
            try {
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(p.email, todayDateObject, "TDS");
            }catch(e){
              print(e);
            }
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('TDS');
            
            await dbf.once().then(
                  (DataSnapshot snapshot) {
                    Map<dynamic, dynamic> valuesdate = snapshot.value;
                    if (valuesdate == null) {
                      UpComingComplinceData.add(UpComingComplianceObject(
                        name: p.name,
                        date: " ",
                        label: " ",
                      ));
                    } else {
                      for(var v in doneCompliances){
                        valuesdate.remove(v.key);
                      }
                      for(var v in valuesdate.entries){
                        print(p.name + "TDS added1");
                        bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(v.value['date'])));
                        if(!t){
                        UpComingComplinceData.add(UpComingComplianceObject(
                          name: p.name,
                          date: v.value['date'].toString(),
                          label:v.value['label'],
                          key: "TDS",
                        ));}
                        print(p.name + "TDS added2");
                      }
                    }
                    },
            );
          }
          
          if(v['title'] == 'GST'){
            List<doneComplianceObject> doneCompliances = [];
            try{
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(p.email.replaceAll('.', ','),
                  todayDateObject, "GST");
            }catch(e){
              print(e);
            }
            print("GST");
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('GST');
            
            await dbf.once().then(
                  (DataSnapshot snapshot) async{
                    Map<dynamic, dynamic> valuesdate = snapshot.value;
                    
                    if (valuesdate == null) {
                      UpComingComplinceData.add(UpComingComplianceObject(
                        name: p.name,
                        date: " ",
                        label: " ",
                      ));
                    } else {
                      for(var v in doneCompliances){
                        valuesdate.remove(v.key);
                      }
                      for(var v in valuesdate.entries){
                        print(p.name + "GST added1");
                        bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(v.value['date'].toString())));
                        if(!t){
                        UpComingComplinceData.add(UpComingComplianceObject(
                          name: p.name,
                          date: v.value['date'].toString(),
                          label: v.value['label'],
                          key: "GST",
                        ));}
                      }
                    }
                    },
            );
          }
          
          if(v['title'] == 'ROC'){
            print("ROC");
            
            dbf = firebaseDatabase.reference()
                .child('usersUpcomingCompliances')
                .child(firebaseUID)
                .child(p.email.replaceAll('.', ','))
                .child('ROC')
                .child(todayDateObject.month.toString());
            dbf.once().then((DataSnapshot snapshot) async{
              Map<dynamic,dynamic> v = snapshot.value;
              if(v == null){
                UpComingComplinceData.add(UpComingComplianceObject(
                  name: p.name,
                  date: " ",
                  label: " ",
                ));
              }
              else{
                v.forEach((key, values){
                  print('ROC   ' +key);
                  UpComingComplinceData.add(UpComingComplianceObject(
                    name: p.name,
                    key: "ROC",
                    date: values['date'],
                    label: values['label'],
                  ));
                });
              }
            });
          }
          
          if(v['title'] == 'EPF'){
            List<doneComplianceObject> doneCompliances = [];
            try {
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(p.email, todayDateObject, "ESI");
            }catch(e){
              print(e);
            }
            
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('EPF');
  
            await dbf.once().then((DataSnapshot snapshot) {
                Map<dynamic, dynamic> valuesdate = snapshot.value;
                if (valuesdate == null) {
                  UpComingComplianceObject upComingComplianceObject =
                  UpComingComplianceObject(
                      date: ' ', label: ' ',name: p.name);
                  UpComingComplinceData.add(upComingComplianceObject);
                } else {
                  for(var v in doneCompliances){
                    valuesdate.remove(v.key);
                  }
                  for(var v in valuesdate.entries){
                    UpComingComplianceObject upComingComplianceObject =
                    UpComingComplianceObject(
                        date: v.value['date'].toString(),
                        label: v.value['label'],
                        key: "EPF",
                        name: p.name);
                    bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
                    if(!t)
                      UpComingComplinceData.add(upComingComplianceObject);
                  }
                }
              },
            );
          }
          
          if(v['title'] == 'ESI'){
            List<doneComplianceObject> doneCompliances = [];
            try {
              doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(p.email, todayDateObject, "ESI");
            }catch(e){
              print(e);
            }
            
            dbf = firebaseDatabase
                .reference()
                .child('upCommingComliances')
                .child(todayDateObject.month.toString())
                .child('ESI');
  
            await dbf.once().then((DataSnapshot snapshot) async{
              Map<dynamic, dynamic> valuesdate = await snapshot.value;
              if (valuesdate == null) {
                UpComingComplianceObject upComingComplianceObject =
                UpComingComplianceObject(
                    date: ' ', label: 'No TDS Compliance in this month');
                UpComingComplinceData.add(upComingComplianceObject);
              } else {
                for(var v in doneCompliances){
                  valuesdate.remove(v.key);
                }
                for(var v in valuesdate.entries){
                  print(v.value["date"]);
                  UpComingComplianceObject upComingComplianceObject =
                  UpComingComplianceObject(
                      date: v.value['date'].toString(),
                      label: v.value['label'],
                      name: 'ESI',
                      key: v.key);
                  print(upComingComplianceObject.label);
                  bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
                  if(!t)
                    UpComingComplinceData.add(upComingComplianceObject);
                }
              }
            });
          }
        }
      });
    }
    
    
    for(var p in clientList){
      await loop(p);
      print(UpComingComplinceData.length);
      print("check    " +UpComingComplinceData[0].name);
    }
    
    print("done");
    return UpComingComplinceData;
  }

  
  
  
  Future<List<UpComingComplianceObject>>
      getUpComingComplincesForMonthOfIncomeTax(Client client) async {
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
    
    List<UpComingComplianceObject> UpComingComplinceData = [];

    List<doneComplianceObject> doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email,
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
        UpComingComplinceData.add(upComingComplianceObject);
      }else {
        print(doneCompliances.length);
        for(var v in doneCompliances){
          valuesdata.remove(v.key);
        }
        for(var v in valuesdata.entries){
          print(v.value["date"]);
          UpComingComplianceObject upComingComplianceObject =
          UpComingComplianceObject(
              date: v.value['date'].toString(),
              label: v.value['label'],
              key: v.key);
          print(upComingComplianceObject.label);
          bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
          if(!t)
            UpComingComplinceData.add(upComingComplianceObject);
        }
      }
    });
    return UpComingComplinceData;
  }

  
  
  Future<List<UpComingComplianceObject>>
      getUpComingComplincesForMonthOfTDS(Client client) async {
  
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
  
    List<doneComplianceObject> doneCompliances = [];
    try {
      doneCompliances = await UpComingComplianceDatabaseHelper()
          .getClientDoneCompliances(client.email,
          todayDateObject, "TDS");
    }catch(e){print(e);}

    List<UpComingComplianceObject> UpComingComplinceData = [];

    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('TDS');

    await dbf.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> valuesdate = snapshot.value;
        if (valuesdate == null) {
          UpComingComplianceObject upComingComplianceObject =
              UpComingComplianceObject(
                  date: 'This Month', label: 'No TDS Compliance in this month');
          
          UpComingComplinceData.add(upComingComplianceObject);
        } else {
          for(var v in doneCompliances){
            valuesdate.remove(v.key);
          }
          for(var v in valuesdate.entries){
            print(v.value["date"]);
            UpComingComplianceObject upComingComplianceObject =
            UpComingComplianceObject(
                date: v.value['date'].toString(),
                label: v.value['label'],
                key: v.key);
            print(upComingComplianceObject.label);
            bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
            if(!t)
              UpComingComplinceData.add(upComingComplianceObject);
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
    print(UpComingComplinceData.length);
    return UpComingComplinceData;
  }

  
  
  Future<List<UpComingComplianceObject>>
  getUpComingComplincesForMonthOfESI(Client client) async {
  
    List<doneComplianceObject> doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email,
        todayDateObject, "ESI");
    
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
  
    List<UpComingComplianceObject> upComingComplinceData = [];
  
    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('ESI');
  
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic, dynamic> valuesdate = await snapshot.value;
      if (valuesdate == null) {
        UpComingComplianceObject upComingComplianceObject =
        UpComingComplianceObject(
            date: ' ', label: 'No TDS Compliance in this month');
      
        upComingComplinceData.add(upComingComplianceObject);
      } else {
        for(var v in doneCompliances){
          valuesdate.remove(v.key);
        }
        for(var v in valuesdate.entries){
          print(v.value["date"]);
          UpComingComplianceObject upComingComplianceObject =
          UpComingComplianceObject(
              date: v.value['date'].toString(),
              label: v.value['label'],
              key: v.key);
          print(upComingComplianceObject.label);
          bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
          if(!t)
            upComingComplinceData.add(upComingComplianceObject);
        }
      }
    });
    return upComingComplinceData;
  }



  Future<List<UpComingComplianceObject>> getUpComingCompliancesForMonthOfLIC(Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
  
    List<UpComingComplianceObject> UpComingComplinceData = [];
    
    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('LICUserUpcomingCompliances')
        .child(firebaseUserId)
        .child(client.email)
        .child(todayDateObject.year)
        .child(todayDateObject.month);
  
    await dbf.once().then(
          (DataSnapshot snapshot) {
        Map<dynamic, dynamic> valuesdate = snapshot.value;
        if (valuesdate != null) {
          print(valuesdate);
          valuesdate.forEach((key, value){
            print(key);
            UpComingComplianceObject upComingComplianceObject =
            UpComingComplianceObject(
              name: value["type"],
              date: value["date"],
              label: value["label"],
            );
            UpComingComplinceData.add(upComingComplianceObject);
          });
        }else {
          UpComingComplianceObject upComingComplianceObject =
          UpComingComplianceObject(
              date: 'this month of', label: 'No LIC Compliance',name: '');
  
          UpComingComplinceData.add(upComingComplianceObject);
        }
      },
    );
    print("returning");
    return UpComingComplinceData;
  }
  
  
  
  Future<List<UpComingComplianceObject>>
      getUpComingComplincesForMonthOfGST(Client client) async {
    todayDateObject = TodayDateObject(
        year: todayDateData[2], month: todayDateData[1], day: todayDateData[0]);


    List<doneComplianceObject> doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email,
        todayDateObject, "GST");
    print(doneCompliances.first);
    print(doneCompliances.length);
    List<UpComingComplianceObject> UpComingComplinceData = [];


    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('GST');

    await dbf.once().then((DataSnapshot snapshot) async{
        Map<dynamic, dynamic> valuesData = await snapshot.value;
          if (valuesData == null) {
            UpComingComplianceObject upComingComplianceObject =
            UpComingComplianceObject(
                date: 'This Month', label: 'No GST Compliance in this month');
    
            UpComingComplinceData.add(upComingComplianceObject);
          } else {
            print(valuesData);
            for(var v in doneCompliances){
              valuesData.remove(v.key);
            }
            for(var v in valuesData.entries){
              print(v.value["date"]);
              UpComingComplianceObject upComingComplianceObject =
              UpComingComplianceObject(
                  date: v.value['date'].toString(),
                  label: v.value['label'],
                  key: v.key);
              print(upComingComplianceObject.label);
              bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
              if(!t)
                UpComingComplinceData.add(upComingComplianceObject);
            }
          }
      },
    );
    
    print('returning');
    return UpComingComplinceData;
  }

  
  
  Future<List<UpComingComplianceObject>> getUpcomingCompliancesForMonthEPF(Client client) async{
    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);

    List<doneComplianceObject> doneCompliances = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(client.email,
        todayDateObject, "EPF");
    List<UpComingComplianceObject> UpComingComplinceData = [];
  
    dbf = firebaseDatabase
        .reference()
        .child('upCommingComliances')
        .child(todayDateObject.month.toString())
        .child('EPF');

    await dbf.once().then(
          (DataSnapshot snapshot) async{
        Map<dynamic, dynamic> valuesdate = await snapshot.value;
        if (valuesdate == null) {
          UpComingComplianceObject upComingComplianceObject =
          UpComingComplianceObject(
              date: 'This Month', label: 'No EPF Payment this month');
          UpComingComplinceData.add(upComingComplianceObject);
        }else {
          for(var v in doneCompliances){
            valuesdate.remove(v.key);
          }
          for(var v in valuesdate.entries){
            print(v.value["date"]);
            UpComingComplianceObject upComingComplianceObject =
            UpComingComplianceObject(
                date: v.value['date'].toString(),
                label: v.value['label'],
                key: v.key);
            print(upComingComplianceObject.label);
            bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(upComingComplianceObject.date)));
            if(!t)
              UpComingComplinceData.add(upComingComplianceObject);
          }
        }
      },
    );
    
//    for(int i =0 ; i<UpComingComplinceData.length;i++){
//      print(i);
//      print(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(UpComingComplinceData[i].date)));
//      bool t = DateTime.now().isAfter(DateTime(int.parse(todayDateObject.year),int.parse(todayDateObject.month),int.parse(UpComingComplinceData[i].date)));
//      print(t);
//      print(UpComingComplinceData[i].date);
//      if(t){
//        print(UpComingComplinceData.length);
//        UpComingComplinceData.removeAt(i);
//        print(UpComingComplinceData.length);
//      }
//    }
    print("returning");
    return UpComingComplinceData;
  }
  
}

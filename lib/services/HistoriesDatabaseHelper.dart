import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/MutualFundObject.dart';
import 'package:unified_reminder/models/PaymentHistory.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForIncomeTax.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForROC.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/history/HistoryMF.dart';

import 'MutualFundHelper.dart';
import 'SharedPrefs.dart';

class HistoriesDatabaseHelper {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  Future<List<HistoryComplinceObjectForIncomeTax>>
      getComplincesHistoryOfIncomeTax(Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');

    List<HistoryComplinceObjectForIncomeTax> complinceData = [];
    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('IncomeTaxPayments')
        .child(firebaseUserId)
        .child(clientEmail);
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      if (values != null) {
        values.forEach((key, values) {
//        print(key);
          HistoryComplinceObjectForIncomeTax historyComplinceObject =
              HistoryComplinceObjectForIncomeTax(
            date: values["dateOfPayment"],
            amount: values['amountOfPayment'],
            type: 'INCOME_TAX',
            key: key,
          );
          complinceData.add(historyComplinceObject);
        });
      }
    });
    dbf = firebaseDatabase.reference()
        .child('complinces')
        .child('IncomeTaxReturnFillings')
        .child(firebaseUserId)
        .child(clientEmail);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          HistoryComplinceObjectForIncomeTax historyComplinceObject =
          HistoryComplinceObjectForIncomeTax(
            date: values["dateOfFilledReturns"],
            amount: values["attachemnt"],
            type: 'INCOME_TAX_Return',
            key: key,
          );
          complinceData.add(historyComplinceObject);
        });
      }
    });
    
    if(complinceData.length == 0){
      HistoryComplinceObjectForIncomeTax historyComplinceObject =
      HistoryComplinceObjectForIncomeTax(
        date: "Record Not found",
        amount: " ",
        type: ' ',
      );
      complinceData.add(historyComplinceObject);
    }
    return complinceData;
  }
  
  
  Future<List<HistoryComplinceObject>> getComplincesHistoryOfTDS(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');

    List<HistoryComplinceObject> complinceData = [];
    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('TDSPayments')
        .child(firebaseUserId)
        .child(clientEmail);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          HistoryComplinceObject historyComplinceObject =
              HistoryComplinceObject(
            date: values["dateOfPayment"],
            amount: values['amountOfPayment'],
            type: values['section'],
            key: key,
          );
          complinceData.add(historyComplinceObject);
        });
      }
    });
    
    dbf = firebaseDatabase
          .reference()
          .child('complinces')
          .child('TDSQuarterlyReturns')
          .child(firebaseUserId)
          .child(clientEmail);
    await dbf.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
//        print(key);
          HistoryComplinceObject historyComplinceObject =
          HistoryComplinceObject(
            date: values['dateOfFilledReturns'],
            amount: values['nameOfForm'],
            type: values['acknowledgementNo'],
            key: key,
          );
          complinceData.add(historyComplinceObject);
        });
      }
    });
    
    return complinceData;
  }

  Future<List<HistoryComplinceObject>> getComplincesHistoryOfGST(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');

    List<HistoryComplinceObject> complinceData = [];
    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('GSTPayments')
        .child(firebaseUserId)
        .child(clientEmail);
   // Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, value) {
          print(value);
          HistoryComplinceObject historyComplinceObject =
              HistoryComplinceObject(
            date: value["dueDate"],
            amount: value['amountOfPayment'],
            type: value['section'],
            key: key,
          );
          complinceData.add(historyComplinceObject);
        });
      }
    });
    dbf = firebaseDatabase.reference()
        .child('complinces')
        .child('GSTReturnFillings')
        .child(firebaseUserId)
        .child(clientEmail);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, value) {
          print(value);
          HistoryComplinceObject historyComplinceObject =
          HistoryComplinceObject(
            date: value['dateOfFilledReturns'],
            amount: value['attachment'],
            type: 'GSTR_1_QUARTERLY',
            key: key,
          );
          complinceData.add(historyComplinceObject);
        });
      }
    });
    return complinceData;
  }

  
  Future<List<HistoryComplinceObject>> getComplincesHistoryOfESI(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');
    
    

    print(clientEmail);

    List<HistoryComplinceObject> complinceData = [];
    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('ESIMonthlyContributionPayments')
        .child(firebaseUserId)
        .child(clientEmail);
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          print(key);
          HistoryComplinceObject historyComplinceObject =
              HistoryComplinceObject(
            date: values["dateOfFilling"],
            amount: values['amountOfPayment'],
            type: 'Monthly Contribution',
            key: key,
          );
          complinceData.add(historyComplinceObject);
        });
      } else {
        complinceData.add(HistoryComplinceObject(
            date: 'No History Found', amount: ' ', type: ''));
      }
    });
    return complinceData;
  }

  Future<List<HistoryComplinceObject>> getCompliancesHistoryOfEPF(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');

    print(clientEmail);

    List<HistoryComplinceObject> complianceData = [];

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('MonthlyContributionPayments')
        .child(firebaseUserId)
        .child(clientEmail);
//    Stream data = dbf.onValue;
  
    await dbf.once().then((snapshot){
      print("changed");
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          print(key);
          HistoryComplinceObject historyComplinceObject =
              HistoryComplinceObject(
            date: values["dateOfFilling"],
            amount: values['amountOfPayment'],
            type: 'Monthly Contribution',
            key: key,
          );
          complianceData.add(historyComplinceObject);
          
        });
      }
    });
    
    
    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('EPFDetailsContributionPayments')
        .child(firebaseUserId)
        .child(clientEmail);
    
    await dbf.once().then((snapshot) {
      print("changed");
      print( snapshot.value);
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          print(key);
          HistoryComplinceObject historyComplianceObject =
          HistoryComplinceObject(
            date: values["dateOfFilling"],
            amount: values['amountOfPayment'],
            type: 'Details of Contribution',
            key: key,
          );
          complianceData.add(historyComplianceObject);
        });
      }
    });
    
    if(complianceData.length == 0 || complianceData == null){
    complianceData.add(HistoryComplinceObject(
    date: 'No History Found', amount: '', type: ''));
    }
    
    return complianceData;
  }
  
  

  Future<List<HistoryComplinceObject>> getHistoryOfPPFRecord(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');

//    print(clientEmail);

    List<HistoryComplinceObject> complinceData = [];

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('PPFRecord')
        .child(firebaseUserId)
        .child(clientEmail);
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          print(key);
          HistoryComplinceObject historyComplinceObject =
              HistoryComplinceObject(
            date: values["dateOfInvestment"],
            amount: values['amount'],
            type: values['nameOfInstitution'],
            key: key,
          );
          complinceData.add(historyComplinceObject);
        });
      } else {
        complinceData.add(HistoryComplinceObject(
            date: 'No History Found', amount: 'null', type: ''));
      }
    });

    return complinceData;
  }

  Future<List<HistoryComplinceObject>> getHistoryOfFDRecord(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');

//    print(clientEmail);

    List<HistoryComplinceObject> complinceData = [];

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('FDRecord')
        .child(firebaseUserId)
        .child(clientEmail);
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          print(key);
          HistoryComplinceObject historyComplinceObject =
              HistoryComplinceObject(
            date: values["dateOfInvestment"]??"",
            amount: values['principalAmount']??"",
            type: values['nameOfInstitution']??"",
            key: key??" ",
          );
          complinceData.add(historyComplinceObject);
        });
      } else {
        complinceData.add(HistoryComplinceObject(
            date: 'No History Found', amount: 'null', type: ''));
      }
    });

    return complinceData;
  }

  Future<List<HistoryComplinceObject>> getHistoryOfLICPayment(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');

//    print(clientEmail);

    List<HistoryComplinceObject> complinceData = [];

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('LICPayment')
        .child(firebaseUserId)
        .child(clientEmail);
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          print(key);
          HistoryComplinceObject historyComplinceObject =
              HistoryComplinceObject(
            date: values["dateOfCommoncement"]??" ",
            amount: values['premiumAmount']??" ",
            type: values['frequancey']??" ",
            key: key??" ",
          );
          complinceData.add(historyComplinceObject);
        });
      } else {
        complinceData.add(HistoryComplinceObject(
            date: 'No History Found', amount: 'null', type: ''));
      }
    });

    return complinceData;
  }
  

  Future<List<HistoryForMF>> getHistoryOfFMRecord(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    String clientEmail = client.email.replaceAll('.', ',');
//    print(clientEmail);

    List<HistoryForMF> historyData = [];

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('MFRecord')
        .child(firebaseUserId)
        .child(clientEmail);
    
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) async{
          print("1");
          print("2");
          HistoryForMF historyForMF =
          HistoryForMF(
//            key: key,
            amount: await values['amount'],
            mutualFundObject: MutualFundObject(
              name: await values['name'],
              code: await values['code'],
            ),
            mutualFundDetailObject: MutualFundDetailObject(
              date: await values['date'],
              nav: await values['nav'],
            ),
          );
          print("3");
//            print("Nav value  :" + historyForMF.todayNav);
          historyData.add(historyForMF);
          print("4");
        });
      } else {
        historyData.add(HistoryForMF(
            mutualFundObject: MutualFundObject(name: 'No Record Found')));
      }
    });
    return historyData;
  }

  Future<List<HistoryComplinceObject>> getHistoryOfROCPayment(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");

    print(client.name);
    String clientEmail = client.email.replaceAll('.', ',');

    print(clientEmail);

    List<HistoryComplinceObject> historyData = [];

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('ROCPayment')
        .child(firebaseUserId)
        .child(clientEmail);
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          print(key);
          HistoryComplinceObject historyComplinceObject =
              HistoryComplinceObject(
            date: values['date'],
            amount: values['amount'],
            type: values['nameOfEForm'],
            key: key,
          );

          historyData.add(historyComplinceObject);
        });
      } else {
        historyData.add(HistoryComplinceObject(
            date: 'No History Found', amount: 'null', type: ''));
      }
    });

    return historyData;
  }

  


  Future<List<HistoryCompliancesObjectForROC>> getHistoryOfROF(
      Client client, String date) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
  
    print(client.name);
    String clientEmail = client.email.replaceAll('.', ',');
  
    print(clientEmail);
    List<HistoryCompliancesObjectForROC> historyData = [];
  
    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('ROC')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(date);
    
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic, dynamic> values = await snapshot.value;
      // print(values);
      if (values != null) {
        values.forEach((key, values) {
          if(key!='AGM Date') {
            print(values['SRN No']);
            HistoryCompliancesObjectForROC historyCompliancesObjectForROC =
            HistoryCompliancesObjectForROC(
              formType: key,
              SRNNumber: values['SRN No'],
              dateOfFilling: values['Date of Filing'],
            );
            historyData.add(historyCompliancesObjectForROC);
          }
          else{
          }
        });
      }
      print('here');
    });
    if(historyData.length ==0){
      HistoryCompliancesObjectForROC historyCompliancesObjectForROC =
      HistoryCompliancesObjectForROC(
        formType: "No History Found",
        SRNNumber: "",
        dateOfFilling: "",
      );
      historyData.add(historyCompliancesObjectForROC);
    }
    print(historyData.length);
    return historyData;
  }




  Future<List<HistoryForMF>> getHistoryOfFMRecordTry(
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
  
    String clientEmail = client.email.replaceAll('.', ',');
//    print(clientEmail);
  
    List<HistoryForMF> historyData = [];
    HistoryForMF historyForMF;
    
    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('MFRecord')
        .child(firebaseUserId)
        .child(clientEmail);
  
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic, dynamic> values = await snapshot.value;
      if (values != null) {
        print(values);
        List<dynamic> keyList= values.keys.toList();
        int i =0;
        for(var v in values.values) {
          MutualFundDetailObject mutualFundDetailObject = await MutualFundHelper().getTodayNav(v['code']);
          historyForMF = HistoryForMF(
            key: keyList[i],
            amount: await v['amount'],
            keyDate: await v['keyDate'],
            type: await v['type'],
            frequency: await v['No. of Installment'],
            todayNAV: mutualFundDetailObject,
            mutualFundDetailObject: MutualFundDetailObject(
              date: await v['date'],
              nav: await v['nav'],
            ),
            mutualFundObject: MutualFundObject(
              code: await v['code'],
              name: await v['name'],
              numberOfInstalments: await v['No of Installment'],
            )
          );
          print(historyForMF.key);
          print(historyForMF.keyDate);
          historyData.add(historyForMF);
          i++;
        }
//        values.forEach((key, values) async{
//          String k = key;
//          print(k);
//          String amount = await values['amount'];
//          print(amount);
//          String name = await values['name'];
//          print(name);
//          String code = await values['code'];
//          print(code);
//          MutualFundDetailObject mutualFundDetailObject = await MutualFundHelper().getTodayNav(code);
////          print(mutualFundDetailObject.nav);
//          String date = await values['date'];
//          print(date);
//          HistoryForMF historyForMF =
//          HistoryForMF(
//            key: k,
//            amount: amount,
//            mutualFundObject: MutualFundObject(
//              name: name,
//              code: code,
//            ),
//          );
//          print("3");
//          historyData.add(historyForMF);
//          print("4");
//        });
      } else {
        historyData.add(HistoryForMF(
            amount: " ",
            keyDate: " ",
            type: " ",
            frequency: " ",
            mutualFundDetailObject: MutualFundDetailObject(
              date: " ",
              nav: " ",
            ),
            mutualFundObject: MutualFundObject(
              code: " ",
              name: "No Record Found",
              numberOfInstalments: " ",
            )
        ));
      }
    });
    print(historyData.length);
    print("returning");
    return historyData;
  }
  
  Future<List<PaymentHistory>> paymentHistory() async{
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    List<PaymentHistory> paymentHistory =[];
    dbf = firebaseDatabase.reference()
         .child("PaymentRecords")
         .child(firebaseUserId);
    
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic,dynamic> map = await snapshot.value;
      if(map != null){
        map.forEach((key, value) {
          paymentHistory.add(
            PaymentHistory(
              paymentId: value["PaymentId"],
              dateOfPayment: value["Date"],
              nameOfClient: value["Client"],
            )
          );
        });
      }
      else{
        paymentHistory.add(
            PaymentHistory(
                paymentId: "No History Found",
                dateOfPayment: " "
            )
        );
      }
    });
    print("returning");
    print(paymentHistory.length);
    return paymentHistory;
  }
  
}
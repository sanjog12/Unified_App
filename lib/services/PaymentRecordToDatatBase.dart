import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:unified_reminder/models/MutualFundRecordObject.dart';
import 'package:unified_reminder/models/TodayDateObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/EPFMonthlyContributionObejct.dart';
import 'package:unified_reminder/models/payment/ESIMonthlyContributionObejct.dart';
import 'package:unified_reminder/models/payment/FDRecordObject.dart';
import 'package:unified_reminder/models/payment/GSTPaymentObject.dart';
import 'package:unified_reminder/models/payment/IncomeTaxPaymentObject.dart';
import 'package:unified_reminder/models/payment/LICPaymentIObject.dart';
import 'package:unified_reminder/models/payment/PPFRecordObject.dart';
import 'package:unified_reminder/models/payment/ROCPaymentObject.dart';
import 'package:unified_reminder/models/payment/TDSPaymentObject.dart';
import 'package:unified_reminder/models/quarterlyReturns/EPFDetailsOfContributionObject.dart';
import 'package:unified_reminder/services/LocalNotificationServices.dart';
import 'package:unified_reminder/utils/DateChange.dart';

import 'SharedPrefs.dart';

class PaymentRecordToDataBase {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
//  static DateTime now = new DateTime.now();
//  static DateTime date = new DateTime(now.year, now.month, now.day);
//
//  static List<String> dateData = date.toString().split(' ');
//
//  static String fullDate = dateData[0];
//  List<String> todayDateData = fullDate.toString().split('-');
//  TodayDateObject todayDateObject;

  Future<bool> AddTDSPayment(TDSPaymentObject tdsPaymentObject, Client client,
      File attachmentFile) async {
    print("inside ADDTDS");
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    String clientEmail = client.email.replaceAll('.', ',');

    try {
      Map<String, String> tdsPayment;
      if (attachmentFile != null) {
        String FileName = await uploadFile(attachmentFile);

        tdsPayment = {
          'BSRcode': tdsPaymentObject.BSRcode,
          'section': tdsPaymentObject.section,
          'challanNumber': tdsPaymentObject.challanNumber,
          'amountOfPayment': tdsPaymentObject.amountOfPayment,
          'dateOfPayment': tdsPaymentObject.dateOfPayment,
          'addAttachment': FileName
        };
      } else {
        tdsPayment = {
          'BSRcode': tdsPaymentObject.BSRcode,
          'section': tdsPaymentObject.section,
          'challanNumber': tdsPaymentObject.challanNumber,
          'amountOfPayment': tdsPaymentObject.amountOfPayment,
          'dateOfPayment': tdsPaymentObject.dateOfPayment,
          'addAttachment': tdsPaymentObject.addAttachment
        };
      }
      dbf
          .child('complinces')
          .child('TDSPayments')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(tdsPayment);

      List<String> todayDateData =
          tdsPaymentObject.dateOfPayment.toString().split('/');
      TodayDateObject todayDateObject;

      todayDateObject = TodayDateObject(
          year: todayDateData[2],
          month: todayDateData[1],
          day: todayDateData[0]);

//      String section = tdsPaymentObject.section.replaceFirst(' ', '_');

      dbf
          .child('usersUpcomingCompliances')
          .child(firebaseUserId)
          .child(clientEmail)
          .child(DateTime.now().year.toString())
          .child(todayDateObject.month)
          .child('TDS')
          .child('TDS')
          .set('done');

      return true;
    }catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> AddIncomeTaxPayment(
      IncomeTaxPaymentObject incomeTaxPaymentObject,
      Client client,
      File attachmentFile) async {
    List<String> todayDateData =
        incomeTaxPaymentObject.dateOfPayment.toString().split('-');
    TodayDateObject todayDateObject;

    todayDateObject = TodayDateObject(
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);

    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

    String clientEmail = client.email.replaceAll('.', ',');

    try {
      Map<String, String> incomeTaxPayment;
      if (attachmentFile != null) {
        print(attachmentFile.path);
        String fileName = await uploadFile(attachmentFile);

        incomeTaxPayment = {
          'BSRcode': incomeTaxPaymentObject.BSRcode,
          'challanNumber': incomeTaxPaymentObject.challanNumber,
          'amountOfPayment': incomeTaxPaymentObject.amountOfPayment,
          'dateOfPayment': incomeTaxPaymentObject.dateOfPayment,
          'addAttachment': fileName
        };
      } else {
        incomeTaxPayment = {
          'BSRcode': incomeTaxPaymentObject.BSRcode,
          'challanNumber': incomeTaxPaymentObject.challanNumber,
          'amountOfPayment': incomeTaxPaymentObject.amountOfPayment,
          'dateOfPayment': incomeTaxPaymentObject.dateOfPayment,
          'addAttachment': "null"
        };
      }

      dbf
          .child('complinces')
          .child('IncomeTaxPayments')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(incomeTaxPayment);

      dbf
          .child('usersUpcomingCompliances')
          .child(firebaseUserId)
          .child(clientEmail)
          .child(DateTime.now().year.toString())
          .child(DateTime.now().month.toString())
          .child('INCOME_TAX')
          .child('ADVANCE_TAX')
          .set('done');
      

      return true;
    }on PlatformException catch(e){
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
      print("Here");
      print(e);
      return false;
    }
  }

  Future<String> uploadFile(File attachmentFile) async {
//    final String uuid = Uuid().v1();
//    final Directory systemTempDir = Directory.systemTemp;
  print("upload file");
  try {
    final File file = attachmentFile;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String fileName = randomString(8,from: 97 , to: 122) + randomNumeric(4).toString();
    final StorageReference ref =
    firebaseStorage.ref().child('files').child(fileName);
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

//    setState(() {
    _tasks.add(uploadTask);
  
    return fileName;
  }catch(e){
    print(e);
  }
//    });
  }

  Future<bool> AddGSTPayment(GSTPaymentObject gstPaymentObject, Client client,
      File attachmentFile) async {
    print('4');
    print(attachmentFile);
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    String clientEmail = client.email.replaceAll('.', ',');
    List<String> todayDateData = gstPaymentObject.dueDate.toString().split('-');
    TodayDateObject todayDateObject;
    print(gstPaymentObject.dueDate);

    todayDateObject = TodayDateObject(
        year: todayDateData[2], month: todayDateData[1], day: todayDateData[0]);
    print('5');
    try {
      print('6');
      Map<String, String> gstPayment;
      if (attachmentFile != null) {
        String FileName = await uploadFile(attachmentFile);
        print(FileName);
        gstPayment = {
          'section': gstPaymentObject.section,
          'challanNumber': gstPaymentObject.challanNumber,
          'amountOfPayment': gstPaymentObject.amountOfPayment,
          'dueDate': gstPaymentObject.dueDate,
          'addAttachment': FileName
        };
        print('7');
      } else {
        gstPayment = {
          'section': gstPaymentObject.section,
          'challanNumber': gstPaymentObject.challanNumber,
          'amountOfPayment': gstPaymentObject.amountOfPayment,
          'dueDate': gstPaymentObject.dueDate,
          'addAttachment': "null"
        };
      }
      print('8');
      dbf
          .child('complinces')
          .child('GSTPayments')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(gstPayment);
      print('9');
      String section = gstPaymentObject.section.replaceFirst(' ', '_');
      dbf = firebaseDatabase.reference();
      dbf
          .child('usersUpcomingCompliances')
          .child(firebaseUserId)
          .child(clientEmail)
          .child(todayDateObject.year)
          .child(todayDateObject.month)
          .child('GST')
          .child(section)
          .set('done');

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> AddMonthlyContributionPayment(
      EPFMonthlyContributionObejct epfMonthlyContributionObejct,
      Client client,
      File attachmentFile) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

    String clientEmail = client.email.replaceAll('.', ',');

    try {
      Map<String, String> monthlyContributionPayment;

      if (attachmentFile != null) {
        String FileName = await uploadFile(attachmentFile);
        monthlyContributionPayment = {
          'dateOfFilling': epfMonthlyContributionObejct.dteOfFilling,
          'challanNumber': epfMonthlyContributionObejct.challanNumber,
          'amountOfPayment': epfMonthlyContributionObejct.amountOfPayment,
          'addAttachment': FileName,
          'type':'m'
        };
      } else {
        monthlyContributionPayment = {
          'dateOfFilling': epfMonthlyContributionObejct.dteOfFilling,
          'challanNumber': epfMonthlyContributionObejct.challanNumber,
          'amountOfPayment': epfMonthlyContributionObejct.amountOfPayment,
          'addAttachment': "null",
          'type':'m'
        };
      }
      dbf
          .child('complinces')
          .child('MonthlyContributionPayments')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(monthlyContributionPayment);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }
  
  
  Future<bool> AddDetailsOfContribution(
      EPFDetailsOfContributionObject epfDetailsOfContributionObject,
      Client client,
      File attachmentFile) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    
    String clientEmail = client.email.replaceAll('.', ',');
    
    try {
      Map<String, String> monthlyContributionPayment;
      
      if (attachmentFile != null) {
        String FileName = await uploadFile(attachmentFile);
        monthlyContributionPayment = {
          'dateOfFilling': epfDetailsOfContributionObject.dateOfFilling,
          'challanNumber': epfDetailsOfContributionObject.challanNumber,
          'amountOfPayment': epfDetailsOfContributionObject.amountOfPayment,
          'addAttachment': FileName,
          'type':'d'
        };
      } else {
        monthlyContributionPayment = {
          'dateOfFilling': epfDetailsOfContributionObject.dateOfFilling,
          'challanNumber': epfDetailsOfContributionObject.challanNumber,
          'amountOfPayment': epfDetailsOfContributionObject.amountOfPayment,
          'addAttachment': "null",
          'type':'d'
        };
      }
      dbf
          .child('complinces')
          .child('EPFDetailsContributionPayments')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(monthlyContributionPayment);
      
      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> AddESIMonthlyContributionPayment(
      ESIMonthlyContributionObejct esiMonthlyContributionObejct,
      Client client,
      File attachmentFile) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

    String clientEmail = client.email.replaceAll('.', ',');

    try {
      Map<String, String> ESImonthlyContributionPayment;
      if (attachmentFile != null) {
        String FileName = await uploadFile(attachmentFile);
        
        ESImonthlyContributionPayment = {
          'dateOfFilling': esiMonthlyContributionObejct.dateOfFilling,
          'challanNumber': esiMonthlyContributionObejct.challanNumber,
          'amountOfPayment': esiMonthlyContributionObejct.amountOfPayment,
          'addAttachment': FileName
        };
      } else {
        ESImonthlyContributionPayment = {
          'dateOfFilling': esiMonthlyContributionObejct.dateOfFilling,
          'challanNumber': esiMonthlyContributionObejct.challanNumber,
          'amountOfPayment': esiMonthlyContributionObejct.amountOfPayment,
          'addAttachment': "null",
        };
      }
      dbf
          .child('complinces')
          .child('ESIMonthlyContributionPayments')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(ESImonthlyContributionPayment);

      Fluttertoast.showToast(
          msg: "Record has been saved in database",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);

      return true;
    }on PlatformException catch(e){
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> AddPPFRecord(
      PPFRecordObject ppfRecordObject, Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

    String clientEmail = client.email.replaceAll('.', ',');

    try {
      Map<String, String> ppfRecordData = {
        'nameOfInstitution': ppfRecordObject.nameOfInstitution,
        'accountNumber': ppfRecordObject.accountNumber,
        'amount': ppfRecordObject.amount,
        'dateOfInvestment': ppfRecordObject.dateOfInvestment
      };

      dbf
          .child('complinces')
          .child('PPFRecord')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(ppfRecordData);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> AddFDRecord(FDRecordObject fdRecordObject, Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

    String clientEmail = client.email.replaceAll('.', ',');

    try {
      Map<String, String> fdRecordData = {
        'nameOfInstitution': fdRecordObject.nameOfInstitution,
        'fixedDepositNo': fdRecordObject.fixedDepositNo,
        'dateOfInvestment': fdRecordObject.dateOfInvestment,
        'principalAmount': fdRecordObject.principalAmount,
        'termOfInvestment': fdRecordObject.termOfInvestment,
        'rateOfInterest': fdRecordObject.rateOfInterest,
        'maturityAmount': fdRecordObject.maturityAmount,
        'secondHolderName': fdRecordObject.secondHolderName,
        'dateOfMaturity' : fdRecordObject.maturityDate,
        'nomineeName': fdRecordObject.nomineeName
      };

      dbf
          .child('complinces')
          .child('FDRecord')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(fdRecordData);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> AddLICPayment(
      LICPaymentObject licPaymentIObject, Client client, File file) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    String id = randomNumeric(8);
    NotificationServices notificationServices = NotificationServices();
    notificationServices.initializeSetting();

    String clientEmail = client.email.replaceAll('.', ',');

    try {
      if(file == null) {
        dbf
            .child('complinces')
            .child('LICPayment')
            .child(firebaseUserId)
            .child(clientEmail)
            .push()
            .set({
          'id':id,
          'comanyName': licPaymentIObject.comanyName,
          'policyName': licPaymentIObject.policyName,
          'policyNo': licPaymentIObject.policyNo,
          'premiumDueDate': licPaymentIObject.premiumDueDate,
          'premiumAmount': licPaymentIObject.premiumAmount,
          'frequancey': licPaymentIObject.frequancey,
          'dateOfCommoncement': licPaymentIObject.dateOfCommoncement,
          'premiumPayingTerm': licPaymentIObject.premiumPayingTerm,
          'policyTerm': licPaymentIObject.policyTerm,
          'branch': licPaymentIObject.branch,
          'agenName': licPaymentIObject.agenName,
          'agentContactNumber': licPaymentIObject.agentContactNumber,
          'attachement': licPaymentIObject.agentContactNumber,
          'nomineeName': licPaymentIObject.nomineeName,
          'maturityDate': licPaymentIObject.maturityDate,
          'attachment' : "null"
        });
      }else {
        String fileName = await uploadFile(file);
        dbf
            .child('complinces')
            .child('LICPayment')
            .child(firebaseUserId)
            .child(clientEmail)
            .push()
            .set({
          'id':id,
          'comanyName': licPaymentIObject.comanyName,
          'policyName': licPaymentIObject.policyName,
          'policyNo': licPaymentIObject.policyNo,
          'premiumDueDate': licPaymentIObject.premiumDueDate,
          'premiumAmount': licPaymentIObject.premiumAmount,
          'frequancey': licPaymentIObject.frequancey,
          'dateOfCommoncement': licPaymentIObject.dateOfCommoncement,
          'premiumPayingTerm': licPaymentIObject.premiumPayingTerm,
          'policyTerm': licPaymentIObject.policyTerm,
          'branch': licPaymentIObject.branch,
          'agenName': licPaymentIObject.agenName,
          'agentContactNumber': licPaymentIObject.agentContactNumber,
          'attachement': licPaymentIObject.agentContactNumber,
          'nomineeName': licPaymentIObject.nomineeName,
          'maturityDate': licPaymentIObject.maturityDate,
          'attachment': fileName,
        });
      }
        String premiumDate = licPaymentIObject.dateOfCommoncement;
        int i=0;
        DateTime t = DateTime(int.parse(licPaymentIObject.maturityDate.split('-')[2]),
          int.parse(licPaymentIObject.maturityDate.split('-')[1]),
          int.parse(licPaymentIObject.maturityDate.split('-')[0])
        );
        DateTime other = DateTime(int.parse(licPaymentIObject.dateOfCommoncement.split('-')[2]),
            int.parse(licPaymentIObject.dateOfCommoncement.split('-')[1]),
            int.parse(licPaymentIObject.dateOfCommoncement.split('-')[0])
        );
        print(t.toString());
        print(other.toString());
        print(t.isAfter(other));
        print("while Started");
        
        while(t.isAfter(other)){
          try {
            notificationServices.setReminderNotification(
                id: int.parse(id), titleString: "LIC of ${client.name}",
                bodyString: "Premium due date of ${licPaymentIObject
                    .policyName} in 7 days, make sure to pay before due date",
                scheduleTime: other.subtract(Duration(days: 6, hours: 14))
            );
          }catch(e){
            print(e);
          }
          print("t" + t.toString());
          print("other" + other.toString());
          print(licPaymentIObject.frequancey);
          
          dbf = firebaseDatabase.reference();
          await dbf
              .child('complinces')
              .child('LICUserUpcomingCompliances')
              .child(firebaseUserId)
              .child(clientEmail)
              .child(premiumDate.split('-')[2])
              .child(premiumDate.split('-')[1])
              .push()
              .set({
            'id':id,
            'date': licPaymentIObject.premiumDueDate.split('-')[0],
            'label':'Payment due',
            'type':'${licPaymentIObject.policyName}',
          });
          
          if(licPaymentIObject.frequancey == 'monthly'){
            premiumDate = DateChange.addMonthToDate(premiumDate, 1);
            print("premium Date " + premiumDate);
            other = DateTime(other.year,other.month +1 , other.day);
            print("Other in if " + other.toString());
          }
          else if(licPaymentIObject.frequancey == 'quarterly'){
            premiumDate = DateChange.addMonthToDate(premiumDate, 3);
            print("premium Date " + premiumDate);
            other = DateTime(other.year,other.month +3 , other.day);
            print("Other in if " + other.toString());
          }
          else if(licPaymentIObject.frequancey == 'halfYearly'){
            premiumDate = DateChange.addMonthToDate(premiumDate, 6);
            print("premium Date " + premiumDate);
            other = DateTime(other.year,other.month +6 , other.day);
            print("Other in if " + other.toString());
          }
          else if(licPaymentIObject.frequancey == 'yearly'){
            premiumDate = DateChange.addMonthToDate(premiumDate, 12);
            print("premium Date " + premiumDate);
            other = DateTime(other.year +1,other.month  , other.day);
            print("Other in if " + other.toString());
          }
        }
        
        print("end while");
      

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  Future<bool> AddMFRecord(MutualFundRecordObject mutualFundRecordObject,
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

//    mutualFundRecordObject.mutualFundDetailObject.date;
    String clientEmail = client.email.replaceAll('.', ',');
    
    try {
      String key = randomString(12,from: 48,to: 58,);
      Map<String, String> MFRecordData = {
        'type' : mutualFundRecordObject.type,
        'No of Installment' : mutualFundRecordObject.frequency,
        'amount': mutualFundRecordObject.amount,
        'name': mutualFundRecordObject.mutualFundObject.name,
        'code': mutualFundRecordObject.mutualFundObject.code,
        'date': mutualFundRecordObject.mutualFundDetailObject.date,
        'nav': mutualFundRecordObject.mutualFundDetailObject.nav,
        'keyDate':key
      };

      dbf
          .child('complinces')
          .child('MFRecord')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(MFRecordData);
      
      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }

  
  
  Future<bool> AddROCPayment(
      ROCPaymentObject rocPaymentObject,
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

    String clientEmail = client.email.replaceAll('.', ',');

    try {
      Map<String, String> ROCPaymentData = {
        'CINNumber': rocPaymentObject.CINNumber,
        'nameOfEForm': rocPaymentObject.nameOfEForm,
        'purposeOfEForm': rocPaymentObject.purposeOfEForm,
        'date': rocPaymentObject.date,
        'amount': rocPaymentObject.amount,
//        'amount': mutualFundRecordObject.amount,
//        'name': mutualFundRecordObject.mutualFundObject.name,
//        'code': mutualFundRecordObject.mutualFundObject.code,
//        'date': mutualFundRecordObject.mutualFundDetailObject.date,
//        'nav': mutualFundRecordObject.mutualFundDetailObject.nav
      };

      dbf
          .child('complinces')
          .child('ROCPayment')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(ROCPaymentData);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }
  
  
  
  
  Future<void> savePaymentDetails(PaymentSuccessResponse response, Client client) async{
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    try{
    dbf.child("PaymentRecords")
       .child(firebaseUserId)
       .push()
       .set({
      "OrderId":response.orderId,
      "PaymentId":response.paymentId,
      "Date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
      "Client": client.name,
      "Client_email": client.email,
    });
    
    
    }catch(e){
      print("error");
      debugPrint(e);
    }
    
  }
}

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:unified_reminder/models/TodayDateObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/quarterlyReturns/EPFDetailsOfContributionObject.dart';
import 'package:unified_reminder/models/quarterlyReturns/GSTReturnFillingsObject.dart';
import 'package:unified_reminder/models/quarterlyReturns/IncomeTaxReturnFillingObject.dart';
import 'package:unified_reminder/models/quarterlyReturns/TDSQuarterlyReturnsObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';

import 'GeneralServices/SharedPrefs.dart';

class QuarterlyReturnsRecordToDatabase {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  
  
  
  Future<bool> addTDSQuarterlyReturns(
      TDSQuarterlyReturnsObject tdsQuarterlyReturnsObject,
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();

    String clientEmail = client.email.replaceAll('.', ',');
    
    try {
      Map<String , String> tdsQuarterlyReturns = {
        'dateOfFilledReturns': tdsQuarterlyReturnsObject.dateOfFilledReturns,
        'nameOfForm': tdsQuarterlyReturnsObject.nameOfForm,
        'acknowledgementNo': tdsQuarterlyReturnsObject.acknowledgementNo
      };
      
      dbf
          .child('complinces')
          .child('TDSQuarterlyReturns')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(tdsQuarterlyReturns);

      List<String> todayDateData = tdsQuarterlyReturnsObject.dateOfFilledReturns.toString().split('/');
      
      TodayDateObject todayDateObject;

      todayDateObject = TodayDateObject(
          year: todayDateData[2],
          month: todayDateData[1],
          day: todayDateData[0]);
      dbf
          .child('usersUpcomingCompliances')
          .child(firebaseUserId)
          .child(clientEmail)
          .child(DateTime.now().year.toString())
          .child(todayDateObject.month)
          .child('TDS')
          .child('TDS_FILLING')
          .set('done');

      return true;
    } catch (e) {
      // Fluttertoast.showToast(
      //     msg: e.message.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Color(0xff666666),
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      print("Here");
      print(e);
      return false;
    }
  }
  
  
  
  Future<bool> addIncomeTaxReturnFillings(
      IncomeTaxReturnFillingsObject incomeTaxReturnFillingsObject,
      Client client,File file) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    String clientEmail = client.email.replaceAll('.', ',');

    
    try {
      if(file == null) {
        Map<String, String> incomeTaxReturnFillings = {
          'dateOfFilledReturns':
          incomeTaxReturnFillingsObject.dateOfFilledReturns,
          'attachemnt': 'null',
        };
        dbf
            .child('complinces')
            .child('IncomeTaxReturnFillings')
            .child(firebaseUserId)
            .child(clientEmail)
            .push()
            .set(incomeTaxReturnFillings);
      }
      else{
        String fileName = await PaymentRecordToDataBase().uploadFile(file);
        Map<String,String> incomeTaxReturnFillings = {
          'dateOfFilledReturns':
          incomeTaxReturnFillingsObject.dateOfFilledReturns,
          'attachemnt': fileName,
        };
        dbf
            .child('complinces')
            .child('IncomeTaxReturnFillings')
            .child(firebaseUserId)
            .child(clientEmail)
            .push()
            .set(incomeTaxReturnFillings);
      }

      List<String> todayDateData = incomeTaxReturnFillingsObject
          .dateOfFilledReturns
          .toString()
          .split('-');
      TodayDateObject todayDateObject;

      todayDateObject = TodayDateObject(
          year: todayDateData[0],
          month: todayDateData[1],
          day: todayDateData[2]);

      dbf
          .child('usersUpcomingCompliances')
          .child(firebaseUserId)
          .child(clientEmail)
          .child(DateTime.now().year.toString())
          .child(todayDateObject.month)
          .child('INCOME_TAX')
          .child('INCOME_TAX_RETURNS')
          .set('done');

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }
  
  
  
  Future<bool> addGSTReturnFillings(
      GSTReturnFillingsObject gstReturnFillingsObject, Client client,File file) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    String clientEmail = client.email.replaceAll('.', ',');

    try {
      if(file == null) {
        Map<String, String> gstReturnFillings = {
          'dateOfFilledReturns': gstReturnFillingsObject.dateOfFilledReturns,
          'attachment': 'null',
        };
        dbf
            .child('complinces')
            .child('GSTReturnFillings')
            .child(firebaseUserId)
            .child(clientEmail)
            .push()
            .set(gstReturnFillings);
      }
      else{
        String fileName = await PaymentRecordToDataBase().uploadFile(file);
        Map<String, String> gstReturnFillings = {
          'dateOfFilledReturns': gstReturnFillingsObject.dateOfFilledReturns,
          'attachment': fileName,
        };
        dbf
            .child('complinces')
            .child('GSTReturnFillings')
            .child(firebaseUserId)
            .child(clientEmail)
            .push()
            .set(gstReturnFillings);
      }

      List<String> todayDateData =
          gstReturnFillingsObject.dateOfFilledReturns.toString().split('-');
      TodayDateObject todayDateObject;

      todayDateObject = TodayDateObject(
          year: todayDateData[0],
          month: todayDateData[1],
          day: todayDateData[2]);
      dbf
          .child('usersUpcomingCompliances')
          .child(firebaseUserId)
          .child(clientEmail)
          .child(DateTime.now().year.toString())
          .child(todayDateObject.month)
          .child('GST')
          .child('GSTR_1_QUARTERLY')
          .set('done');
      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }
  
  
  
  Future<bool> addDetailOfContribution(
      EPFDetailsOfContributionObject epfDetailsOfContributionObject,
      Client client) async {
    String firebaseUserId = await SharedPrefs.getStringPreference("uid");
    dbf = firebaseDatabase.reference();
    String clientEmail = client.email.replaceAll('.', ',');

    try {
      Map<String, String> detailsOfContribution = {
        'dateOfFilling': epfDetailsOfContributionObject.dateOfFilling,
        'challanNumber': epfDetailsOfContributionObject.challanNumber,
        'amountOfPayment': epfDetailsOfContributionObject.amountOfPayment,
        'addAttachment': epfDetailsOfContributionObject.addAttachment
      };
      dbf
          .child('complinces')
          .child('EPFDetailsOfCOntribution')
          .child(firebaseUserId)
          .child(clientEmail)
          .push()
          .set(detailsOfContribution);

      return true;
    } catch (e) {
      print("Here");
      print(e);
      return false;
    }
  }
  
  
}

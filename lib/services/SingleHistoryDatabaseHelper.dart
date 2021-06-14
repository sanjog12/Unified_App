import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/MutualFundObject.dart';
import 'package:unified_reminder/models/MutualFundRecordObject.dart';
import 'package:unified_reminder/models/Client.dart';

// import 'package:unified_reminder/models/history/HistoryComplinceObjectForIncomeTax.dart';
// import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/payment/EPFMonthlyContributionObejct.dart';
import 'package:unified_reminder/models/payment/ESIMonthlyContributionObejct.dart';
import 'package:unified_reminder/models/payment/FDRecordObject.dart';
import 'package:unified_reminder/models/payment/GSTPaymentObject.dart';
import 'package:unified_reminder/models/payment/IncomeTaxPaymentObject.dart';
import 'package:unified_reminder/models/payment/LICPaymentIObject.dart';
import 'package:unified_reminder/models/payment/PPFRecordObject.dart';
import 'package:unified_reminder/models/payment/ROCFormFilling.dart';

// import 'package:unified_reminder/models/payment/ROCPaymentObject.dart';
import 'package:unified_reminder/models/payment/TDSPaymentObject.dart';
import 'package:unified_reminder/models/quarterlyReturns/EPFDetailsOfContributionObject.dart';

import 'GeneralServices/SharedPrefs.dart';

class SingleHistoryDatabaseHelper {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  Future<TDSPaymentObject> getTDSHistoryDetails(
      Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    TDSPaymentObject tdsPaymentObject = TDSPaymentObject();

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('TDSPayments')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      if (values != null) {
        tdsPaymentObject.BSRcode = values['BSRcode'] ?? "";
        tdsPaymentObject.dateOfPayment = values['dateOfPayment'] ?? "";
        tdsPaymentObject.challanNumber = values['challanNumber'] ?? "";
        tdsPaymentObject.section = values['section'] ?? "";
        tdsPaymentObject.amountOfPayment = values['amountOfPayment'] ?? "";
      }
    });
    return tdsPaymentObject;
  }

  Future<IncomeTaxPaymentObject> getIncomeTaxHistoryDetails(
      Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    IncomeTaxPaymentObject incomeTaxPaymentObject = IncomeTaxPaymentObject();

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('IncomeTaxPayments')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      if (values != null) {
        incomeTaxPaymentObject.BSRcode = values['BSRcode'] ?? "";
        incomeTaxPaymentObject.amountOfPayment =
            values['amountOfPayment'] ?? "";
        incomeTaxPaymentObject.challanNumber = values['challanNumber'] ?? "";
        incomeTaxPaymentObject.dateOfPayment = values['dateOfPayment'] ?? "";
        incomeTaxPaymentObject.addAttachment = values['addAttachment'] ?? "";
      }
    });
    return incomeTaxPaymentObject;
  }

  Future<GSTPaymentObject> getGSTHistoryDetails(
      Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    GSTPaymentObject gstPaymentObject = GSTPaymentObject();

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('GSTPayments')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      if (values != null) {
        gstPaymentObject.challanNumber = values['challanNumber'] ?? "";
        gstPaymentObject.amountOfPayment = values['amountOfPayment'] ?? "";
        gstPaymentObject.dueDate = values['dueDate'] ?? "";
        gstPaymentObject.section = values['section'] ?? "";
        gstPaymentObject.addAttachment = values['addAttachment'] ?? "";
      }
    });
    return gstPaymentObject;
  }

  Future<EPFMonthlyContributionObject> getEPFHistoryDetails(
      Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    EPFMonthlyContributionObject epfMonthlyContributionObejct =
        EPFMonthlyContributionObject();

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('MonthlyContributionPayments')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        epfMonthlyContributionObejct.challanNumber =
            values['challanNumber'] ?? "";
        epfMonthlyContributionObejct.amountOfPayment =
            values['amountOfPayment'] ?? "";
        epfMonthlyContributionObejct.dateOfFilling =
            values['dateOfFilling'] ?? "";
        epfMonthlyContributionObejct.addAttachment =
            values['addAttachment'] ?? "";
        epfMonthlyContributionObejct.type = values['type'] ?? "";
      }
    });

    return epfMonthlyContributionObejct;
  }

  Future<EPFDetailsOfContributionObject>
      getEPFDetailedOfContributionHistoryDetails(
          Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    EPFDetailsOfContributionObject epfDetailsOfContributionObject =
        EPFDetailsOfContributionObject();

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('EPFDetailsContributionPayments')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);

    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        epfDetailsOfContributionObject.challanNumber =
            values['challanNumber'] ?? "";
        epfDetailsOfContributionObject.amountOfPayment =
            values['amountOfPayment'] ?? "";
        epfDetailsOfContributionObject.dateOfFilling =
            values['dateOfFilling'] ?? "";
        epfDetailsOfContributionObject.addAttachment =
            values['addAttachment'] ?? "";
      }
    });

    return epfDetailsOfContributionObject;
  }

  Future<ESIMonthlyContributionObejct> getESIHistoryDetails(
      Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    ESIMonthlyContributionObejct esiMonthlyContributionObejct =
        ESIMonthlyContributionObejct();

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('ESIMonthlyContributionPayments')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        esiMonthlyContributionObejct.challanNumber =
            values['challanNumber'] ?? "";
        esiMonthlyContributionObejct.amountOfPayment =
            values['amountOfPayment'] ?? "";
        esiMonthlyContributionObejct.dateOfFilling =
            values['dateOfFilling'] ?? "";
        esiMonthlyContributionObejct.addAttachment =
            values['addAttachment'] ?? "";
      }
    });
    print(esiMonthlyContributionObejct.dateOfFilling);
    return esiMonthlyContributionObejct;
  }

  Future<PPFRecordObject> getPPFHistoryDetails(
      Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    PPFRecordObject ppfRecordObject = PPFRecordObject();

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('PPFRecord')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        ppfRecordObject.accountNumber = values['accountNumber'] ?? "";
        ppfRecordObject.amount = values['amount'] ?? "";
        ppfRecordObject.dateOfInvestment = values['dateOfInvestment'] ?? "";
        ppfRecordObject.nameOfInstitution = values['nameOfInstitution'] ?? "";
      }
    });
    return ppfRecordObject;
  }

  Future<FDRecordObject> getFDHistoryDetails(Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    FDRecordObject fdRecordObject = FDRecordObject();
//    print('key $key');

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('FDRecord')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        fdRecordObject.id = values['id'] ?? "";
        fdRecordObject.maturityDate = values['dateOfMaturity'] ?? "";
        fdRecordObject.nameOfInstitution = values['nameOfInstitution'] ?? "";
        fdRecordObject.dateOfInvestment = values['dateOfInvestment'] ?? "";
        fdRecordObject.fixedDepositNo = values['fixedDepositNo'] ?? "";
        fdRecordObject.maturityAmount = values['maturityAmount'] ?? "";
        fdRecordObject.nomineeName = values['nomineeName'] ?? "";
        fdRecordObject.principalAmount = values['principalAmount'] ?? "";
        fdRecordObject.rateOfInterest = values['rateOfInterest'] ?? "";
        fdRecordObject.secondHolderName = values['secondHolderName'] ?? "";
        fdRecordObject.termOfInvestment = values['termOfInvestment'] ?? "";
      }
    });
    return fdRecordObject;
  }

  Future<LICPaymentObject> getLICHistoryDetails(
      Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    LICPaymentObject licPaymentObject = LICPaymentObject();
//    print('key $key');

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('LICPayment')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
//      print(values);
      if (values != null) {
        licPaymentObject.id = values['id'];
        licPaymentObject.companyName = values['comanyName'] ?? "";
        licPaymentObject.agentName = values['agenName'] ?? "";
        licPaymentObject.agentContactNumber =
            values['agentContactNumber'] ?? "";
        licPaymentObject.branch = values['branch'] ?? "";
        licPaymentObject.dateOfCommencement =
            values['dateOfCommoncement'] ?? "";
        licPaymentObject.frequency = values['frequancey'] ?? "";
        licPaymentObject.maturityDate = values['maturityDate'] ?? "";
        licPaymentObject.nomineeName = values['nomineeName'] ?? "";
        licPaymentObject.policyName = values['policyName'] ?? "";
        licPaymentObject.policyNo = values['policyNo'] ?? "";
        licPaymentObject.policyTerm = values['policyTerm'] ?? "";
        licPaymentObject.premiumAmount = values['premiumAmount'] ?? "";
        licPaymentObject.premiumDueDate = values['premiumDueDate'] ?? "";
        licPaymentObject.premiumPayingTerm = values['premiumPayingTerm'] ?? "";
        licPaymentObject.attachment = values['attachment'] ?? "";
      }
    });
    return licPaymentObject;
  }

  Future<ROCFormSubmission> getROCHistoryDetails(
      Client client, String key) async {
    String firebaseUserId = FirebaseAuth.instance.currentUser.uid;

    String clientEmail = client.email.replaceAll('.', ',');

    ROCFormSubmission rocFormSubmission = ROCFormSubmission();
    print('key $key');

    dbf = firebaseDatabase
        .reference()
        .child('RocCompliances')
        .child('UpcomingCompliances')
        .child(firebaseUserId)
        .child(clientEmail)
        .child(key);

    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
//      print(values);
      if (values != null) {
//        rocFormSubmission.SRNNumber = values['SRN Number'];
//        rocFormSubmission.formType = values['From Type'];
        rocFormSubmission.dateOfAGMConclusion =
            values['Date of AGM Conclusion'];
//        rocFormSubmission.dateOfFilling = values['Date Of Filling Form'];
      }
    });
    return rocFormSubmission;
  }

  Future<MutualFundRecordObject> getMFHistory(String key, Client client) async {
    String firebaseUserID = FirebaseAuth.instance.currentUser.uid;
    print(firebaseUserID);
    String clientEmail = client.email.replaceAll('.', ',');

    MutualFundRecordObject mutualFundRecordObject = MutualFundRecordObject();

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('MFRecord')
        .child(firebaseUserID)
        .child(clientEmail)
        .child(key);

    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      print(values['amount']);
      if (values != null) {
        mutualFundRecordObject.type = values['type'] ?? ' ';
        mutualFundRecordObject.amount = values['amount'] ?? ' ';
        mutualFundRecordObject.frequency = values['No. of Installment'] ?? ' ';
        mutualFundRecordObject.mutualFundDetailObject = MutualFundDetailObject(
          date: values['date'] ?? ' ',
          nav: values['nav'] ?? ' ',
        );
        mutualFundRecordObject.mutualFundObject = MutualFundObject(
          code: values['code'] ?? ' ',
          name: values['name'] ?? ' ',
          numberOfInstalments: values['No of Installment'] ?? ' ',
        );
      }

      print(mutualFundRecordObject.mutualFundDetailObject.date);

      if (mutualFundRecordObject.amount == null) {
        print('yes object is null');
      }
    });
    return mutualFundRecordObject;
  }

  Future<void> deletRecordMF(String key, Client client, String date) async {
    String firebaseUserID = FirebaseAuth.instance.currentUser.uid;
    String clientEmail = client.email.replaceAll('.', ',');
    dbf = firebaseDatabase.reference();
    print("Delete Record");
    print(key);
    print(date);
    Map<String, String> addDate = {'deletedDate': date};
    try {
      dbf
          .child('complinces')
          .child('MFRecordHelper')
          .child(firebaseUserID)
          .child(clientEmail)
          .child('deletedDates')
          .child(key)
          .push()
          .set(addDate);
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> getDeletedRecordDates(Client client, String key) async {
    List<String> temp = [];
    String firebaseUserID = FirebaseAuth.instance.currentUser.uid;
    String clientEmail = client.email.replaceAll('.', ',');

    print(firebaseUserID.toString());
    print(clientEmail);
    print(key);

    dbf = firebaseDatabase
        .reference()
        .child('complinces')
        .child('MFRecordHelper')
        .child(firebaseUserID)
        .child(clientEmail)
        .child('deletedDates')
        .child(key);

    await dbf.once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> values = await snapshot.value;
      if (values != null) {
        print(values.keys);
        values.forEach((key, value) {
          print(values.values);
          print(value['deletedDate']);
          temp.add(value['deletedDate']);
        });
      }
    });

    return temp;
  }
}

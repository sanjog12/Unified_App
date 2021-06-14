import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/payment/FDRecordObject.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateChange.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class FDPaymentRecordHistoryDetailsView extends StatefulWidget {
  final Client client;
  final FDRecordObject fdRecordObject;
  final String keyDB;

  const FDPaymentRecordHistoryDetailsView({
    this.client,
    this.fdRecordObject,
    this.keyDB,
  });

  @override
  _FDPaymentRecordHistoryDetailsViewState createState() =>
      _FDPaymentRecordHistoryDetailsViewState();
}

class _FDPaymentRecordHistoryDetailsViewState
    extends State<FDPaymentRecordHistoryDetailsView> {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  bool loadingDelete = false;
  bool edit = false;
  String firebaseUserId;
  FDRecordObject _fdRecordObject;
  DateTime selectedDateOfInvestment = DateTime.now();
  String selectedDateOfPayment;

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfInvestment,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year));

    if (picked != null && picked != selectedDateOfInvestment) {
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateOfInvestment = picked;
        selectedDateOfPayment = DateFormat('dd/MMMM/yyyy').format(picked);
        _fdRecordObject.dateOfInvestment = selectedDateOfPayment;
      });
    }
  }

  fireUser() async {
    firebaseUserId = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  void initState() {
    super.initState();
    _fdRecordObject = widget.fdRecordObject;
    selectedDateOfPayment = widget.fdRecordObject.dateOfInvestment;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Fixed Deposit Payment Record"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "${widget.client.name}\'s Fixed Deposit Payment Details",
                style: _theme.textTheme.headline6.merge(
                  TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Name of institution"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue:
                                  widget.fdRecordObject.nameOfInstitution,
                              decoration: buildCustomInput(
                                  hintText: "Name Of Institution"),
                              onChanged: (value) =>
                                  _fdRecordObject.nameOfInstitution = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                widget.fdRecordObject.nameOfInstitution,
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Nominee Name"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue: widget.fdRecordObject.nomineeName,
                              decoration: buildCustomInput(hintText: "Name"),
                              onChanged: (value) =>
                                  _fdRecordObject.nomineeName = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                widget.fdRecordObject.nomineeName,
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Fixed Deposit number"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue:
                                  widget.fdRecordObject.fixedDepositNo,
                              decoration: buildCustomInput(
                                  hintText: "Fixed Deposit Number"),
                              onChanged: (value) =>
                                  _fdRecordObject.fixedDepositNo = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                widget.fdRecordObject.fixedDepositNo,
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Maturity Amount"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue:
                                  widget.fdRecordObject.maturityAmount,
                              decoration: buildCustomInput(
                                  hintText: "Maturity Amount",
                                  prefixText: "\u{20B9}"),
                              onChanged: (value) =>
                                  _fdRecordObject.maturityAmount = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                "\u{20B9} " +
                                    widget.fdRecordObject.maturityAmount,
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Date of Investment"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: fieldsDecoration,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '$selectedDateOfPayment',
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      selectDateTime(context);
                                    },
                                    child: Icon(Icons.date_range),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                widget.fdRecordObject.dateOfInvestment,
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Principal amount"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue:
                                  widget.fdRecordObject.principalAmount,
                              decoration: buildCustomInput(
                                  hintText: "Principal Amount",
                                  prefixText: "\u{20B9} "),
                              onChanged: (value) =>
                                  _fdRecordObject.principalAmount = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                "\u{20B9} " +
                                    widget.fdRecordObject.principalAmount,
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Rate of Interest"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue:
                                  widget.fdRecordObject.rateOfInterest,
                              decoration: buildCustomInput(
                                  hintText: "Rate Of Interest",
                                  suffixText: " %"),
                              onChanged: (value) =>
                                  _fdRecordObject.rateOfInterest = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                widget.fdRecordObject.rateOfInterest + " %",
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Terms of Investment"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue:
                                  widget.fdRecordObject.termOfInvestment,
                              decoration: buildCustomInput(
                                  hintText: "Term Of Investment",
                                  suffixText: "Months"),
                              onChanged: (value) =>
                                  _fdRecordObject.termOfInvestment = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                widget.fdRecordObject.termOfInvestment +
                                    " Months",
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  widget.fdRecordObject.secondHolderName != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Second holder name"),
                            SizedBox(
                              height: 10.0,
                            ),
                            edit
                                ? TextFormField(
                                    initialValue:
                                        widget.fdRecordObject.secondHolderName,
                                    decoration: buildCustomInput(
                                        hintText: "Second Holder Name"),
                                    onChanged: (value) => _fdRecordObject
                                        .secondHolderName = value,
                                  )
                                : Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: fieldsDecoration,
                                    child: Text(
                                      widget.fdRecordObject.secondHolderName,
                                      style: TextStyle(
                                        color: whiteColor,
                                      ),
                                    ),
                                  )
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Date of Maturity"),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.fdRecordObject.maturityDate,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        decoration: roundedCornerButton,
                        child: edit
                            ? TextButton(
                                child: Text("Save Changes"),
                                onPressed: () {
                                  editRecord();
                                },
                              )
                            : TextButton(
                                child: Text("Edit"),
                                onPressed: () {
                                  setState(() {
                                    edit = true;
                                  });
                                },
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: roundedCornerButton,
                        child: TextButton(
                          child: Text("Delete Record"),
                          onPressed: () async {
                            print("called");
                            loadingDelete = true;
                            bool t = false;
                            t = await showConfirmationDialog(context);
                            print("got");
                            print(t);
                            setState(() {
                              t = t;
                            });
                            if (t) {
                              await deleteRecord();
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editRecord() async {
    print("editRecord");
    dbf = firebaseDatabase.reference();
    await fireUser();
    print("got firebaseId");
    print(firebaseUserId);
    print(widget.client.email);
    print(widget.keyDB);
    print(_fdRecordObject.nomineeName);
    try {
      _fdRecordObject.maturityDate = DateChange.addMonthToDate(
          _fdRecordObject.dateOfInvestment,
          int.parse(_fdRecordObject.termOfInvestment));
      dbf
          .child('complinces')
          .child('FDRecord')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .update({
        'dateOfMaturity': _fdRecordObject.maturityDate,
        'nameOfInstitution': _fdRecordObject.nameOfInstitution,
        'dateOfInvestment': _fdRecordObject.dateOfInvestment,
        'fixedDepositNo': _fdRecordObject.fixedDepositNo,
        'maturityAmount': _fdRecordObject.maturityAmount,
        'nomineeName': _fdRecordObject.nomineeName,
        'principalAmount': _fdRecordObject.principalAmount,
        'rateOfInterest': _fdRecordObject.rateOfInterest,
        'secondHolderName': _fdRecordObject.secondHolderName,
        'termOfInvestment': _fdRecordObject.termOfInvestment,
      });

      recordEditToast();
    } on PlatformException catch (e) {
      print(e.message);
      flutterToast(message: e.message);
    } catch (e) {
      print(e);
      flutterToast(message: "Something went wrong");
    }
  }

  Future<void> showConfirmation(BuildContext context) async {
    loadingDelete = true;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Confirm',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sure Want to Delete ?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Confirm'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await deleteRecord();
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> deleteRecord() async {
    dbf = firebaseDatabase.reference();
    await fireUser();
    print(firebaseUserId);
    print(widget.client.email);
    print(widget.keyDB);
    try {
      await dbf
          .child('complinces')
          .child('FDRecord')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .remove();
      recordDeletedToast();
      Navigator.pop(context);
      Navigator.pop(context);
//      Navigator.push(context,
//          MaterialPageRoute(
//              builder: (context) => HistoryForFD(
//                client: widget.client,
//              )
//          )
//      );

    } on PlatformException catch (e) {
      print(e.message);
      flutterToast(message: e.message);
    } catch (e) {
      print(e);
      flutterToast(message: "Something went wrong");
    }
  }
}

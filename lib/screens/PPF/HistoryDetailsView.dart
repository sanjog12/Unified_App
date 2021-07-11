import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/payment/PPFRecordObject.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateRelated.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class PPFRecordHistoryDetailsView extends StatefulWidget {
  final Client client;
  final PPFRecordObject ppfRecordObject;
  final String keyDB;

  const PPFRecordHistoryDetailsView({
    this.client,
    this.ppfRecordObject,
    this.keyDB,
  });

  @override
  _PPFRecordHistoryDetailsViewState createState() =>
      _PPFRecordHistoryDetailsViewState();
}

class _PPFRecordHistoryDetailsViewState
    extends State<PPFRecordHistoryDetailsView> {
  bool edit = false;
  bool loadDelete = false;
  PPFRecordObject _ppfRecordObject;

  String firebaseUserId;
  String _selectedDateOfPayment = 'Select date';
  DateTime selectedDateOfPayment = DateTime.now();
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  fireUser() async {
    firebaseUserId = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  void initState() {
    super.initState();
    _ppfRecordObject = widget.ppfRecordObject;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("PPF Record Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "${widget.client.name}\'s PPF Record Details",
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
                      Text("Name Of Institution"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue:
                                  widget.ppfRecordObject.nameOfInstitution,
                              decoration: buildCustomInput(
                                  hintText: "Name Of Institution"),
                              validator: (value) =>
                                  requiredField(value, 'Name Of Institution'),
                              onChanged: (value) =>
                                  _ppfRecordObject.nameOfInstitution = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                widget.ppfRecordObject.nameOfInstitution,
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
                      Text("Amount Of Payment"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue: widget.ppfRecordObject.amount,
                              decoration: buildCustomInput(
                                  hintText: "Amount Of Payment",
                                  suffixText: "\u{20B9}"),
                              onChanged: (value) =>
                                  _ppfRecordObject.accountNumber = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                "\u{20B9} " + widget.ppfRecordObject.amount,
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
                      Text("Date of investment"),
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
                                    '$_selectedDateOfPayment',
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      selectedDateOfPayment =
                                          await DateChange.selectDateTime(
                                              context, 1, 1);
                                      setState(() {
                                        _selectedDateOfPayment =
                                            DateFormat('dd/MMMM/yyyy')
                                                .format(selectedDateOfPayment);
                                        _ppfRecordObject.dateOfInvestment =
                                            _selectedDateOfPayment;
                                      });
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
                                widget.ppfRecordObject.dateOfInvestment,
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
                      Text("Account number"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit
                          ? TextFormField(
                              initialValue:
                                  widget.ppfRecordObject.accountNumber,
                              decoration:
                                  buildCustomInput(hintText: "Account Number"),
                              validator: (value) =>
                                  requiredField(value, 'Account number'),
                              onChanged: (value) =>
                                  _ppfRecordObject.accountNumber = value,
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              decoration: fieldsDecoration,
                              child: Text(
                                widget.ppfRecordObject.accountNumber,
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        decoration: roundedCornerButton,
                        child: edit
                            ? TextButton(
                                child: Text("Save Changes"),
                                onPressed: () async {
                                  await editRecord();
                                  Navigator.pop(context);
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
                        height: 10,
                      ),
                      Container(
                        decoration: roundedCornerButton,
                        child: TextButton(
                          child: loadDelete
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text("Delete"),
                          onPressed: () async {
                            loadDelete = true;
                            bool temp = false;
                            temp = await showConfirmationDialog(context);
                            if (temp) {
                              deleteRecord();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
    print(_ppfRecordObject.nameOfInstitution);
    try {
      dbf
          .child('complinces')
          .child('PPFRecord')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .update({
        'nameOfInstitution': _ppfRecordObject.nameOfInstitution,
        'accountNumber': _ppfRecordObject.accountNumber,
        'amount': _ppfRecordObject.amount,
        'dateOfInvestment': _ppfRecordObject.dateOfInvestment
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
    loadDelete = true;
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
                  await deleteRecord();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Edit'),
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
          .child('PPFRecord')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .remove();

      recordDeletedToast();

      Navigator.pop(context);
      Navigator.pop(context);
//      Navigator.push(context,
//        MaterialPageRoute(
//          builder: (context) => HistoryForPPF(
//            client: widget.client,
//          )
//        )
//      );

    } on PlatformException catch (e) {
      print(e.message);
      flutterToast(message: e.message);
    } catch (e) {
      print(e);
      flutterToast(message: "Something Wrong");
    }
  }
}

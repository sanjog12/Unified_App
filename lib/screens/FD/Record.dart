import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/payment/FDRecordObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateRelated.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';

class FDRecord extends StatefulWidget {
  final Client client;

  const FDRecord({this.client});

  @override
  _FDRecordState createState() => _FDRecordState();
}

class _FDRecordState extends State<FDRecord> {
  bool buttonLoading = false;
  bool entered = false;

  FDRecordObject fdRecordObject = FDRecordObject(termOfInvestment: '0');

  String selectedDateOfPayment = 'Select Date';
  DateTime selectedDateOfInvestment = DateTime.now();

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfInvestment,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1));

    if (picked != null && picked != selectedDateOfInvestment) {
      setState(() {
        selectedDateOfInvestment = picked;
        selectedDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
        fdRecordObject.dateOfInvestment = selectedDateOfPayment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Fixed Deposit Record"),
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Details of Fixed Deposit",
                  style: _theme.textTheme.headline6.merge(
                    TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
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
                        TextFormField(
                            decoration: buildCustomInput(
                                hintText: "Name Of Institution"),
                            onChanged: (value) {
                              fdRecordObject.nameOfInstitution = value;
                              entered = true;
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Fixed Deposit Number"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: buildCustomInput(
                                hintText: "Fixed Deposit Number"),
                            onChanged: (value) {
                              fdRecordObject.fixedDepositNo = value;
                              entered = true;
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Principal Amount"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: buildCustomInput(
                                hintText: "Principal Amount",
                                prefixText: "\u{20B9}"),
                            onChanged: (value) {
                              fdRecordObject.principalAmount = value;
                              entered = true;
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Date of Investment"),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: fieldsDecoration,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Maturity Amount"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: buildCustomInput(
                                hintText: "Maturity Amount",
                                prefixText: "\u{20B9}"),
                            onChanged: (value) {
                              fdRecordObject.maturityAmount = value;
                              entered = true;
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Rate Of Interest"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            decoration: buildCustomInput(
                                hintText: "Rate Of Interest", suffixText: "%"),
                            onChanged: (value) {
                              fdRecordObject.rateOfInterest = value;
                              entered = true;
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Term Of Investment"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            decoration: buildCustomInput(
                              hintText: "Term Of Investment",
                              suffixText: "Months"
                            ),
                            onChanged: (value) {
                              fdRecordObject.termOfInvestment = value;
                              entered = true;
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Second Holder (If Joint)"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            decoration: buildCustomInput(
                                hintText: "Second Holder Name"),
//                            validator: (value) =>
//                                requiredField(value, 'Term Of Investment'),
                            onChanged: (value) {
                              fdRecordObject.secondHolderName = value;
                              entered = true;
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Nominee Details"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            decoration: buildCustomInput(hintText: "Name"),
                            onChanged: (value) {
                              fdRecordObject.nomineeName = value;
                              entered = true;
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      decoration: roundedCornerButton,
                      height: 50.0,
                      child: TextButton(
                        child: Text("Save Record"),
                        onPressed: () {
                          addDetailsOfContribution();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> addDetailsOfContribution() async {
    try {
      if (entered) {
        setState(() {
          buttonLoading = true;
        });
        fdRecordObject.maturityDate = DateChange.addMonthToDate(fdRecordObject.dateOfInvestment, int.parse(fdRecordObject.termOfInvestment));
        await PaymentRecordToDataBase()
            .addFDRecord(fdRecordObject, widget.client)
            .then((value) {
          if (value) {
            flutterToast(message: "Record Saved Successfully");
          }
        });
      } else {
        flutterToast(message: "Nothing has been provided");
      }
    } on PlatformException catch (e) {
      flutterToast(message: e.message);
    } on FirebaseException catch (e) {
      flutterToast(message: e.message);
    } catch (e) {
      flutterToast(message: "Something went wrong");
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
}

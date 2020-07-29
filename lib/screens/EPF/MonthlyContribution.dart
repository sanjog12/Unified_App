import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/EPFMonthlyContributionObejct.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/openWebView.dart';
import 'package:unified_reminder/utils/validators.dart';

class MonthlyContribution extends StatefulWidget {
  final Client client;

  const MonthlyContribution({this.client});
  @override
  _MonthlyContributionState createState() => _MonthlyContributionState();
}

class _MonthlyContributionState extends State<MonthlyContribution> {
  bool buttonLoading = false;
  GlobalKey<FormState> _MonthlyContributionFormKey = GlobalKey<FormState>();

  EPFMonthlyContributionObejct epfMonthlyContributionObejct =
      EPFMonthlyContributionObejct();

  bool loadingSaveButton = false;
  
  DateTime selectedDateOfPayment = DateTime.now();

  String nameOfFile = 'Attach File';
  String _selectedDateOfPayment = 'Select Date';
  String showDateOfPayment = ' ';

  File file;



  Future<Null> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOfPayment ,
      firstDate: DateTime(DateTime.now().year-1),
      lastDate: DateTime(DateTime.now().year+1),
    );
  
    if(picked != null && picked != selectedDateOfPayment){
      setState(() {
        selectedDateOfPayment = picked;
        showDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
        epfMonthlyContributionObejct.dteOfFilling = showDateOfPayment;
        setState(() {
          _selectedDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
        });
      
      });
    }
  }
  
  
  
  
  

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Monthly Contribution"),
        ),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  "Monthly Contribution Payments",
                  style: _theme.textTheme.title.merge(
                    TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Enter your details to make payments for Monthly Contribution ",
                  style: _theme.textTheme.subtitle.merge(
                    TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Form(
                  key: _MonthlyContributionFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Date of Payment"),
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
                                  '$_selectedDateOfPayment',
                                ),
                                FlatButton(
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
                        height: 30.0,
                      ),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Amount of Payment"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration:
                                buildCustomInput(hintText: "Amount of Payment"),
                            validator: (value) =>
                                requiredField(value, 'Amount Of Payment'),
                            onChanged: (value) => epfMonthlyContributionObejct
                                .amountOfPayment = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
  
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Challan Number"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration:
                            buildCustomInput(hintText: "Challan Number"),
                            validator: (value) =>
                                requiredField(value, 'Challan number'),
                            onChanged: (value) => epfMonthlyContributionObejct
                                .challanNumber = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
      
                          Text('Add Attachment'),
                          SizedBox(height: 10),
                          Container(
                            decoration: roundedCornerButton,
                            height: 50,
                            child: FlatButton(
                              onPressed: () async{
                                file = await FilePicker.getFile();
                                List<String> temp = file.path.split('/');
                                epfMonthlyContributionObejct.addAttachment = temp.last;
                                setState(() {
                                  nameOfFile = temp.last;
                                });
                              },
          
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.attach_file),
                                  SizedBox(width: 6),
                                  Text(nameOfFile),
                                ],
                              ),
                            ),
                          ),
                        ],),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        decoration: roundedCornerButton,
                        height: 50.0,
                        child: FlatButton(
                          child: Text("Make Payment Online"),
                          onPressed: () {
                            openWebView(
                                'EPF Online Payment',
                                'https://unifiedportal-emp.epfindia.gov.in/epfo/',
                                context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: roundedCornerButton,
                        height: 50.0,
                        child: FlatButton(
                          child: Text("Save Payment"),
                          onPressed: () {
                            paymentMonthlyContribution();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> paymentMonthlyContribution() async {
    try {
      if (_MonthlyContributionFormKey.currentState.validate()) {
        _MonthlyContributionFormKey.currentState.save();
        this.setState(() {
          buttonLoading = true;
        });

        bool done = await PaymentRecordToDataBase()
            .AddMonthlyContributionPayment(
                epfMonthlyContributionObejct, widget.client, file);
        
        if (done) {
          Fluttertoast.showToast(
              msg: "Record Saved",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Color(0xff666666),
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
        }
      }
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Payment Not Saved This Time',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
}

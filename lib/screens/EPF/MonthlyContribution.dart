import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/payment/EPFMonthlyContributionObejct.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateRelated.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
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
  GlobalKey<FormState> _monthlyContributionFormKey = GlobalKey<FormState>();

  EPFMonthlyContributionObject epfMonthlyContributionObject =
      EPFMonthlyContributionObject();

  bool loadingSaveButton = false;
  
  DateTime selectedDateOfPayment = DateTime.now();

  String nameOfFile = 'Attach File';
  String _selectedDateOfPayment = 'Select Date';
  String showDateOfPayment = ' ';

  File file;
  
  
  

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("EPF Monthly Contribution"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  "Monthly Contribution Payments",
                  style: _theme.textTheme.headline6.merge(
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
                  style: _theme.textTheme.bodyText2.merge(
                    TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Form(
                  key: _monthlyContributionFormKey,
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
                                TextButton(
                                  onPressed: () async{
                                    selectedDateOfPayment = await DateChange.selectDateTime(context, 1, 1);
                                    setState(() {
                                      epfMonthlyContributionObject.dateOfFilling = DateFormat('dd-MM-yyyy').format(selectedDateOfPayment);
                                      _selectedDateOfPayment = DateFormat('dd-MM-yyyy').format(selectedDateOfPayment);

                                    });
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
                                buildCustomInput(hintText: "Amount of Payment", prefixText: "\u{20B9}"),
                            onChanged: (value) => epfMonthlyContributionObject
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
                            onChanged: (value) => epfMonthlyContributionObject
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
                            child: TextButton(
                              onPressed: () async{
                                FilePickerResult filePickerResult = await FilePicker.platform.pickFiles();
                                file = File(filePickerResult.files.single.path);
                                List<String> temp = file.path.split('/');
                                epfMonthlyContributionObject.addAttachment = temp.last;
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
                        child: TextButton(
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
                        child: TextButton(
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
                ),
                SizedBox(height: 70,),
              ],
            ),
          ),
        ));
  }

  Future<void> paymentMonthlyContribution() async {
    try {
      if (_monthlyContributionFormKey.currentState.validate()) {
        _monthlyContributionFormKey.currentState.save();
        this.setState(() {
          buttonLoading = true;
        });

        bool done = await PaymentRecordToDataBase()
            .addEPFMonthlyContribution(
                epfMonthlyContributionObject, widget.client, file);
        
        if (done) {
          flutterToast(message: "Recorded Saved");
          Navigator.pop(context);
        }
      }
    } on PlatformException catch (e) {
      print(e.message);
      flutterToast(message: e.message);
    } catch (e) {
      flutterToast(message: 'Payment Not Saved This Time');
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/IncomeTaxPaymentObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/openWebView.dart';
import 'package:unified_reminder/utils/validators.dart';



class IncomeTaxPayment extends StatefulWidget {
  final Client client;

  const IncomeTaxPayment({this.client});
  @override
  _IncomeTaxPaymentState createState() => _IncomeTaxPaymentState();
}

class _IncomeTaxPaymentState extends State<IncomeTaxPayment> {
  bool buttonLoading = false;
  GlobalKey<FormState> _incomeTaxPaymentFormKey = GlobalKey<FormState>();

  IncomeTaxPaymentObject incomeTaxPaymentObject = IncomeTaxPaymentObject();
  FirebaseStorage firebaseStorage;



  String nameOfFile = 'Select File';
  File file;

  String selectedDateDB = "Select Date";
  DateTime selectedDate = DateTime.now();

  Future<Null> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year-1),
      lastDate: DateTime(DateTime.now().year+1),
    );
  
    if(picked != null && picked != selectedDate){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDate= picked;
        print(picked);
        selectedDateDB = DateFormat('dd-MM-yyyy').format(picked);
        incomeTaxPaymentObject.dateOfPayment = selectedDateDB;
        selectedDateDB = DateFormat('dd-MM-yy').format(picked);
      });
    }
  }
  
  

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Income Tax Payment"),
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  "Income Tax Payment",
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
                  "Enter your details to make payments for Income Tax ",
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
                  key: _incomeTaxPaymentFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("BSR Code"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: buildCustomInput(hintText: "BSR Code"),
                            onSaved: (value) =>
                                incomeTaxPaymentObject.BSRcode = value,
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
                            onSaved: (value) =>
                                incomeTaxPaymentObject.challanNumber = value,
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
                                buildCustomInput(hintText: "Amount of Payment" , prefixText: "\u{20B9}"),
                            onSaved: (value) =>
                                incomeTaxPaymentObject.amountOfPayment = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
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
                                  '$selectedDateDB',
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
                        height: 30.0,
                      ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Add Attachment'),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(10),
                          color: buttonColor,
                        ),
                        height: 50,
                        child: TextButton(
                          onPressed: () async{
                            FilePickerResult filePickerResult = await FilePicker.platform.pickFiles();
                            file = File(filePickerResult.files.single.path);
                            List<String> temp = file.path.split('/');
                            print(temp.last);
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
                    ],
                  ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        decoration: roundedCornerButton,
                        height: 50.0,
                        child: TextButton(
                          child: Text("Make Payment Online"),
                          onPressed: () {
                            openWebView(
                                'Income Tax Online Payment',
                                'https://onlineservices.tin.egov-nsdl.com/etaxnew/tdsnontds.jsp',
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
                          child: Text("Save Payment Record"),
                          onPressed: () {
                            paymentIncomeTax();
                          },
                          
                        ),
                      ),
                      SizedBox(height: 20,),
                      helpButtonBelow("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20Incometax"),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ));
  }

  Future<void> paymentIncomeTax() async {
    try {
      if (_incomeTaxPaymentFormKey.currentState.validate()) {
        _incomeTaxPaymentFormKey.currentState.save();
        this.setState(() {
          buttonLoading = true;
        });

        bool done = await PaymentRecordToDataBase().addIncomeTaxPayment(
            incomeTaxPaymentObject, widget.client, file);

        if (done) {
          Navigator.pop(context);
        }
      }

      flutterToast(message: "Successfully Saved");
      
    } on PlatformException catch (e) {
      print(e.message);
      flutterToast(message: e.message);
    } catch (e) {
      print(e);
      flutterToast(message: "Something went wrong");
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
}

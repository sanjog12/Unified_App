import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/LICPaymentIObject.dart';
import 'package:unified_reminder/services/DropDownValuesHelper.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class LICPayment extends StatefulWidget {
  final Client client;

  const LICPayment({this.client});
  @override
  _LICPaymentState createState() => _LICPaymentState();
}

class _LICPaymentState extends State<LICPayment> {
  bool buttonLoading = false;
  GlobalKey<FormState> _TDSPaymentFormKey = GlobalKey<FormState>();

  LICPaymentObject licPaymentIObject = LICPaymentObject();
  
  DateTime selectedDatePremiumDate = DateTime.now();
  String selectedDatePremiumDateDB= 'Select Date';

  DateTime selectedDateMaturityDate = DateTime.now();
  String selectedDateMaturityDateDB= 'Select Date';

  DateTime selectedDateCommencement = DateTime.now();
  String selectedDateCommencementDB= 'Select Date';
  
  String _companyName, _frequency;
  
  String nameOfFile = "Select File";
  File file;
  
  Future<Null> selectDateTime(BuildContext context, int i) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: i==0?selectedDatePremiumDate:selectedDateCommencement,
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime(DateTime.now().year+1),
    );
    
    if(picked != null && picked != selectedDatePremiumDate && i==0){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDatePremiumDate= picked;
        print(picked);
        selectedDatePremiumDateDB = DateFormat('dd').format(picked)+"-of the month";
        licPaymentIObject.premiumDueDate = selectedDatePremiumDateDB;
        
      });
    }
    else if(picked != null && picked != selectedDatePremiumDate && i==1){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateCommencement= picked;
        print(picked);
        selectedDateCommencementDB = DateFormat('dd-MM-yyyy').format(picked);
        licPaymentIObject.dateOfCommoncement = selectedDateCommencementDB;
    
      });
    }
    else if(picked != null && picked != selectedDateMaturityDate && i==2){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateMaturityDate= picked;
        print(picked);
        selectedDateMaturityDateDB = DateFormat('dd-MM-yyyy').format(picked);
        licPaymentIObject.maturityDate = selectedDateMaturityDateDB;
    
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("LIC Payment"),
        actions: <Widget>[
          helpButtonActionBar('https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20LIC'),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 24.0, right: 24, left: 24, bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "LIC Payment",
                style: _theme.textTheme.headline.merge(
                  TextStyle(
                    fontSize: 26.0,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Enter your details to make payments for LIC",
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
                key: _TDSPaymentFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
//                    SizedBox(
//                      height: 30.0,
//                    ),
                    dropDownForCompanies(),

                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Policy Name"),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: "Policy Name"),
                          validator: (value) =>
                              requiredField(value, 'Policy Name'),
                          onChanged: (value) {
                            print("test case " +licPaymentIObject.comanyName);
                            licPaymentIObject.policyName = value;
                          }
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Policy No"),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: "Policy No"),
                          validator: (value) =>
                              requiredField(value, 'Policy No'),
                          onSaved: (value) =>
                              licPaymentIObject.policyNo = value,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Premium Due Date"),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            )
                          ],
                        ),
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
                                '$selectedDatePremiumDateDB',
                              ),
                              FlatButton(
                                onPressed: () {
                                  selectDateTime(context,0);
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
                        Row(
                          children: <Widget>[
                            Text("Premium Amount"),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration:
                              buildCustomInput(hintText: "Premium Amount"),
                          validator: (value) =>
                              requiredField(value, 'Premium Amount'),
                          onSaved: (value) =>
                              licPaymentIObject.premiumAmount = value,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    
                    dropDownForFrequency(),
                    
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Date Of Commencement"),
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
                                '$selectedDateCommencementDB',
                              ),
                              FlatButton(
                                onPressed: () {
                                  selectDateTime(context,1);
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
                        Row(
                          children: <Widget>[
                            Text("Premium Paying Term"),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red, fontSize: 22),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          
                          decoration:
                              buildCustomInput(hintText: "Premium Paying Term(in months)"),
                          validator: (value) =>
                              requiredField(value, 'Premium Paying Term'),
                          onSaved: (value) =>
                              licPaymentIObject.premiumPayingTerm = value,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Policy Term"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: "Policy Term"),
                          onSaved: (value) =>
                              licPaymentIObject.policyTerm = value,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Branch"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: "Branch"),
//                          validator: (value) =>
//                              requiredField(value, 'Policy Term'),
                          onSaved: (value) => licPaymentIObject.branch = value,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Agent Details"),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("Name"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: "Agent Name"),
                          onSaved: (value) =>
                              licPaymentIObject.agenName = value,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("Contact Number"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration:
                              buildCustomInput(hintText: "Contact Number"),
                          onSaved: (value) =>
                              licPaymentIObject.agentContactNumber = value,
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
                          decoration: roundedCornerButton,
                          height: 50,
                          child: FlatButton(
                            onPressed: () async{
                              file = await FilePicker.getFile();
                              List<String> temp = file.path.split('/');
                              print(temp.last);
                              setState(() {
                                nameOfFile = temp.last;
                              });
                              licPaymentIObject.attachement = nameOfFile;
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
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Nominee"),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("Name"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: " Name"),
//                          validator: (value) =>
//                              requiredField(value, 'Policy Term'),
                          onSaved: (value) =>
                              licPaymentIObject.nomineeName = value,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Maturity Date"),
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
                          '$selectedDateMaturityDateDB',
                          ),
                         FlatButton(
                          onPressed: () {
                            selectDateTime(context,2);
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
                    Container(
                      decoration: roundedCornerButton,
                      height: 50.0,
                      child: FlatButton(
                        child: buttonLoading?Container(
                          child: Center(
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                          ),
                        ):Text("Save Payment"),
                        onPressed: () {
                          paymentLIC();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDownForFrequency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Frequency"),
            SizedBox(
              width: 5,
            ),
            Text(
              "*",
              style: TextStyle(color: Colors.red, fontSize: 22),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        DropdownButtonFormField(
          hint: Text("Frequency"),
          decoration: dropDownDecoration(),
          validator: (String value) {
            return requiredField(value, "Frequency");
          },
          onSaved: (value) => licPaymentIObject.frequancey = value,
//                          decoration: buildCustomInput(),
          items: [
            DropdownMenuItem(
              child: Text("Monthly"),
              value: "monthly",
            ),
            DropdownMenuItem(
              child: Text("Quarterly"),
              value: "quarterly",
            ),
            DropdownMenuItem(
              child: Text("Half Yearly"),
              value: "halfYearly",
            ),
            DropdownMenuItem(
              child: Text("Yearly"),
              value: "yearly",
            ),
          ],
          value: _frequency,
          onChanged: (String v) {
            this.setState(() {
              _frequency = v;
              licPaymentIObject.frequancey = v;
            });
          },
        ),
      ],
    );
  }

  Widget dropDownForCompanies() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Company Name"),
            SizedBox(
              width: 5,
            ),
            Text(
              "*",
              style: TextStyle(color: Colors.red, fontSize: 22),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        FutureBuilder<List<String>>(
          future: DropDownValuesHelper().getCompaniesOfLIC(),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snap) {
            if (snap.hasData) {
//          print(snap.data[0]);
              return Container(
                padding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 16.0,
                ),
                decoration: fieldsDecoration,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _companyName,
                    items: snap.data
                        .map((title) => DropdownMenuItem<String>(
                              child: Container(child: Text(title)),
                              value: title,
                            ))
                        .toList(),
                    isExpanded: true,
                    hint: Text('Companies'),
                    onChanged: (String value) {
                      setState(() {
                        _companyName = value;
                        licPaymentIObject.comanyName = value;
                        print("value" +value);
//                    _teacherData.teacherHoldClass = value;
                    });
                  },
                  ),
                ),
              );
            } else
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
          },
        ),
      ],
    );
  }

  Future<void> paymentLIC() async {
    try {
      if (_TDSPaymentFormKey.currentState.validate()) {
        _TDSPaymentFormKey.currentState.save();
        if (_companyName != null) {
          this.setState(() {
            buttonLoading = true;
          });

          bool done = await PaymentRecordToDataBase().AddLICPayment(
            licPaymentIObject,
            widget.client,
            file
          );

          if (done) {
            Navigator.pop(context);
            flutterToast(message: "Data has been recorded");
          }
        }
      } else {
        flutterToast(message: 'Section Not Selected');
      }
    } on PlatformException catch (e) {
      print(e.message);
      flutterToast(message: e.message);
    } catch (e) {
      print(e);
      flutterToast(message: 'Payment Not Saved This Time');
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/LICPaymentIObject.dart';
import 'package:unified_reminder/services/DropDownValuesHelper.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';

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
  GlobalKey<FormState> _lICPaymentFormKey = GlobalKey<FormState>();

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
        firstDate: DateTime(DateTime.now().year-10),
        lastDate: DateTime(DateTime.now().year+10),
    );
    
    if(picked != null && picked != selectedDatePremiumDate && i==0){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDatePremiumDate= picked;
        print(picked);
        selectedDatePremiumDateDB = DateFormat('dd').format(picked)+" - of each month";
        licPaymentIObject.premiumDueDate = selectedDatePremiumDateDB;
      });
    }
    else if(picked != null && picked != selectedDateCommencement && i==1){
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
    FocusScope.of(context).requestFocus(new FocusNode());
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
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "LIC Payment",
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
                "Enter your details to make payments for LIC",
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
                key: _lICPaymentFormKey,
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
                        Text("Policy Name"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: "Policy Name"),
                          textInputAction: TextInputAction.next,
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
                        Text("Policy No"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: "Policy No"),
                          // validator: (value) =>
                          //     requiredField(value, 'Policy No'),
                          onChanged: (value) =>
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
                          children: [
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
                              TextButton(
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
                        Text("Premium Amount"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration:
                              buildCustomInput(hintText: "Premium Amount", prefixText: "\u{20B9}"),
                          onChanged: (value){licPaymentIObject.premiumAmount = value;},
                          keyboardType: TextInputType.number,
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
                        Row(
                          children: [
                            Text("Date Of Commencement"),
                            SizedBox(width: 5,),
                            Text(
                              "*", style: TextStyle(color: Colors.red, fontSize: 22),
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
                                '$selectedDateCommencementDB',
                              ),
                              TextButton(
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
                        Text("Premium Paying Term"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration:
                              buildCustomInput(hintText: "Premium Paying Term", suffixText: "Months"),
                          textInputAction: TextInputAction.next,
                          onChanged: (value) =>
                              licPaymentIObject.premiumPayingTerm = value,
                          keyboardType: TextInputType.number,
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
                          onChanged: (value) =>
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
                          textInputAction: TextInputAction.next,
//                          validator: (value) =>
//                              requiredField(value, 'Policy Term'),
                          onChanged: (value) => licPaymentIObject.branch = value,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Agent Details", style: TextStyle(color: Colors.blue),),
                        SizedBox(
                          height: 10.0,
                        ),
                        
                        
                        Text("Name"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration: buildCustomInput(hintText: "Agent Name"),
                          textInputAction: TextInputAction.next,
                          onChanged: (value) =>
                              licPaymentIObject.agenName = value,
                        ),
                        
                        SizedBox(height: 15.0,),
                        
                        
                        Text("Contact Number"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          decoration:
                              buildCustomInput(hintText: "Contact Number"),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) =>
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
                          child: TextButton(
                            onPressed: () async{
                              FilePickerResult filePickerResult = await FilePicker.platform.pickFiles();
                              file = File(filePickerResult.files.single.path);
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
                          textInputAction: TextInputAction.next,
//                          validator: (value) =>
//                              requiredField(value, 'Policy Term'),
                          onChanged: (value) =>
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
                        Row(
                          children: [
                            Text("Maturity Date"),
                            SizedBox(width: 5,),
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
                          '$selectedDateMaturityDateDB',
                          ),
                         TextButton(
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
                      child: TextButton(
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
              ),
              SizedBox(height: 70),
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
          onChanged: (String value) {
            FocusScope.of(context).requestFocus(new FocusNode());
            this.setState(() {
              _frequency = value;
              licPaymentIObject.frequancey = value;
            });
            FocusScope.of(context).unfocus();
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
                      FocusScope.of(context).requestFocus(new FocusNode());
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
      if (_lICPaymentFormKey.currentState.validate()) {
        _lICPaymentFormKey.currentState.save();
        if(selectedDatePremiumDateDB == 'Select Date'){
          throw PlatformException(code: '1001', message: 'Please select Premium Due Date');
        }
        if(selectedDateMaturityDateDB == 'Select Date'){
          throw PlatformException(code: '1001', message: 'Please select Policy Maturity Date');
        }
        if(selectedDateCommencementDB == 'Select Date'){
          throw PlatformException(code: '1001', message: 'Please select Policy Commencement Date');
        }
        
        if (_companyName != null) {
          this.setState(() {
            buttonLoading = true;
          });

          bool done = await PaymentRecordToDataBase().addLICPayment(
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

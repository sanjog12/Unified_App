import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/TDSPaymentObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unified_reminder/utils/openWebView.dart';
import 'package:unified_reminder/utils/validators.dart';


class TDSPayment extends StatefulWidget {
  
  final Client client ;

  const TDSPayment({Key key, this.client}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TDSPaymentState();
  }
}

class _TDSPaymentState extends State<TDSPayment>{
  
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  
  bool loadingSave = false;
  bool loadingPayment = false ;
  
  String sectionSelected ;
  String name = ' ';
  String extension;
  String nameOfFile = "Attach File";
  String showDateOfPayment = ' ';
  String _showDateOfPayment = 'Select Date';
  
  DateTime selectedDateOfPayment = DateTime.now();
  
  TDSPaymentObject tDSPaymentObject = TDSPaymentObject();
  
  File file;


  Future<Null> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfPayment,
        firstDate: DateTime(2019),
        lastDate: DateTime(2021)
    );
  
    if(picked != null && picked != selectedDateOfPayment){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateOfPayment= picked;
        print(picked);
        showDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
        tDSPaymentObject.dateOfPayment = showDateOfPayment;
        _showDateOfPayment = DateFormat('dd-MMMM-yy').format(picked);
      });
    }
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("TDS Payment"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "TDS Payment",
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
                "Enter your details to make payments for TDS",
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
                key: _key,
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
                          onSaved: (String value){
                            tDSPaymentObject.BSRcode = value;
                          },
                          decoration: buildCustomInput(hintText: "BSR Code"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Section"),
                        SizedBox(
                          height: 10.0,
                        ),
                        
                        DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Select Form'),
                          validator: (String value){
                            return requiredField(value, 'Section');
                          },
                          decoration: buildCustomInput(),
                          items: [
                            DropdownMenuItem(
                              child: Text('Payment to contractor and sub-contractor 194D'),
                              value: 'Payment to contractor and sub-contractor 194D',
                            ),
      
                            DropdownMenuItem(
                              child: Text('Winning from horse race 194C'),
                              value: 'Winning from horse race 194C',
                            ),
  
                            DropdownMenuItem(
                              child: Text('Winning from lottery or crossword puzzle 194BB'),
                              value: 'Winning from lottery or crossword puzzle 194BB',
                            ),
  
                            DropdownMenuItem(
                              child: Text('Interest o security 194B'),
                              value: 'Interest o security 194B',
                            ),
  
                            DropdownMenuItem(
                              child: Text('Interest other than'),
                              value: 'Interest other than',
                            ),
  
                            DropdownMenuItem(
                              child: Text('Interest on Securities 194'),
                              value: 'Interest on Securities 194',
                            ),
  
                            DropdownMenuItem(
                              child: Text('TDS on PF withdraw 193'),
                              value: 'TDS on PF withdraw 193',
                            ),
  
                            DropdownMenuItem(
                              child: Text('192-Salary 192A'),
                              value: '192-Salary 192A',
                            ),
  
                            DropdownMenuItem(
                              child: Text('Payment in respect of life insurance policy 194E'),
                              value: 'Payment in respect of life insurance policy 194E',
                            ),
  
                            DropdownMenuItem(
                              child: Text('Insurance Commission 194DA'),
                              value: 'Insurance Commission 194DA',
                            ),
                          ],
                          value: sectionSelected,
                          onChanged: (String value){
                            tDSPaymentObject.section = value;
                            setState(() {
                              sectionSelected = value;
                            });
                          },
                        )
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
                          onSaved: (String value) {
                            tDSPaymentObject.challanNumber = value;
                          },
                          decoration:
                              buildCustomInput(hintText: "Challan Number"),
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
                          onSaved: (String value){
                            tDSPaymentObject.amountOfPayment = value;
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration:
                              buildCustomInput(hintText: "Amount of Payment", prefixText: "\u{20B9}"),
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
                                '$_showDateOfPayment',
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
                        
                        Text('Add Attachment',),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          child: TextButton(
                            onPressed: () async{
                              FilePickerResult filePickerResult = await FilePicker.platform.pickFiles();
                              file = File(filePickerResult.files.single.path);
                              List<String> temp = file.path.split('/');
                              setState(() {
                                nameOfFile = temp.last;
                              });
                            },
                            
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.attach_file),
                                SizedBox(width: 6),
                                Text(nameOfFile,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                    
                    
                    SizedBox(
                      height: 40.0,
                    ),
                    
                    
                    Container(
                      decoration: roundedCornerButton,
                      height: 50.0,
                      child: loadingPayment?Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>
                            (Colors.white70),
                        ),
                      ) :TextButton(
                        child: Text("Make Payment"),
                        onPressed: () {
                          openWebView("Payment", 'https://onlineservices.tin.egov-nsdl.com/etaxnew/tdsnontds.jsp', context);
                        },
                        
                      ),
                    ),
                    
                    
                    SizedBox(
                      height: 20.0,
                    ),
                    
                    
                    Container(
                      decoration: roundedCornerButton,
                      height: 50.0,
                      child: loadingSave? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>
                            (Colors.white70),
                        ),
                      ):TextButton(
                        child: Text("Save Record"),
                        onPressed: () {
                          savePayment();
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    helpButtonBelow("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20TDS"),
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
  
  
  
  Future<void> savePayment() async{
    try {
      if (_key.currentState.validate()) {
        print('here at savePayment');
        _key.currentState.save();
        setState(() {
          loadingSave = true;
        });
        await PaymentRecordToDataBase().AddTDSPayment(
            tDSPaymentObject, widget.client, file);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Date has Been Recorded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xff666666),
            textColor: Colors.white,
            fontSize: 16.0);
      }
      else {
        print("error");
      }
    }on PlatformException catch(e){
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    }catch(e){
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

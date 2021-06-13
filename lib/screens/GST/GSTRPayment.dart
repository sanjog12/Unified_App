
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/payment/GSTPaymentObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';



class GSTPayment extends StatefulWidget {
  final Client client;
  final UpComingComplianceObject upComingComplianceObject;
  const GSTPayment({Key key, this.upComingComplianceObject, this.client}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return StateGSTRPayment();
  }
  
}

class StateGSTRPayment extends State<GSTPayment>{

  
  String selectedSection ;
  String showDateOfPaymentDB = ' ';
  String _showDateOfPayment = 'Select Date';
  String nameOfFile='No File Selected';
  
  File file;
  
  bool loadingSave = false;
  
  DateTime selectedDateOfPayment = DateTime.now().subtract(Duration(hours: 24));
  
  GSTPaymentObject gstPaymentObject = GSTPaymentObject();
  
  GlobalKey<FormState> key = GlobalKey<FormState>();



  Future<Null> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfPayment,
        firstDate: DateTime(2019),
        lastDate: DateTime(DateTime.now().year +2)
    );
  
    if(picked != null && picked != selectedDateOfPayment){
      setState(() {
        selectedDateOfPayment= picked;
        print(picked);
        showDateOfPaymentDB = DateFormat('dd-MM-yyyy').format(picked);
        gstPaymentObject.dueDate = showDateOfPaymentDB;
        _showDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    final ThemeData _theme = Theme.of(context);
    
    return Scaffold(
      
        appBar: AppBar(
          title: Text("GST Payment"),
          actions: [
            helpButtonActionBar("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20GST")
          ],
        ),
        
        
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('GST',style: _theme.textTheme.headline6.merge(TextStyle(
                      fontSize: 28
                  )
                  ),),
                  SizedBox(height: 10,),
                  Text('Enter your details to make payment for GST',style: _theme.textTheme.bodyText2.merge(TextStyle(
                    fontSize: 15
                  )),),
                  
                  SizedBox(height: 50,),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Constitution',style: TextStyle(
                      ),),
                      SizedBox(height: 10,),
                      Container(
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          
                          hint: Text('Section'),
                          validator: (String value){
                            return requiredField(value, 'Constitution');
                          },
                          decoration: buildCustomInput(),
                          items: [
                            DropdownMenuItem(
                              child: Text('GSTR 3B'),
                              value: 'GSTR 3B',
                            ),
          
                            DropdownMenuItem(
                              child: Text('GSTR 1'),
                              value: 'GSTR 1',
                            ),
          
                            DropdownMenuItem(
                              child: Text('GST RET-1'),
                              value: 'GST RET-1',
                            ),
          
                            DropdownMenuItem(
                              child: Text('ANX-1'),
                              value: 'ANX-1',
                            ),
                            DropdownMenuItem(
                              child: Text('ANX-2'),
                              value: 'ANX-2',
                            ),
                            DropdownMenuItem(
                              child: Text('GST RET-2'),
                              value: 'GST RET-2',
                            ),
          
                            DropdownMenuItem(
                              child: Text('GST RET-3'),
                              value: 'GST RET-3',
                            ),
                          ],
                          value: selectedSection,
                          onChanged: (String value){
                            gstPaymentObject.section = value;
                            setState(() {
                              selectedSection= value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  

                  
                  SizedBox(height: 30,),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Challan Number'),
                      SizedBox(height: 10,),
                      
                      TextFormField(
                        decoration: buildCustomInput(hintText: 'Challan Number'),
                        validator:(String value)=>requiredField(value, 'Challan Number'),
                        onSaved: (String value){
                          gstPaymentObject.challanNumber= value;
                        },
                      )
                    ],
                  ),
                  
                  SizedBox(height: 30,),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Amount of Payment'),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: buildCustomInput(hintText: 'Amount of Payment', prefixText: "\u{20B9}"),
                        validator: (String value){
                          return requiredField(value, 'Amount of Payment');
                        },
                        onSaved: (String value){
                          gstPaymentObject.amountOfPayment = value;
                        },
                      )
                    ],
                  ),
                  
                  SizedBox(height: 30,),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Date of Payment'),
                      SizedBox(height: 10,),
                      Container(
                        decoration: roundedCornerButton,
                        padding: EdgeInsets.symmetric(horizontal: 10),
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
                  SizedBox(height: 30,),
                  
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
                            gstPaymentObject.addAttachment = nameOfFile;
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
                      
                      SizedBox(height: 50,),
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
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(height: 70,),
                ],
              ),
            ),
          ),
        ),
    );
  }
  
  
  Future<void> savePayment() async{
    print('1');
    try{
    if(key.currentState.validate()){
      print('2');
      key.currentState.save();
      setState(() {
        loadingSave= true;
      });
      print('3');
      await PaymentRecordToDataBase().addGSTPayment(gstPaymentObject, widget.client, file);
      Navigator.pop(context);
      flutterToast(message: "Date has Been Recorded");
      
      
    }else{
      print('Something in GSTRPayment Screen wrong with SavePayment ');
    }
    }on PlatformException catch(e){
      print('here');
      flutterToast(message: e.message.toString());
      setState(() {
        loadingSave=false;
      });
    }catch(e){
      print(e);
      flutterToast(message: "Something went wrong");
      setState(() {
        loadingSave=false;
      });
    }
  }
}

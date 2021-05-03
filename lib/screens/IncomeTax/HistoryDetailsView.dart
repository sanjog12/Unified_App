import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/IncomeTaxPaymentObject.dart';
import 'package:unified_reminder/services/PDFView.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class IncomeTaxPaymentRecordRecordHistoryDetailsView extends StatefulWidget {
  final Client client;
  final IncomeTaxPaymentObject incomeTaxPaymentObject;
  final String keyDB;
  
  const IncomeTaxPaymentRecordRecordHistoryDetailsView({
    this.client,
    this.incomeTaxPaymentObject,
    this.keyDB,
  });

  @override
  _IncomeTaxPaymentRecordRecordHistoryDetailsViewState createState() =>
      _IncomeTaxPaymentRecordRecordHistoryDetailsViewState();
}

class _IncomeTaxPaymentRecordRecordHistoryDetailsViewState extends State<IncomeTaxPaymentRecordRecordHistoryDetailsView> {
  
  bool loadingDelete = false ;
  bool edit = false;
  bool newFile = false;
  
  String nameOfFile = "Attach File";
  
  File file;
  
  IncomeTaxPaymentObject _incomeTaxPaymentObject;

  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  String firebaseUserId;
  
  DateTime selectedDate = DateTime.now();
  String selectedDateDB ;


  Future<Null> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1)
    );
  
    if(picked != null && picked != selectedDate){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDate = picked;
        print(picked);
        selectedDateDB = DateFormat('dd-MM-yyyy').format(picked);
        _incomeTaxPaymentObject.dateOfPayment = selectedDateDB;
      });
    }
  }

  fireUser() async{
    firebaseUserId = await SharedPrefs.getStringPreference("uid");
  }
  
  
  
  @override
  void initState() {
    super.initState();
    _incomeTaxPaymentObject = widget.incomeTaxPaymentObject;
    selectedDateDB = widget.incomeTaxPaymentObject.dateOfPayment;
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Income Tax Payment Record"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "${widget.client.name}\'s Income Tax Payment Details",
                style: _theme.textTheme.headline6.merge(
                  TextStyle(
                    fontSize: 26.0,
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("BSR Code"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.incomeTaxPaymentObject.BSRcode,
                        decoration: buildCustomInput(hintText: "BSR Code"),
                        onChanged: (value) =>
                        _incomeTaxPaymentObject.BSRcode = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.incomeTaxPaymentObject.BSRcode,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Amount of payment"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.incomeTaxPaymentObject.amountOfPayment,
                        decoration:
                        buildCustomInput(hintText: "Amount of Payment"),
                        onChanged: (value) =>
                        _incomeTaxPaymentObject.amountOfPayment = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text( "\u{20B9} " +
                          widget.incomeTaxPaymentObject.amountOfPayment,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Challan number"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.incomeTaxPaymentObject.challanNumber,
                        decoration:
                        buildCustomInput(hintText: "Challan Number"),
                        onChanged: (value) =>
                        _incomeTaxPaymentObject.challanNumber = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.incomeTaxPaymentObject.challanNumber,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Date of payment"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?Container(
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
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.incomeTaxPaymentObject.dateOfPayment,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  edit?Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Text( _incomeTaxPaymentObject.addAttachment != "null"? "Add New File":"Add challan PDF"),
                      SizedBox(height: 10,),
                      Container(
                        height: 50,
                        child: TextButton(
                          onPressed: () async{
                            await FilePicker.platform.pickFiles().then((value){
                            
                            });
                            List<String> temp = file.path.split('/');
                            print(temp.last);
                            setState(() {
                              nameOfFile = temp.last;
                              newFile = true;
                              print(newFile);
                            });
                          },
          
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.attach_file),
                              SizedBox(width: 6),
                              Text(nameOfFile !='null'?nameOfFile:"Add File"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ):Container(),
  
                  widget.incomeTaxPaymentObject.addAttachment!= "null"?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 30,),
                      Container(
                        decoration: roundedCornerButton,
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Click to see challan"),
                              Divider(color: Colors.white,height: 10,),
                              Container(child: GestureDetector(child: Icon(Icons.delete,color: Colors.red),
                                onTap: (){print("pressed");deletePDF(context);},),
                                color: Colors.white,)
                            ],
                          ),
                          onPressed: (){
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context)=> PDFViewer(
                                  pdf: widget.incomeTaxPaymentObject.addAttachment,
                                )
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ) :Container(),
                  
                  SizedBox(height: 50,),
  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        decoration: roundedCornerButton,
                        child: edit ?
                        TextButton(
                          child: Text("Save Changes"),
                          onPressed: () async{
                            await editRecord();
                            Navigator.pop(context);
                          },
                        ) :
                        TextButton(
                          child: Text("Edit"),
                          onPressed: (){
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
                          child: loadingDelete ?
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>
                                (Colors.white),
                            ),
                          )
                              :Text("Delete"),
                          onPressed: () async{
                            loadingDelete = true;
                            bool temp = false;
                            temp = await showConfirmationDialog(context);
                            if(temp){
                              await deleteRecord();
                            }
                          },
                        ),
                      ),
                    ],)
                ],
              ),
              SizedBox(height: 70,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editRecord() async{
    print("editRecord");
    dbf = firebaseDatabase.reference();
    await fireUser();
    print("got firebaseId");
    print(firebaseUserId);
    print(widget.client.email);
    print(widget.keyDB);
//    print();
    try{
  
      if(newFile == true){
        print("1");
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        if(widget.incomeTaxPaymentObject.addAttachment != "null"){
          print("2");
          String path =  firebaseStorage.ref().child('files').child(widget.incomeTaxPaymentObject.addAttachment).fullPath;
          print("3");
          await firebaseStorage.ref().child(path).delete().then((_)=>print("Done Task"));
        }
        print("4");
        String name = await PaymentRecordToDataBase().uploadFile(file);
        print("5");
        dbf = firebaseDatabase.reference();
        dbf
            .child('complinces')
            .child('IncomeTaxPayments')
            .child(firebaseUserId)
            .child(widget.client.email)
            .child(widget.keyDB)
            .update({
          'addAttachment': name,
        });
      }
      
      dbf
          .child('complinces')
          .child('IncomeTaxPayments')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .update({
        'BSRcode': _incomeTaxPaymentObject.BSRcode,
        'amountOfPayment' : _incomeTaxPaymentObject.amountOfPayment,
        'challanNumber' : _incomeTaxPaymentObject.challanNumber,
        'dateOfPayment' : _incomeTaxPaymentObject.dateOfPayment,
          });
      
      recordEditToast();
    
    }on PlatformException catch(e){
      print(e.message);
      flutterToast(message: e.message);
    }catch(e){
      print(e);
      flutterToast(message: "Something went wrong");
    }
  }


  Future<void> showConfirmation(BuildContext context) async{
    loadingDelete = true;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Confirm',textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
          
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Text("Sure Want to Delete ?",style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
            ),
          
            actions: <Widget>[
              TextButton(
                child: Text('Confirm'),
                onPressed: () async{
                  Navigator.of(context).pop();
                  await deleteRecord();
                
                },
              ),
            
              TextButton(
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }


  Future<void> deleteRecord() async{
    dbf = firebaseDatabase.reference();
    await fireUser();
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    print(firebaseUserId);
    print(widget.client.email);
    print(widget.keyDB);
    try {
      if(_incomeTaxPaymentObject.addAttachment != "null") {
        String path = firebaseStorage
            .ref()
            .child('files')
            .child(widget.incomeTaxPaymentObject.addAttachment)
            .fullPath;
        await firebaseStorage.ref().child(path).delete().then((_) =>
            print("Done Task"));
      }
      await dbf
          .child('complinces')
          .child('IncomeTaxPayments')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .remove();
      recordDeletedToast();
      Navigator.pop(context);
      Navigator.pop(context);
    
    }on PlatformException catch(e){
      print(e.message);
      flutterToast(message: e.message);
    }catch(e){
      print(e);
      flutterToast(message: "Something went wrong");
    }
  }

  Future<void> deletePDF(BuildContext context) async{
    try{
      return showDialog<void>(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Confirm',textAlign: TextAlign.center,style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
            
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Text("Sure Want to Delete ?",style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                  ],
                ),
              ),
            
              actions: <Widget>[
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () async{
                    try {
                      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
                      String path = firebaseStorage
                          .ref()
                          .child('files')
                          .child(widget.incomeTaxPaymentObject.addAttachment)
                          .fullPath;
                      firebaseStorage = FirebaseStorage.instance;
                      await firebaseStorage.ref().child(path).delete();
                      print("here");
                      await fireUser();
                      dbf = firebaseDatabase.reference();
                      dbf
                          .child('complinces')
                          .child('IncomeTaxPayments')
                          .child(firebaseUserId)
                          .child(widget.client.email)
                          .child(widget.keyDB)
                          .update({
                        'addAttachment': 'null',
                      });
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                      flutterToast(message: "PDF Deleted");
                    }catch(e){
                      print(e.toString());
                    }
                  },
                ),
              
                TextButton(
                  child: Text('Cancel'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );}catch(e){
      print(e);
      flutterToast(message: "Something went wrong");
    }
  }
  
  
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/EPFMonthlyContributionObejct.dart';
import 'package:unified_reminder/services/GeneralServices/PDFView.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';

class EPFRecordHistoryDetailsView extends StatefulWidget {
  final Client client;
  final EPFMonthlyContributionObject epfMonthlyContributionObejct;
  final String keyDB;

  const EPFRecordHistoryDetailsView({Key key, this.client, this.epfMonthlyContributionObejct, this.keyDB}) : super(key: key);
  

  @override
  _EPFRecordHistoryDetailsViewState createState() =>
      _EPFRecordHistoryDetailsViewState();
}



class _EPFRecordHistoryDetailsViewState
    extends State<EPFRecordHistoryDetailsView> {
  
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  bool loadingDelete = false;
  bool edit = false;
  bool newFile = false;
  String firebaseUserId;
  String nameOfFile = "Add File";
  EPFMonthlyContributionObject _epfMonthlyContributionObejct;
  DateTime selectedDate = DateTime.now();
  String selectedDateDB;
  File file;
  
  
  Future<void> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year+1)
    );
    
    if(picked != null && picked != selectedDate){
      setState((){
        selectedDate = picked;
        selectedDateDB = DateFormat('dd-MM-yyyy').format(picked);
        _epfMonthlyContributionObejct.dateOfFilling = selectedDateDB;
      });
    }
  }
  
  
  fireUser() async{
    firebaseUserId = await SharedPrefs.getStringPreference("uid");
  }
  
  @override
  void initState() {
    super.initState();
    _epfMonthlyContributionObejct = widget.epfMonthlyContributionObejct;
    selectedDateDB = widget.epfMonthlyContributionObejct.dateOfFilling;
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("EPF Monthly Contribution Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "${widget.client.name}\'s EPF Monthly Contribution Details",
                style: _theme.textTheme.headline6.merge(
                  TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Date of Filling"),
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
                      ):Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.epfMonthlyContributionObejct.dateOfFilling,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Amount of payment"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.epfMonthlyContributionObejct.amountOfPayment,
                        decoration:
                        buildCustomInput(hintText: "Amount of Payment",prefixText: "\u{20B9}"),
                        onChanged: (value) => _epfMonthlyContributionObejct
                            .amountOfPayment = value,
                      ):Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.epfMonthlyContributionObejct.amountOfPayment,
                          style: TextStyle(color: whiteColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Challan Number"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.epfMonthlyContributionObejct.challanNumber,
                        decoration:
                        buildCustomInput(hintText: "Challan Number"),
                        onChanged: (value) => _epfMonthlyContributionObejct.challanNumber = value,
                      ):Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.epfMonthlyContributionObejct.challanNumber,
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
                  
  
                  edit?Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(_epfMonthlyContributionObejct.addAttachment != null?'Add New File':"Add File"),
                      SizedBox(height: 10,),
                      Container(
                        height: 50,
                        child: TextButton(
                          onPressed: () async{
                            FilePickerResult filePickerResult = await FilePicker.platform.pickFiles();
                            file = File(filePickerResult.files.single.path);
                            List<String> temp = file.path.split('/');
                            print(temp.last);
                            setState(() {
                              nameOfFile = temp.last;
                              newFile = true;
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
                      SizedBox(height: 30,),
                    ],
                  ):Container(),
  
                  widget.epfMonthlyContributionObejct.addAttachment != "null"?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
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
                                    builder: (context)=>PDFViewer(
                                      pdf: widget.epfMonthlyContributionObejct.addAttachment,
                                    )
                                )
                            );
                          },
                        ),
                      )
                    ],
                  ):Container(),
  
                  SizedBox(height: 50),
  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        decoration: roundedCornerButton,
        
                        child: edit?TextButton(
                          child: Text("Save Changes"),
                          onPressed: (){
                            editRecord();
                          },
                        ) :TextButton(
                          child: Text("Edit"),
                          onPressed: (){
                            setState(() {
                              edit= true;
                            });
                          },
                        ),
                      ),
      
                      SizedBox(height: 20,),
      
                      Container(
                        decoration: roundedCornerButton,
                        child: TextButton(
                          child: Text("Delete Record"),
                          onPressed: () async{
                            await showConfirmation(context);
                          },
                        ),
                      ),
                    ],
                  )
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
    print(_epfMonthlyContributionObejct.challanNumber);
    try{
    
      if(newFile == true){
        print("1");
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        if(widget.epfMonthlyContributionObejct.addAttachment != "null"){
          print("2");
          String path =  firebaseStorage.ref().child('files').child(widget.epfMonthlyContributionObejct.addAttachment).fullPath;
          print("3");
          await firebaseStorage.ref().child(path).delete().then((_)=>print("Done Task"));
        }
        print("4");
        String name = await PaymentRecordToDataBase().uploadFile(file);
        print("5");
        dbf = firebaseDatabase.reference();
        dbf
            .child('complinces')
            .child('MonthlyContributionPayments')
            .child(firebaseUserId)
            .child(widget.client.email)
            .child(widget.keyDB)
            .update({
          'addAttachment': name,
        });
        
        setState(() {
          widget.epfMonthlyContributionObejct.addAttachment = name;
        });
      }
    
      dbf
          .child('complinces')
          .child('MonthlyContributionPayments')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .update({
        'challanNumber': _epfMonthlyContributionObejct.challanNumber,
        'amountOfPayment': _epfMonthlyContributionObejct.amountOfPayment,
        'dateOfFilling': _epfMonthlyContributionObejct.dateOfFilling,
      });
      setState(() {
        edit = false;
      });
      flutterToast(message: "Changes saved");
    
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
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    await fireUser();
    print(firebaseUserId);
    print(widget.client.email);
    print(widget.keyDB);
    try {
    
      if(_epfMonthlyContributionObejct.addAttachment != 'null') {
        String path = firebaseStorage
            .ref()
            .child('files')
            .child(widget.epfMonthlyContributionObejct.addAttachment)
            .fullPath;
        await firebaseStorage.ref().child(path).delete().then((_) =>
            print("Done Task"));
      }
      
      await dbf
          .child('complinces')
          .child('MonthlyContributionPayments')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .remove();
      flutterToast(message: "Record Deleted");
      Navigator.pop(context);
      Navigator.pop(context);
//      Navigator.push(context,
//        MaterialPageRoute(
//            builder: (context)=>ComplianceHistoryForEPF(
//              client: widget.client,
//            )
//        )
//      );
    
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
                          .child(widget.epfMonthlyContributionObejct.addAttachment)
                          .fullPath;
                      firebaseStorage = FirebaseStorage.instance;
                      await firebaseStorage.ref().child(path).delete();
                      print("here");
                      await fireUser();
                      dbf = firebaseDatabase.reference();
                      dbf
                          .child('complinces')
                          .child('MonthlyContributionPayments')
                          .child(firebaseUserId)
                          .child(widget.client.email)
                          .child(widget.keyDB)
                          .update({
                        'addAttachment': 'null',
                      });
                      setState(() {
                        widget.epfMonthlyContributionObejct.addAttachment = 'null';
                      });
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

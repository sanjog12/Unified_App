import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unified_reminder/services/GeneralServices/PDFView.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/payment/LICPaymentIObject.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';

class LICPaymentRecordHistoryDetailsView extends StatefulWidget {
  final Client client;
  final LICPaymentObject licPaymentObject;
  final String keyDB;

  const LICPaymentRecordHistoryDetailsView({Key key, this.client, this.licPaymentObject, this.keyDB}) : super(key: key);
  

  @override
  _LICPaymentRecordHistoryDetailsViewState createState() =>
      _LICPaymentRecordHistoryDetailsViewState();
}

class _LICPaymentRecordHistoryDetailsViewState
    extends State<LICPaymentRecordHistoryDetailsView> {
  
  bool edit = false;
  bool loadingDelete = false;
  bool newFile = false;

  DateTime selectedDatePremiumDate = DateTime.now();
  String selectedDatePremiumDateDB= 'Select Date';

  DateTime selectedDateMaturityDate = DateTime.now();
  String selectedDateMaturityDateDB= 'Select Date';

  DateTime selectedDateCommencement = DateTime.now();
  String selectedDateCommencementDB= 'Select Date';
  
  File file;
  String nameOfFile;
  String frequency;

  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  String firebaseUserId;
  
  LICPaymentObject _licPaymentObject;
  
  DateTime selectedDate = DateTime.now();
  String selectedDateDB;




  Future<Null> selectDateTime(BuildContext context, int i) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: i==0?selectedDatePremiumDate:selectedDateCommencement,
      firstDate: DateTime(DateTime.now().year-i),
      lastDate: DateTime(DateTime.now().year+1),
    );
  
    if(picked != null && picked != selectedDatePremiumDate && i==0){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDatePremiumDate= picked;
        print(picked);
        selectedDatePremiumDateDB = DateFormat('dd/MM/yyyy').format(picked);
        _licPaymentObject.premiumDueDate = selectedDatePremiumDateDB;
      
      });
    }
    else if(picked != null && picked != selectedDatePremiumDate && i==1){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateCommencement= picked;
        print(picked);
        selectedDateCommencementDB = DateFormat('dd-MM-yyyy').format(picked);
        _licPaymentObject.dateOfCommencement = selectedDateCommencementDB;
      
      });
    }
    else if(picked != null && picked != selectedDateMaturityDate && i==2){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateMaturityDate= picked;
        print(picked);
        selectedDateMaturityDateDB = DateFormat('dd-MM-yyyy').format(picked);
        _licPaymentObject.dateOfCommencement = selectedDateMaturityDateDB;
      
      });
    }
  }

  fireUser() async{
    firebaseUserId = await SharedPrefs.getStringPreference("uid");
  }
  
  
  @override
  void initState() {
    super.initState();
    _licPaymentObject = widget.licPaymentObject;
    nameOfFile = widget.licPaymentObject.attachment;
    selectedDateMaturityDateDB = widget.licPaymentObject.maturityDate;
    selectedDateCommencementDB = widget.licPaymentObject.dateOfCommencement;
    selectedDatePremiumDateDB = widget.licPaymentObject.premiumDueDate;
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("LIC Payment Record"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "${widget.client.name}\'s LIC Payment Details",
                style: _theme.textTheme.headline6.merge(
                  TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Company Name"),
                  SizedBox(
                    height: 10.0,
                  ),
                  edit?TextFormField(
                    initialValue: widget.licPaymentObject.companyName,
                    decoration: buildCustomInput(hintText: "Company Name"),
                    onSaved: (value) =>
                    _licPaymentObject.companyName = value,
                  )
                      :Container(
                    padding: EdgeInsets.all(15),
                    decoration: fieldsDecoration,
                    child: Text(widget.licPaymentObject.companyName != null?
                      widget.licPaymentObject.companyName:" ",
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    ),
                  )
                ],
              ),
              
              SizedBox(height: 20,),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Policy Name"),
                  SizedBox(
                    height: 10.0,
                  ),
                  edit?TextFormField(
                      decoration: buildCustomInput(hintText: "Policy Name"),
                      initialValue: widget.licPaymentObject.policyName,
                      validator: (value) =>
                          requiredField(value, 'Policy Name'),
                      onChanged: (value) {
                        _licPaymentObject.policyName = value;
                      }
                  ):Container(
                    padding: EdgeInsets.all(15),
                    decoration: fieldsDecoration,
                    child: Text(
                      widget.licPaymentObject.policyName != null?widget.licPaymentObject.policyName:"*enter",
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Policy No"),
                  SizedBox(
                    height: 10.0,
                  ),
                  edit?TextFormField(
                    initialValue: widget.licPaymentObject.policyNo,
                    decoration: buildCustomInput(hintText: "Policy No"),
                    onChanged: (value) =>
                    _licPaymentObject.policyNo = value,
                  )
                      :Container(
                    padding: EdgeInsets.all(15),
                    decoration: fieldsDecoration,
                    child: Text(
                      widget.licPaymentObject.policyNo,
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
                  Text("Premium due date"),
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
                  ):Container(
                    padding: EdgeInsets.all(15),
                    decoration: fieldsDecoration,
                    child: Text(
                      widget.licPaymentObject.premiumDueDate,
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
                  Text("Premium Amount"),
                  SizedBox(
                    height: 10.0,
                  ),
                  edit?TextFormField(
                    initialValue: widget.licPaymentObject.premiumAmount,
                    decoration:
                    buildCustomInput(hintText: "Premium Amount"),
                    onChanged: (value) =>
                    _licPaymentObject.premiumAmount = value,
                  ):Container(
                    padding: EdgeInsets.all(15),
                    decoration: fieldsDecoration,
                    child: Text(
                      widget.licPaymentObject.premiumAmount,
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
                  Text("Frequency"),
                  SizedBox(
                    height: 10.0,
                  ),
                  edit?DropdownButtonFormField(
                    hint: Text(widget.licPaymentObject.frequency),
                    decoration: dropDownDecoration(),
                    validator: (String value) {
                      return requiredField(value, "Frequency");
                    },
                    onSaved: (value) => _licPaymentObject.frequency = value,
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
                    value: frequency,
                    onChanged: (String v) {
                      this.setState(() {
                        frequency = v;
                        _licPaymentObject.frequency = v;
                      });
                    },
                  ):Container(
                    padding: EdgeInsets.all(15),
                    decoration: fieldsDecoration,
                    child: Text(
                      widget.licPaymentObject.frequency,
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
                  Text("Date of Commencement"),
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
                  )
                      :Container(
                    padding: EdgeInsets.all(15),
                    decoration: fieldsDecoration,
                    child: Text(
                      widget.licPaymentObject.dateOfCommencement != null?
                      widget.licPaymentObject.dateOfCommencement:"*Enter",
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
                  Text("Premium paying term"),
                  SizedBox(
                    height: 10.0,
                  ),
                  edit?TextFormField(
                    initialValue: widget.licPaymentObject.premiumPayingTerm,
                    decoration:
                    buildCustomInput(hintText: "Premium Paying Term"),
                    validator: (value) =>
                        requiredField(value, 'Premium Paying Term'),
                    onChanged: (value) =>
                    _licPaymentObject.premiumPayingTerm = value,
                  ):Container(
                    padding: EdgeInsets.all(15),
                    decoration: fieldsDecoration,
                    child: Text(
                      widget.licPaymentObject.premiumPayingTerm,
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
  
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              Text("Policy terms"),
              SizedBox(
                height: 10.0,
              ),
              edit?TextFormField(
                initialValue: widget.licPaymentObject.policyTerm,
                decoration: buildCustomInput(hintText: "Policy Term"),
                onSaved: (value) =>
                _licPaymentObject.policyTerm = value,
              ):Container(
                padding: EdgeInsets.all(15),
                decoration: fieldsDecoration,
                child: Text(
                  widget.licPaymentObject.policyTerm,
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              )
            ],),
              SizedBox(
            height: 20.0,
          ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                Text("Branch"),
                SizedBox(
                  height: 10.0,
                ),
                edit?TextFormField(
                  initialValue: widget.licPaymentObject.branch,
                  decoration: buildCustomInput(hintText: "Branch"),
                  onChanged: (value) => _licPaymentObject.branch = value,
                  )
                    :Container(
                  padding: EdgeInsets.all(15),
                  decoration: fieldsDecoration,
                  child: Text(
                    widget.licPaymentObject.branch,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Divider(
                        thickness: 1.5,
                      ),
                      Text("Agent Details",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("Agent name"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.licPaymentObject.agentName,
                        decoration: buildCustomInput(hintText: "Agent Name"),
                        onChanged: (value) =>
                        _licPaymentObject.agentName = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.licPaymentObject.agentName,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Agent contact number"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.licPaymentObject.agentContactNumber,
                        decoration:
                        buildCustomInput(hintText: "Contact Number"),
                        onChanged: (value) =>
                        _licPaymentObject.agentContactNumber = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.licPaymentObject.agentContactNumber,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(thickness: 1.5,),
                  ],),
                  SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Nominee Name"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.licPaymentObject.nomineeName,
                        decoration: buildCustomInput(hintText: " Name"),
                        onSaved: (value) =>
                        _licPaymentObject.nomineeName = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.licPaymentObject.nomineeName,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  
                  SizedBox(
                    height: 10.0,
                  ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Maturity Date"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: fieldsDecoration,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            selectedDateMaturityDateDB != null?Text(
                              '$selectedDateMaturityDateDB'
                            ):Text(
                                'null'
                            ),
                            TextButton(
                              onPressed: () {
                                selectDateTime(context,2);
                              },
                              child: Icon(Icons.date_range),
                            ),
                          ],
                        ),
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: widget.licPaymentObject.maturityDate!=null?Text(
                          widget.licPaymentObject.maturityDate,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ):Text("null"),
                      )
                    ],
                  ),
                  
                  
                  
                  SizedBox(
                    height: 20.0,
                  ),
  
              edit?Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(widget.licPaymentObject.attachment!= "null"?'Add New File': "Add Challan"),
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
  
              widget.licPaymentObject.attachment!= "null"?
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: roundedCornerButton,
                    child: TextButton(
                      child:Row(
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
                                pdf: widget.licPaymentObject.attachment,
                              ),
                            )
                        );
                      },
                    ),
                  )
                ],
              ):Container(),
                  
                  SizedBox(height: 40,),
              
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                  Container(
                    decoration: roundedCornerButton,
                    child: edit
                        ?TextButton(
                      child: Text("Save Changes"),
                      onPressed: () async{
                        await editRecord();
                        Navigator.pop(context);
                      },
                    )
                        :TextButton(
                      child: Text("Edit"),
                      onPressed: (){
                        setState(() {
                          edit = true;
                        });
                      },
                    ),
                  ),],
                ),
              
              SizedBox(height: 20,),
  
              Container(
                decoration: roundedCornerButton,
                child: TextButton(
                  child: loadingDelete
                      ?Center(
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
                      deleteRecord();
                    }
                    },
                ),
              ),
              SizedBox(height: 70),
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
    print(_licPaymentObject.agentName);
    try{
      if(newFile == true){
        print("1");
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        if(widget.licPaymentObject.attachment != "null"){
          print("2");
          String path =  firebaseStorage.ref().child('files').child(widget.licPaymentObject.attachment).fullPath;
          print("3");
          await firebaseStorage.ref().child(path).delete().then((_)=>print("Done Task"));
        }
        print("4");
        String name = await PaymentRecordToDataBase().uploadFile(file);
        print("5");
        dbf = firebaseDatabase.reference();
        dbf
            .child('complinces')
            .child('LICPayment')
            .child(firebaseUserId)
            .child(widget.client.email)
            .child(widget.keyDB)
            .update({
          'attachment': name,
        });
      }
      dbf
          .child('complinces')
          .child('LICPayment')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .update({
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
                child: Text('Yes'),
                onPressed: () async{
                  Navigator.of(context).pop();
                  await deleteRecord();
                
                },
              ),
            
              TextButton(
                child: Text('No'),
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
      if(_licPaymentObject.attachment != 'null') {
        String path = firebaseStorage
            .ref()
            .child('files')
            .child(widget.licPaymentObject.attachment)
            .fullPath;
        await firebaseStorage.ref().child(path).delete().then((_) =>
            print("Done Task"));
      }
      await dbf
          .child('complinces')
          .child('LICPayment')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .remove();
      
      recordDeletedToast();
      Navigator.pop(context);
      Navigator.pop(context);
//      Navigator.push(context,
//        MaterialPageRoute(
//          builder: (context)=>ComplianceHistoryForLIC(
//            client: widget.client,
//          )
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
                          .child(widget.licPaymentObject.attachment)
                          .fullPath;
                      firebaseStorage = FirebaseStorage.instance;
                      await firebaseStorage.ref().child(path).delete();
                      print("here");
                      await fireUser();
                      dbf = firebaseDatabase.reference();
                      dbf
                          .child('complinces')
                          .child('LICPayment')
                          .child(firebaseUserId)
                          .child(widget.client.email)
                          .child(widget.keyDB)
                          .update({
                        'attachment': 'null',
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


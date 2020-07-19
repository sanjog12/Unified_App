import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/PPFRecordObject.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/validators.dart';

class PPFRecordHistoryDetailsView extends StatefulWidget {
  final Client client;
  final PPFRecordObject ppfRecordObject;
  final String keyDB;

  const PPFRecordHistoryDetailsView({
    this.client,
    this.ppfRecordObject,
    this.keyDB,
  });

  @override
  _PPFRecordHistoryDetailsViewState createState() =>
      _PPFRecordHistoryDetailsViewState();
}

class _PPFRecordHistoryDetailsViewState
    extends State<PPFRecordHistoryDetailsView> {
  
  bool edit = false;
  bool loadDelete = false;
  PPFRecordObject _ppfRecordObject;
  
  String firebaseUserId;
  String _selectedDateOfPayment = 'Select date';
  DateTime selectedDateOfPayment = DateTime.now();
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  fireUser() async{
    firebaseUserId = await SharedPrefs.getStringPreference("uid");
  }


  Future<void> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfPayment ,
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime(DateTime.now().year+1)
    );
  
    if(picked != null && picked != selectedDateOfPayment){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateOfPayment = picked;
        _selectedDateOfPayment = DateFormat('dd/MMMM/yyyy').format(picked);
        _ppfRecordObject.dateOfInvestment = _selectedDateOfPayment;
      });
    }
  }
  
  
  
  
  @override
  void initState() {
    super.initState();
    _ppfRecordObject = widget.ppfRecordObject;
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("PPF Record Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "${widget.client.name}\'s PPF Record Details",
                style: _theme.textTheme.headline.merge(
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
                      Text("Name Of Institution"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit ?TextFormField(
                        initialValue: widget.ppfRecordObject.nameOfInstitution,
                        decoration: buildCustomInput(
                            hintText: "Name Of Institution"),
                        validator: (value) =>
                            requiredField(value, 'Name Of Institution'),
                        onChanged: (value) =>
                        _ppfRecordObject.nameOfInstitution = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.ppfRecordObject.nameOfInstitution,
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
                      Text("Amount Of Payment"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.ppfRecordObject.amount,
                        decoration:
                        buildCustomInput(hintText: "Account Number"),
                        validator: (value) =>
                            requiredField(value, 'Account number'),
                        onChanged: (value) =>
                        _ppfRecordObject.accountNumber = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.ppfRecordObject.amount,
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
                      Text("Date of investment"),
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
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.ppfRecordObject.dateOfInvestment,
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
                      Text("Account number"),
                      SizedBox(
                        height: 10.0,
                      ),
                      edit?TextFormField(
                        initialValue: widget.ppfRecordObject.accountNumber,
                        decoration:
                        buildCustomInput(hintText: "Account Number"),
                        validator: (value) =>
                            requiredField(value, 'Account number'),
                        onChanged: (value) =>
                        _ppfRecordObject.accountNumber = value,
                      )
                          :Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.ppfRecordObject.accountNumber,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        decoration: roundedCornerButton,
                        child: edit
                            ?FlatButton(
                          child: Text("Save Changes"),
                          onPressed: () async{
                            await editRecord();
                            Navigator.pop(context);
                          },
                        )
                            :FlatButton(
                          
                          child: Text("Edit"),
                          onPressed: (){
                            setState(() {
                              edit = true;
                            });
                          },
                        ),
                      ),
  
                      SizedBox(
                        height: 10,
                      ),
  
                      Container(
                        decoration: roundedCornerButton,
                        child: FlatButton(
                          child: loadDelete
                              ?Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>
                                (Colors.white),
                            ),
                          )
                              :Text("Delete"),
                          onPressed: () async{
                            await showConfirmation(context);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
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
    print(_ppfRecordObject.nameOfInstitution);
    try{
      dbf
          .child('complinces')
          .child('PPFRecord')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .update({
        'nameOfInstitution': _ppfRecordObject.nameOfInstitution,
        'accountNumber': _ppfRecordObject.accountNumber,
        'amount': _ppfRecordObject.amount,
        'dateOfInvestment': _ppfRecordObject.dateOfInvestment
         });
    
      Fluttertoast.showToast(
          msg: "Changes Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    
    }on PlatformException catch(e){
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    }catch(e){
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  
  
  Future<void> showConfirmation(BuildContext context) async{
    loadDelete = true;
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
              FlatButton(
                child: Text('Confirm'),
                onPressed: () async{
                  await deleteRecord();
                  Navigator.of(context).pop();
                },
              ),
            
              FlatButton(
                child: Text('Edit'),
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
    print(firebaseUserId);
    print(widget.client.email);
    print(widget.keyDB);
    try {
      await dbf
          .child('complinces')
          .child('PPFRecord')
          .child(firebaseUserId)
          .child(widget.client.email)
          .child(widget.keyDB)
          .remove();
    
      Fluttertoast.showToast(
          msg: "Record Deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    
    }on PlatformException catch(e){
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    }catch(e){
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

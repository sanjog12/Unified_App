
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForROC.dart';
import 'package:unified_reminder/models/payment/ROCFormFilling.dart';
import 'package:unified_reminder/screens/ROC/HistoryDetailsView.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';

class HistoryForROC extends StatefulWidget {
  final Client client;
  final String stringDateAGM;

  const HistoryForROC({this.client,this.stringDateAGM});
  @override
  _HistoryForROCState createState() => _HistoryForROCState();
}



class _HistoryForROCState extends State<HistoryForROC> {
  
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dfb;
  
  @override
  Widget build(BuildContext context) {
    print(widget.client.name);
    print(widget.stringDateAGM);
    return Scaffold(
      appBar: AppBar(
        title: Text("History of ROC"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<HistoryCompliancesObjectForROC>>(
                future: HistoriesDatabaseHelper()
                    .getHistoryOfROF(widget.client,widget.stringDateAGM),
                builder: (BuildContext context,
                    AsyncSnapshot<List<HistoryCompliancesObjectForROC>> snapshot) {
                  
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(widget.stringDateAGM);
                        return Container(
                          decoration: roundedCornerButton,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
//                          color: buttonColor,
                          child: ListTile(
                            title: Column(
                              children: <Widget>[
                                SizedBox(height: 5,),
                                Text(snapshot.data[index].formType != null ?snapshot.data[index].formType: 'error 2',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Divider(thickness: 2.5),
                              ],
                            ),
                            
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(height: 10,),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text("SRN Number : "),
                                    SizedBox(width: 5,),
                                    Text(snapshot.data[index].SRNNumber != null ? snapshot.data[index].SRNNumber : "error 1",),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Date : "),
                                    SizedBox(width: 5,),
                                    Text(snapshot.data[index].dateOfFilling != null ? snapshot.data[index].dateOfFilling : "error3"),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text("Long press to edit Info",style: TextStyle(fontSize: 10,fontStyle: FontStyle.italic),textAlign: TextAlign.end),
                              ],
                            ),
                            
                            trailing: snapshot.data[index].SRNNumber != 'No History Found'?GestureDetector(
                                child: Icon(Icons.delete),
                              onTap: () async{
                                  await deleteRecord(snapshot.data[index].formType);
                              },
                            ):Container(),
                            
                            onLongPress: () async{
                              await editRecord(snapshot.data[index].formType, snapshot.data[index].SRNNumber, snapshot.data[index].dateOfFilling);
                            },
                          ),
                        );
                      },
                    );
                  }
                  else
                    return Container(
                      height: 30.0,
                      width: 30.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                      ),
                    );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  
  
  Future<void> getHistoryDetails(String key) async {
    if (key.isNotEmpty) {
      ROCFormSubmission rocFormSubmission = ROCFormSubmission();

      rocFormSubmission = await SingleHistoryDatabaseHelper()
          .getROCHistoryDetails(widget.client, key);

      if (rocFormSubmission != null) {
//        print(rocFormSubmission.SRNNumber);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ROCRecordHistoryDetailsView(
              client: widget.client,
              rocFormSubmission: rocFormSubmission,
            ),
          ),
        );
      }
    }
  }
  
  
  Future<void> deleteRecord(String key) async{
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10,),
                
                  Text("Sure You want to delete $key details?"),
                ],
              ),
            ),
          
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () async{
                  String firebaseUserId= await SharedPrefs.getStringPreference("uid");
                  dfb = firebaseDatabase.reference();
                  await dfb.child('complinces')
                      .child('ROC')
                      .child(firebaseUserId)
                      .child(widget.client.email.replaceAll('.', ','))
                      .child(widget.stringDateAGM)
                      .child(key)
                      .remove();
                  
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: 'Deleted Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Color(0xff666666),
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
              ),
            
              FlatButton(
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
  
  
  Future<void> editRecord(String key, String srnNo , String dateOfFiling) async{

    showDialog<void>(
        context: context,
        builder: (builder){
          return AlertDialog(
            title: Column(
              children: <Widget>[
                Text('Edit Data',style: TextStyle(fontWeight: FontWeight.bold),),
                Divider(
                  thickness: 1.0,
                ),
              ],
            ),
          
            content: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("SRN No."),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: srnNo,
                        decoration: buildCustomInput(hintText: 'SRN no.'),
                        onChanged: (value){
                          setState(() {
                            srnNo = value;
                          });
                        
                        },
                      ),
                    
                      SizedBox(height: 20,),
                    
                      Text("Date Of Filling"),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: dateOfFiling,
                        decoration: buildCustomInput(hintText: 'Date of Filing'),
                        onChanged: (value){
                          setState(() {
                            dateOfFiling = value;
                          });
                        },
                      ),
                    
                      SizedBox(height: 20,),
                    ],
                  )
              ),
            ),
          
            actions: <Widget>[
              FlatButton(
                child: Text('Save AGM Date'),
                onPressed: () async{
                  String firebaseUserId= await SharedPrefs.getStringPreference("uid");
                  dfb = firebaseDatabase.reference();
                  await dfb.child('complinces')
                      .child('ROC')
                      .child(firebaseUserId)
                      .child(widget.client.email.replaceAll('.', ','))
                      .child(widget.stringDateAGM)
                      .child(key)
                      .update({
                    'SRN No': srnNo,
                    'Date of Filing': dateOfFiling,
                  });
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: 'Successfully Updated',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Color(0xff666666),
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
              )
            ],
          );
        }
    );
  }
  
  
}
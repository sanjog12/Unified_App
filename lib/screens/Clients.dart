import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/AddSingleClient.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class Clients extends StatefulWidget {
  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  StreamController _userController;

  loadUser() async {
    FirestoreService().getClients(firebaseUserId).then((res) async {
      _userController.add(res);
      return res;
    });
  }

  //  String userFirebaseId = SharedPrefs.getStringPreference("uid");
  String firebaseUserId;

  @override
  void initState() {
    super.initState();
    getUserId();
    _userController = new StreamController();
    Timer.periodic(Duration(seconds: 1), (_) => loadUser());
  }

  void getUserId() async {
    var _firebaseUserId = await SharedPrefs.getStringPreference("uid");
    this.setState(() {
      firebaseUserId = _firebaseUserId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clients"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSingleClient(),
            ),
          );
        },
        
        backgroundColor: textboxColor,
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Clients",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: _userController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xff7C7C7C),
                                      ),
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].name,
                                          style: TextStyle(color: whiteColor),
                                        ),
                                        SizedBox(width: 90,),
                                        GestureDetector(child: Icon(Icons.edit),onTap: (){
                                          showDetails(context,snapshot.data[index],false);
                                        },),
                                        GestureDetector(child: Icon(Icons.delete,color: Colors.red,),onTap: () async{
                                          bool confirm = false;
                                          confirm = await showConfirmationDialog(context);
                                          if(confirm){
                                            deleteClient(snapshot.data[index].key,snapshot.data[index].email);
                                          }
                                        },),
                                      ],
                                    ),
                                    onTap: (){
                                      showDetails(context,snapshot.data[index],true);
                                    },
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showDetails(BuildContext context,details,bool edit) async{
    Client clientEdit = details;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Column(
              children: <Widget>[
                Text("Details"),
                Divider(thickness: 1.0,)
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Name:-"),
                      edit?Text('${details.name}',style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),):Container(
                        width: 100,
                        child: TextFormField(
                          initialValue: details.name,
                          onChanged: (value){
                            clientEdit.name = value;
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Phone:-"),
                      edit?Text('${details.phone}',style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),):Container(
                        width: 100,
                        child: TextFormField(
                          initialValue: details.phone,
                          onChanged: (value){
                            clientEdit.phone = value;
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Email:-"),
                      edit?Text('${details.email}',style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),):Container(
                        width: 100,
                        child: TextFormField(
                          initialValue: details.email,
                          onChanged: (value){
                            clientEdit.email = value;
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Company:-"),
                      edit?Text('${details.company}',style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),):Container(
                        width: 100,
                        child: TextFormField(
                          initialValue: details.company,
                          onChanged: (value){
                            clientEdit.company = value;
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Constitution:-"),
                      edit?Text('${details.constitution}',style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),):Container(
                        width: 100,
                        child: TextFormField(
                          initialValue: details.constitution,
                          onChanged: (value){
                            clientEdit.constitution = value;
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Nature Of Business:-"),
                      edit?Text('${details.natureOfBusiness}',style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),):Container(
                        width: 100,
                        child: TextFormField(
                          initialValue: details.natureOfBusiness,
                          onChanged: (value){
                            clientEdit.natureOfBusiness = value;
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(child: Text('Save',textAlign: TextAlign.center,),onPressed: () async{
                print(clientEdit.name);
                await FirestoreService().editClientData(clientEdit, firebaseUserId);
                recordEditToast();
                Navigator.pop(context);
              },)
            ],
          );
        }
    );
  }
  
  Future<void> deleteClient(String key,String email) async{
    dbf = firebaseDatabase.reference();
    try {
      await dbf
          .child(FsUserClients)
          .child(firebaseUserId)
          .child('clients')
          .child(key)
          .remove();
      dbf = firebaseDatabase.reference();
      await dbf.child("user_compliances")
            .child(firebaseUserId)
            .child('compliances')
            .child(email)
            .remove();
      recordDeletedToast();
      Navigator.pop(context);
    }catch(e){
      print(e);
    }
  }
}


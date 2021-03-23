import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/screens/AddSingleClient.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class Clients extends StatefulWidget {
  
  final UserBasic userBasic;

  const Clients({Key key, this.userBasic}) : super(key: key);
  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    Timer.periodic(Duration(seconds: 3), (_) => loadUser());
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
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
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
                                          Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context)=>AddSingleClient(
                                                client: snapshot.data[index],
                                                userBasic: widget.userBasic,
                                              )
                                            )
                                          );
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
                                      showDetails(context,snapshot.data[index]);
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
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
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

  Future<void> showDetails(BuildContext context,details) async{
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
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Name:-"),
                        Text('${details.name}',style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),overflow: TextOverflow.clip),
                      ],
                    ),
                    // SizedBox(height: 5,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Text("Phone:-"),
                    //     Text('${details.phone}',style: TextStyle(
                    //       fontStyle: FontStyle.italic,
                    //     ),)
                    //   ],
                    // ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Email:-"),
                        Text('${details.email}',style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),overflow: TextOverflow.clip)
                      ],
                    ),
                    // SizedBox(height: 5,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Text("Company:-"),
                    //     Text('${details.company}',style: TextStyle(
                    //       fontStyle: FontStyle.italic,
                    //     ),overflow: TextOverflow.clip)
                    //   ],
                    // ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Constitution:-"),
                        Text('${details.constitution}',style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),overflow: TextOverflow.clip)
                      ],
                    ),
                    // SizedBox(height: 5,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Text("Nature Of\n Business:-  "),
                    //     Text('${details.natureOfBusiness}',style: TextStyle(
                    //       fontStyle: FontStyle.italic,
                    //     ),overflow: TextOverflow.clip,)
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(child: Text('Ok',textAlign: TextAlign.center,),onPressed: () async{
                print(clientEdit.name);
                Navigator.pop(context);
              },)
            ],
          );
        }
    );
  }
  
  Future<void> deleteClient(String key,String email) async{
    try {
      try{
      dbf = firebaseDatabase.reference();
      await dbf
          .child(FsUserClients)
          .child(firebaseUserId)
          .child('clients')
          .child(key)
          .remove();
      } catch(e){
        print(e);
        flutterToast(message: "Something went wrong");
          }
      try {
        dbf = firebaseDatabase.reference();
        await dbf.child("user_compliances")
            .child(firebaseUserId)
            .child('compliances')
            .child(email)
            .remove();
      }catch(e){
        print(e);
        flutterToast(message: "Something went wrong try latter");
      }
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=>ShowCaseWidget(
            builder: Builder(
              builder: (context)=>Dashboard(),
            ),
          )
      ));
      recordDeletedToast();
    }catch(e){
      flutterToast(message: "Something went wrong try latter");
      print(e);
    }
  }
}


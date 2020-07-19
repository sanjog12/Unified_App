import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/screens/AddSingleClient.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';

class Clients extends StatefulWidget {
  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  final FirestoreService _firestoreService = FirestoreService();

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
//                              return SingeleMessage(snapshot.data[index]);
                              return GestureDetector(
                                onTap: () {},
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
//                                        GestureDetector(child: Icon(Icons.delete,color: Colors.red,),onTap: (){
//
//                                        },)
                                      ],
                                    ),
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
//                child: FutureBuilder<List<Client>>(
//                  future: FirestoreService().getClients(firebaseUserId),
//                  builder: (BuildContext context,
//                      AsyncSnapshot<List<Client>> snapshot) {
//                    if (snapshot.data == null) {
//                      return Center(
//                        child: Container(
//                          width: 50.0,
//                          height: 50.0,
//                          child: CircularProgressIndicator(),
//                        ),
//                      );
//                    } else {
//                      return Container(
//                        child: ListView.builder(
//                          itemCount: snapshot.data.length,
//                          scrollDirection: Axis.vertical,
//                          itemBuilder: (BuildContext context, int index) {
//                            return GestureDetector(
//                              onTap: () {},
//                              child: Container(
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                    bottom: BorderSide(
//                                      color: Color(0xff7C7C7C),
//                                    ),
//                                  ),
//                                ),
//                                margin: EdgeInsets.symmetric(vertical: 10.0),
//                                child: ListTile(
//                                  title: Text(
//                                    snapshot.data[index].name,
//                                    style: TextStyle(color: whiteColor),
//                                  ),
//                                ),
//                              ),
//                            );
//                          },
//                        ),
//                      );
//                    }
//                  },
//                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//              child: StreamBuilder(
//
//
////                  stream: FirestoreService().getClientsData(firebaseUserId),
//                  builder: dbf .once() .then(BuildContext context, snapshot) {
////                    print('hey Helloooooo${snapshot.data.toString()}');
//                    if (snapshot.hasData &&
//                        !snapshot.hasError &&
//                        snapshot.data.snapshot.value != null) {
//
////taking the data snapshot.
//                      DataSnapshot snapshot1 = snapshot.data.snapshot;
//                      List item = [];
//                      List _list = [];
////it gives all the documents in this list.
//                      _list = snapshot1.value;
////Now we're just checking if document is not null then add it to another list called "item".
////I faced this problem it works fine without null check until you remove a document and then your stream reads data including the removed one with a null value(if you have some better approach let me know).
//                      _list.forEach((f) {
//                        if (f != null) {
//                          item.add(f);
//                        }
//                      });
//                      return snapshot.data.snapshot.value == null
////return sizedbox if there's nothing in database.
//                          ? SizedBox()
////otherwise return a list of widgets.
//                          : ListView.builder(
//                              scrollDirection: Axis.horizontal,
//                              itemCount: item.length,
//                              itemBuilder: (context, index) {
//                                return Container();
//                              },
//                            );
//                    } else {
//                      return Center(child: CircularProgressIndicator());
////
////                    if (snapshot.hasData) {
////                      DataSnapshot snapshot1
////                      return ListView(
////                          children:
////                              snapshot.data["clients"].map<Widget>((client) {
////                        return GestureDetector(
////                          onTap: () {
//////                    print(client.toString());
//////                    Navigator.of(context).pushNamed(
//////                        getRoute(widget.arguments["path"]),
//////                        arguments: {"client": client});
//////                              OpenScreen(widget.arguments['path'], client);
////                          },
////                          child: Container(
////                            decoration: BoxDecoration(
////                              border: Border(
////                                bottom: BorderSide(
////                                  color: Color(0xff7C7C7C),
////                                ),
////                              ),
////                            ),
////                            margin: EdgeInsets.symmetric(vertical: 10.0),
////                            child: ListTile(
////                              title: Text(client["name"]),
////                            ),
////                          ),
////                        );
////                      }).toList());
////                    } else
////                      return Center(
////                        child: Container(
////                          width: 50.0,
////                          height: 50.0,
////                          child: CircularProgressIndicator(),
////                        ),
////                      );
//                    }
////                builder: (BuildContext context, snapshot) {
////                  if (snapshot.hasData) {
////                    print(snapshot.data.toString());
////
//////                    return ListView(
//////                        children:
//////                            snapshot.data["clients"].map<Widget>((client) {
//////                      return GestureDetector(
//////                        onTap: () {
////////                    print(client.toString());
////////                    Navigator.of(context).pushNamed(
////////                        getRoute(widget.arguments["path"]),
////////                        arguments: {"client": client});
////////                              OpenScreen(widget.arguments['path'], client);
//////                        },
//////                        child: Container(
//////                          decoration: BoxDecoration(
//////                            border: Border(
//////                              bottom: BorderSide(
//////                                color: Color(0xff7C7C7C),
//////                              ),
//////                            ),
//////                          ),
//////                          margin: EdgeInsets.symmetric(vertical: 10.0),
//////                          child: ListTile(
//////                            title: Text(client["name"]),
//////                          ),
//////                        ),
//////                      );
//////                    }).toList());
////                  } else if (snapshot.error) {
////                    return Center(
////                      child: Container(
////                        width: 50.0,
////                        height: 50.0,
////                        child: CircularProgressIndicator(),
////                      ),
////                    );
////                  }
////                },
//                  }),


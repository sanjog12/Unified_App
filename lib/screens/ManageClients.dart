import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/screens/GSTScreen.dart';
import 'package:unified_reminder/screens/IncomeTaxScreen.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';

import 'TDSScreen.dart';

class ManageClients extends StatefulWidget {
  final Compliance compliance;

  ManageClients({this.compliance});

  @override
  _ManageClientsState createState() => _ManageClientsState();
}

class _ManageClientsState extends State<ManageClients> {
  final FirestoreService _firestoreService = FirestoreService();
//  String userFirebaseId = SharedPrefs.getStringPreference("uid");
  String firebaseUserId;
  @override
  void initState() {
    super.initState();
    getUserId();
//    print(widget.arguments.toString());
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
        title: Text("Manage Clients"),
      ),
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: FutureBuilder<List<Client>>(
          future: _firestoreService.getClients(firebaseUserId),
          builder:
              (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    children: List.generate(
                      snapshot.data.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            OpenScreen(
                                widget.compliance.value, snapshot.data[index]);
//                    Navigator.of(context).pushNamed(getRoute(arguments["path"]),
//                        arguments: {"client": client});
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
                              title: Text(snapshot.data[index].name),
                            ),
                          ),
                        );
                      },

//                          children: getGrids(snapshot.data["compliances"]
//                          [widget.client["client"]["email"]]),
                    ),
                  ));
//              return ListView(
//                  children: snapshot.data["clients"].map<Widget>((client) {
//                return GestureDetector(
//                  onTap: () {
//                    OpenScreen(path, client)
////                    Navigator.of(context).pushNamed(getRoute(arguments["path"]),
////                        arguments: {"client": client});
//                  },
//                  child: Container(
//                    decoration: BoxDecoration(
//                      border: Border(
//                        bottom: BorderSide(
//                          color: Color(0xff7C7C7C),
//                        ),
//                      ),
//                    ),
//                    margin: EdgeInsets.symmetric(vertical: 10.0),
//                    child: ListTile(
//                      title: Text(client["name"]),
//                    ),
//                  ),
//                );
//              }).toList());
            } else
              return Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                ),
              );
          },
        ),
//        child: StreamBuilder(
//          stream: _firestoreService.getClients(firebaseUserId),
//          builder: (BuildContext context, snapshot) {
//            if (snapshot.hasData) {
//              return ListView(
//                  children: snapshot.data["clients"].map<Widget>((client) {
//                return GestureDetector(
//                  onTap: () {
////                    print(client.toString());
////                    Navigator.of(context).pushNamed(
////                        getRoute(widget.arguments["path"]),
////                        arguments: {"client": client});
//                    OpenScreen(widget.arguments['path'], client);
//                  },
//                  child: Container(
//                    decoration: BoxDecoration(
//                      border: Border(
//                        bottom: BorderSide(
//                          color: Color(0xff7C7C7C),
//                        ),
//                      ),
//                    ),
//                    margin: EdgeInsets.symmetric(vertical: 10.0),
//                    child: ListTile(
//                      title: Text(client["name"]),
//                    ),
//                  ),
//                );
//              }).toList());
//            }
//            return Center(
//              child: Container(
//                width: 50.0,
//                height: 50.0,
//                child: CircularProgressIndicator(),
//              ),
//            );
//          },
//        ),
      ),
    );
  }

  void OpenScreen(String path, var client) {
    print(path);
    switch (path) {
//      case 'income_tax':
////        print("Going here");
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => IncomeTaskScreen(
//              arguments: {"client": client},
//            ),
//          ),
//        );
//        break;
//      case 'gst':
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => GSTScreen(
//              arguments: {"client": client},
//            ),
//          ),
//        );
//        break;
      case 'esi':
        break;
      case 'tds':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TDSScreen(
              client: client,
            ),
          ),
        );
        break;
//      default:
//        return SetupGSTRoute;
    }
  }
//
//  String getRoute(String path) {
////    print("The path is $path");
//    switch (path) {
//      case 'income_tax':
//        print("Going here");
//        return IncomeTaskScreenRoute;
//      case 'gst':
//        return GSTScreenRoute;
//      case 'esi':
//        return ESIScreenRoute;
//      case 'tds':
//        return TDSScreenRoute;
////      default:
////        return SetupGSTRoute;
//    }
//  }
}
//
//class ManageClients extends StatelessWidget {
//
//}

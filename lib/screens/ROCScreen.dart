import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/ROC/Payment.dart';
import 'package:unified_reminder/screens/ROC/UpComingCompliancesScreen.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';

import '../router.dart';
import 'ROC/History.dart';

class ROCScreen extends StatefulWidget {
  final Client client;

  const ROCScreen({this.client});
  @override
  _ROCScreenState createState() => _ROCScreenState();
}

class _ROCScreenState extends State<ROCScreen> {
  
  
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dfb;
  
  String stringDateAGM =' ';
  bool agmRecorded = false;
  
  
  
  @override
  void initState() {
    super.initState();
    agmDate();
  }
  
  Future<void> agmDate() async{
    String firebaseUserId= await SharedPrefs.getStringPreference("uid");
    
    try{
      dfb = firebaseDatabase.reference()
          .child('complinces')
          .child('ROC')
          .child(firebaseUserId)
          .child(widget.client.email.replaceAll('.', ','));
      print('1');
      await dfb.once().then((DataSnapshot snapshot){
        print('2');
        Map<dynamic,dynamic> values = snapshot.value;
        print('3');
        stringDateAGM = values.keys.first.toString();
      });
      print('4');
      setState(() {
        agmRecorded = true;
      });
    }
    catch(e){
      print('error');
      setState(() {
        agmRecorded = true;
      });
    }
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ROC for ${widget.client.name}"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: agmRecorded? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "ROC for ${widget.client.name}",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15.0,
                childAspectRatio: 1.2,
                crossAxisSpacing: 15.0,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HistoryForROC(
                            client: widget.client,
                            stringDateAGM: stringDateAGM,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonColor,
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.av_timer,
                            size: 48.0,
                          ),
                          FittedBox(
                            child: Text(
                              "History of Compliances",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UpComingCompliancesScreenForROC(
                          client: widget.client,
                              agmRecorded: stringDateAGM == ' '? false : true,
                            stringAGMDate: stringDateAGM,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonColor,
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.av_timer,
                            size: 48.0,
                          ),
                          FittedBox(
                            child: Text(
                              "Upcoming Compliances",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  
                  
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(
//                        MaterialPageRoute(
//                          builder: (context) => ROCPayment(
//                            client: widget.client,
//                          ),
//                        ),
//                      );
//                    },
//                    child: Container(
//                      decoration: BoxDecoration(
//                        color: buttonColor,
//                      ),
//                      padding: EdgeInsets.all(12.0),
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Icon(
//                            Icons.av_timer,
//                            size: 48.0,
//                          ),
//                          FittedBox(
//                            child: Text(
//                              "Payment",
//                              textAlign: TextAlign.center,
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
                ],
              ),
            )
          ],
        ) : Container(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>
                      (Colors.white70),
                  ),
                ),
                
                SizedBox(height: 10),
                
                Text('Fetching Data',textAlign: TextAlign.center,)
              ],
            ),
          ),
        )
      ),
    );
  }
}

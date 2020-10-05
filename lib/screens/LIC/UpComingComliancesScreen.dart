import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/TodayDateObject.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/doneComplianceObject.dart';
import 'package:unified_reminder/screens/LIC/Payment.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';

class UpComingCompliancesScreenForLIC extends StatefulWidget {
  final Client client;

  const UpComingCompliancesScreenForLIC({this.client});
  

  @override
  _UpComingCompliancesScreenForLICState createState() =>
      _UpComingCompliancesScreenForLICState();
}

class _UpComingCompliancesScreenForLICState
    extends State<UpComingCompliancesScreenForLIC> {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  static DateTime now = new DateTime.now();
  static DateTime date = new DateTime(now.year, now.month, now.day);

  static List<String> dateData = date.toString().split(' ');

  static String fullDate = dateData[0];
  List<String> todayDateData = fullDate.toString().split('-');
  TodayDateObject todayDateObject;

  
  
  Future<List<UpComingComplianceObject>> _getUpComings() async {
    todayDateObject = TodayDateObject(
      
        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
    List<UpComingComplianceObject> compliancesForListView = [];
    List<UpComingComplianceObject> compliances =
        await UpComingComplianceDatabaseHelper()
            .getUpComingCompliancesForMonthOfLIC(widget.client);

    String clientEmail = widget.client.email.replaceAll('.', ',');

    List<doneComplianceObject> clientDones =
        await UpComingComplianceDatabaseHelper()
            .getClientDoneCompliances(clientEmail, todayDateObject, 'LIC');

    compliances.forEach((element) {
      if (getSingleDone(clientDones, element.key)) {
        compliancesForListView.add(element);
      }
    });
    if (compliancesForListView.length <= 0) {
      UpComingComplianceObject upComingComplianceObject =
          UpComingComplianceObject(
              key: 'nothing',
              date: ' ',
              label: 'No TDS Compliance in this month');

      compliancesForListView.add(upComingComplianceObject);
    }
    return compliancesForListView;
  }

  bool getSingleDone(List<doneComplianceObject> dones, String subkey) {
    print(dones[0].key);
    if (dones[0].key != null) {
      doneComplianceObject singleDone;
      dones.forEach((element) {
        print(element.key);
//      String oo = element.key.replaceAll(' ', '');
////      print(oo);
        if (subkey == element.key) {
          singleDone = element;
//          print(element.key);
        }
      });

      if (singleDone != null && singleDone.value == 'done') {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LIC Upcoming Premium Date"),
        actions: <Widget>[
          helpButtonActionBar('https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20LIC'),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 24.0, right: 24, left: 24, bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<UpComingComplianceObject>>(
                future: UpComingComplianceDatabaseHelper().getUpComingCompliancesForMonthOfLIC(widget.client),
                builder: (BuildContext context,
                    AsyncSnapshot<List<UpComingComplianceObject>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(snapshot.data);
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LICPayment(
                                  client: widget.client,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: roundedCornerButton,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: ListTile(
                              title: Text(
                                  '${snapshot.data[index].label} for ${snapshot.data[index].name} '
                                      '${snapshot.data[index].date} ${snapshot.data[index].date != ''?DateFormat('MMMM').format(DateTime.now()):''}'),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
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
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

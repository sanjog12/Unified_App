import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/TodayDateObject.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/DoneComplianceObject.dart';
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

  
  

  bool getSingleDone(List<DoneComplianceObject> done, String subKey) {
    print(done[0].key);
    if (done[0].key != null) {
      DoneComplianceObject singleDone;
      done.forEach((element) {
        print(element.key);
        if (subKey == element.key) {
          singleDone = element;
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
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<UpComingComplianceObject>>(
                future: UpComingComplianceDatabaseHelper().getUpComingCompliancesForMonthOfLIC(widget.client),
                builder: (BuildContext context, AsyncSnapshot<List<UpComingComplianceObject>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(snapshot.data);
                        return GestureDetector(
                          onTap: () {
                          },
                          child: Column(
                            children: [
                              snapshot.data[index].notMissed?Container(
                                decoration: roundedCornerButton,
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                  title: Text(
                                      '${snapshot.data[index].label} for ${snapshot.data[index].name} '
                                          '${snapshot.data[index].date} ${snapshot.data[index].date != ''?DateFormat('MMMM').format(DateTime.now()):''}'),
                                ),
                              ):Container(),
  
                              !snapshot.data[index].notMissed?Container(
                                decoration: roundedCornerButton.copyWith(color: Colors.redAccent),
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                  title: Text(
                                      '${snapshot.data[index].label} for ${snapshot.data[index].name} '
                                          '${snapshot.data[index].date} ${snapshot.data[index].date != ''?DateFormat('MMMM').format(DateTime.now()):''}'),
                                  subtitle: Text("Missed Compliances"),
                                ),
                              ):Container(),
                            ],
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
            ),
            SizedBox(height: 70,),
          ],
        ),
      ),
    );
  }
}

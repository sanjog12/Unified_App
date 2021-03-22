import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/TodayDateObject.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/IncomeTax/Payment.dart';
import 'package:unified_reminder/screens/IncomeTax/ReturnFilling.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';

class UpComingComliancesScreenForIncomeTax extends StatefulWidget {
  final Client client;

  const UpComingComliancesScreenForIncomeTax({this.client});

  @override
  _UpComingComliancesScreenForIncomeTaxState createState() =>
      _UpComingComliancesScreenForIncomeTaxState();
}

class _UpComingComliancesScreenForIncomeTaxState
    extends State<UpComingComliancesScreenForIncomeTax> {
  static DateTime now = new DateTime.now();
  static DateTime date = new DateTime(now.year, now.month, now.day);

  static List<String> dateData = date.toString().split(' ');

  static String fullDate = dateData[0];
  List<String> todayDateData = fullDate.toString().split('-');
  TodayDateObject todayDateObject;

//  Future<List<UpComingComplianceObject>> _getUpComings() async {
//    todayDateObject = TodayDateObject(
//        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
//
//    List<UpComingComplianceObject> compliancesForListView = [];
//
//    List<UpComingComplianceObject> compliances =
//        await UpComingComplianceDatabaseHelper()
//            .getUpComingComplincesForMonthOfIncomeTax(widget.client);
//
//    String clientEmail = widget.client.email.replaceAll('.', ',');
//
//    List<doneComplianceObject> clientDones =
//        await UpComingComplianceDatabaseHelper().getClientDoneCompliances(
//            clientEmail, todayDateObject, 'INCOME_TAX');
//
//    compliances.forEach((element) {
//      bool done = getSingleDone(clientDones, element.key);
//      print(done);
//
//      if (done) {
//        compliancesForListView.add(element);
//      }
//    });
//    print('6');
//
//    if (compliancesForListView.length <= 0) {
//      UpComingComplianceObject upComingComplianceObject =
//          UpComingComplianceObject(
//              key: 'nothing',
//              date: ' ',
//              label: 'No Income Tax Compliance in this month');
//
//      compliancesForListView.add(upComingComplianceObject);
//    }
//    return compliancesForListView;
//  }
//
//  bool getSingleDone(List<doneComplianceObject> dones, String subkey) {
//    if (dones[0].key != null) {
//      doneComplianceObject singleDone;
//      dones.forEach((element) {
//        print(element.key);
//        if (subkey == element.key) {
//          singleDone = element;
//        }
//      });
//
//      if (singleDone != null && singleDone.value == 'done') {
//        return false;
//      }
//    }
//    return true;
//  }

  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Income Tax Upcoming Compliances"),
        actions: <Widget>[
          helpButtonActionBar("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20Incometax"),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<UpComingComplianceObject>>(
                future: UpComingComplianceDatabaseHelper()
                    .getUpComingComplincesForMonthOfIncomeTax(widget.client),
                builder: (BuildContext context,
                    AsyncSnapshot<List<UpComingComplianceObject>> snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data.length ==0){
                      return ListView(
                        children: <Widget>[
                          Container(
                            decoration: roundedCornerButton,
                            child: ListTile(
                              title: Text("No Upcoming Compliances"),
                            ),
                          )
                        ],
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(snapshot.data);
                        return GestureDetector(
                          onTap: () {
                            if (snapshot.data[index].key !=
                                'INCOME_TAX_RETURNS') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IncomeTaxPayment(
                                    client: widget.client,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IncomeTaxReturnFilling(
                                    client: widget.client,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: roundedCornerButton,
                            child: ListTile(
                              title: Text(snapshot.data[index].date != ' '?
                                  '${snapshot.data[index].label} due on ${snapshot.data[index].date} ${DateFormat('MMMM').format(DateTime.now())}'
                                :'${snapshot.data[index].label}',
                              ),
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
            ),
            SizedBox(height: 70,),
          ],
        ),
      ),
    );
  }
}

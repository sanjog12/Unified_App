import 'package:flutter/material.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/payment/EPFMonthlyContributionObejct.dart';
import 'package:unified_reminder/models/quarterlyReturns/EPFDetailsOfContributionObject.dart';
import 'package:unified_reminder/screens/EPF/HistoryDetailedViewDOC.dart';
import 'package:unified_reminder/screens/EPF/HistoryDetailsView.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';

class ComplianceHistoryForEPF extends StatefulWidget {
  final Client client;

  const ComplianceHistoryForEPF({this.client});
  @override
  _ComplianceHistoryForEPFState createState() =>
      _ComplianceHistoryForEPFState();
}



class _ComplianceHistoryForEPFState extends State<ComplianceHistoryForEPF> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EPF History"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<HistoryComplinceObject>>(
                future: HistoriesDatabaseHelper()
                    .getCompliancesHistoryOfEPF(widget.client),
                builder: (BuildContext context, AsyncSnapshot<List<HistoryComplinceObject>> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.first.date);
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                          onPressed: () {
                            if(snapshot.data[index].type == 'Monthly Contribution') {
                              _getHistoryDetails(snapshot.data[index].key);
                            }
                            else if(snapshot.data[index].type == 'Details of Contribution'){
                              _getHistoryDetails2(snapshot.data[index].key);
                            }
                          },
                          child: Container(
                            decoration: roundedCornerButton,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: ListTile(
                              title: Text(snapshot.data[index].date),
                              subtitle: Text(snapshot.data[index].type),
                              trailing:
                              snapshot.data[index].amount != ''?Text("INR ${snapshot.data[index].amount}"):Text(" "),
                            ),
                          ),
                        );
                      },
                    );
                  } else
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
            ),
            SizedBox(height: 70,),
          ],
        ),
      ),
    );
  }

  Future<void> _getHistoryDetails(String key) async {
    if (key != null) {
      EPFMonthlyContributionObject epfMonthlyContributionObejct =
          EPFMonthlyContributionObject();

      epfMonthlyContributionObejct = await SingleHistoryDatabaseHelper()
          .getEPFHistoryDetails(widget.client, key);

      if (epfMonthlyContributionObejct != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EPFRecordHistoryDetailsView(
              client: widget.client,
              epfMonthlyContributionObejct: epfMonthlyContributionObejct,
              keyDB: key,
            ),
          ),
        ).whenComplete((){setState(() {});});
      }
    }
  }

  Future<void> _getHistoryDetails2(String key) async {
    if (key != null) {
      EPFDetailsOfContributionObject epfDetailsOfContributionObject =
      EPFDetailsOfContributionObject();
    
      epfDetailsOfContributionObject = await SingleHistoryDatabaseHelper()
          .getEPFDetailedOfContributionHistoryDetails(widget.client, key);
    
      if ( epfDetailsOfContributionObject != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EPFRecordHistoryDetailsView2(
              client: widget.client,
              epfDetailsOfContributionObject: epfDetailsOfContributionObject,
              keyDB: key,
            ),
          ),
        ).whenComplete((){setState(() {});});
      }
    }
  }
  
}

import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/payment/FDRecordObject.dart';
import 'package:unified_reminder/screens/FD/HistoryDetailsView.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';

class HistoryForFD extends StatefulWidget {
  final Client client;

  const HistoryForFD({this.client});
  @override
  _HistoryForFDState createState() => _HistoryForFDState();
}

class _HistoryForFDState extends State<HistoryForFD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History of Fixed Deposit"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<HistoryComplinceObject>>(
                future: HistoriesDatabaseHelper()
                    .getHistoryOfFDRecord(widget.client),
                builder: (BuildContext context,
                    AsyncSnapshot<List<HistoryComplinceObject>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FlatButton(
                          onPressed: () =>
                              _getHistoryDetails(snapshot.data[index].key),
                          child: Container(
                            decoration: roundedCornerButton,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: ListTile(
                              title: Text(snapshot.data[index].date != null ?snapshot.data[index].date :"No Record Till Now"),
                              subtitle: Text(snapshot.data[index].type != null ? snapshot.data[index].type  : ""),
                              trailing:
                                  Text(snapshot.data[index].amount != "null" ?"INR ${snapshot.data[index].amount}":" "),
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
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getHistoryDetails(String key) async {
    if (key != null) {
      FDRecordObject fdRecordObject = FDRecordObject();

      fdRecordObject = await SingleHistoryDatabaseHelper()
          .getFDHistoryDetails(widget.client, key);
      print(fdRecordObject.nomineeName);
      print(fdRecordObject.dateOfInvestment);
      print(fdRecordObject.secondHolderName);
      print(fdRecordObject.principalAmount);
      print(fdRecordObject.rateOfInterest);
      print(fdRecordObject.termOfInvestment);
      print(fdRecordObject.maturityAmount);
      print(fdRecordObject.fixedDepositNo);
      if (fdRecordObject != null) {
//      print(epfDetailsOfContributionObject.challanNumber);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FDPaymentRecordHistoryDetailsView(
              client: widget.client,
              fdRecordObject: fdRecordObject,
              keyDB: key,
            ),
          ),
        );
      }
    }
  }
}

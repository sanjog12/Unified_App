import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/payment/PPFRecordObject.dart';
import 'package:unified_reminder/screens/PPF/HistoryDetailsView.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';

class HistoryForPPF extends StatefulWidget {
  final Client client;

  const HistoryForPPF({this.client});
  @override
  _HistoryForPPFState createState() => _HistoryForPPFState();
}

class _HistoryForPPFState extends State<HistoryForPPF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History of PPF"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<HistoryComplinceObject>>(
                future: HistoriesDatabaseHelper()
                    .getHistoryOfPPFRecord(widget.client),
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
                              title: Text(snapshot.data[index].date),
                              subtitle: Text(snapshot.data[index].type),
                              trailing:
                                  Text(snapshot.data[index].amount != "null"?"INR ${snapshot.data[index].amount}":" "),
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
      PPFRecordObject ppfRecordObject = PPFRecordObject();

      ppfRecordObject = await SingleHistoryDatabaseHelper()
          .getPPFHistoryDetails(widget.client, key);

      if (ppfRecordObject != null) {
//      print(ppfRecordObject.accountNumber);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PPFRecordHistoryDetailsView(
              client: widget.client,
              ppfRecordObject: ppfRecordObject,
              keyDB: key,
            ),
          ),
        );
      }
    }
  }
}

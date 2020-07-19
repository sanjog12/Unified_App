import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForIncomeTax.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/styles/colors.dart';

class ComplianceHistory extends StatefulWidget {
  final Client client;

  const ComplianceHistory({this.client});
  @override
  _ComplianceHistoryState createState() => _ComplianceHistoryState();
}

class _ComplianceHistoryState extends State<ComplianceHistory> {
  @override
  void initState() {
    HistoriesDatabaseHelper().getComplincesHistoryOfIncomeTax(widget.client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History of Compliances"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<HistoryComplinceObjectForIncomeTax>>(
                future: HistoriesDatabaseHelper()
                    .getComplincesHistoryOfIncomeTax(widget.client),
                builder: (BuildContext context,
                    AsyncSnapshot<List<HistoryComplinceObjectForIncomeTax>>
                        snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          color: buttonColor,
                          child: ListTile(
                            title: Text(snapshot.data[index].date),
                            subtitle: Text(snapshot.data[index].type),
                            trailing:
                                Text("INR ${snapshot.data[index].amount}"),
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
}

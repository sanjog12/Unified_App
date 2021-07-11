import 'package:flutter/material.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/payment/LICPaymentIObject.dart';
import 'package:unified_reminder/screens/LIC/SinglePortfolioDetail.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';

class AddedPortfolios extends StatefulWidget {
  final Client client;

  const AddedPortfolios({this.client});

  @override
  _ComplianceHistoryForTDSState createState() =>
      _ComplianceHistoryForTDSState();
}

class _ComplianceHistoryForTDSState extends State<AddedPortfolios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LIC Portfolios"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<HistoryComplinceObject>>(
                future: HistoriesDatabaseHelper()
                    .getHistoryOfLICPayment(widget.client),
                builder: (BuildContext context,
                    AsyncSnapshot<List<HistoryComplinceObject>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                          onPressed: () {
                            if (snapshot.data[index].date !=
                                'No history founded') {
                              _getHistoryDetails(snapshot.data[index].key);
                            }
                          },
                          child: Container(
                            decoration: roundedCornerButton,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: ListTile(
                              title: Text(snapshot.data[index].date),
                              subtitle: Text(snapshot.data[index].type),
                              trailing: Text(
                                  "\u{20B9} ${snapshot.data[index].amount}" ??
                                      ""),
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
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getHistoryDetails(String key) async {
    if (key != null) {
      LICPaymentObject licPaymentObject = LICPaymentObject();

      licPaymentObject = await SingleHistoryDatabaseHelper()
          .getLICHistoryDetails(widget.client, key);

      if (licPaymentObject != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SinglePortfolioView(
              client: widget.client,
              licPaymentObject: licPaymentObject,
              keyDB: key,
            ),
          ),
        ).then((value) {
          setState(() {});
        });
      }
    }
  }
}

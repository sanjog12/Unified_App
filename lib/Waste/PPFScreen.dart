import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/screens/ComplianceHistory.dart';
//import 'package:unified_reminder/screens/TDS/ComplianceHistoryForTDS.dart';
//import 'package:unified_reminder/screens/TDS/Payment.dart';
//import 'package:unified_reminder/screens/TDS/QuarterlyReturns.dart';
//import 'package:unified_reminder/screens/TDS/UpComingComliancesScreen.dart';
import 'package:unified_reminder/styles/colors.dart';

import '../screens/PPF/History.dart';
import '../screens/PPF/Record.dart';

class PPFScreen extends StatefulWidget {
  final Client client;
  PPFScreen({this.client});

  @override
  _PPFScreenState createState() => _PPFScreenState();
}

class _PPFScreenState extends State<PPFScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.client.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("PPF for ${widget.client.name}"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "PPF for ${widget.client.name}",
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HistoryForPPF(
                                client: widget.client,
                              )));
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PPFRecord(
                            client: widget.client,
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
                              "Add Record",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => TDSPayment(
//                                    client: widget.client,
//                                  )));
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
//                              "Payment of TDS",
//                              textAlign: TextAlign.center,
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => TDSQuarterly(
//                                client: widget.client,
//                              )));
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
//                              "Quarterly Returns",
//                              textAlign: TextAlign.center,
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//class TDSScreen extends StatelessWidget {
//
//}

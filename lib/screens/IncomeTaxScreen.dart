import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/screens/IncomeTax/ComplianceHistory.dart';
import 'package:unified_reminder/screens/UpComingComliancesScreen.dart';
import 'package:unified_reminder/styles/colors.dart';

import 'ComplianceHistory.dart';
import 'IncomeTax/Payment.dart';
import 'IncomeTax/ReturnFilling.dart';
import 'IncomeTax/UpComingComliancesScreen.dart';

class IncomeTaxScreen extends StatefulWidget {
  final Client client;
  IncomeTaxScreen({this.client});
  @override
  _IncomeTaxScreenState createState() => _IncomeTaxScreenState();
}

class _IncomeTaxScreenState extends State<IncomeTaxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Income Tax for ${widget.client.name}"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Income Tax for ${widget.client.name}",
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
                          builder: (context) => ComplianceHistoryForIncomeTax(
                              client: widget.client)));
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
                              builder: (context) =>
                                  UpComingComliancesScreenForIncomeTax(
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
                              "Upcoming Compliances",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IncomeTaxPayment(
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
                              "Payment of Income Tax",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
//                  GestureDetector(
//                    onTap: () {
//                      Navigator.of(context).push(MaterialPageRoute(
//                          builder: (context) => IncomeTaxReturnFilling(
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
//                              "Return Filling",
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

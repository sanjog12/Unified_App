import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/EPF/MonthlyContribution.dart';
import 'package:unified_reminder/styles/colors.dart';

import '../router.dart';
import '../screens/EPF/ComplianceHistory.dart';

class EPFScreen extends StatefulWidget {
  final Client client;

  const EPFScreen({this.client});
  @override
  _EPFScreenState createState() => _EPFScreenState();
}

class _EPFScreenState extends State<EPFScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EPF for ${widget.client.name}"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "EPF for ${widget.client.name}",
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
                          builder: (context) => ComplianceHistoryForEPF(
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
                    onTap: (){
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => UpcomingCompliances(
//                                client: widget.client,
//                              )));
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonthlyContribution(
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
                              "Monthly Constribution",
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
//                              builder: (context) => DetailsOfContribution(
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
//                              "Details For Constribution",
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

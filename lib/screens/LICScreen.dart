import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/LIC/ComplianceHistoryForTDS.dart';
import 'package:unified_reminder/screens/LIC/Payment.dart';
import 'package:unified_reminder/screens/LIC/UpComingComliancesScreen.dart';
import 'package:unified_reminder/styles/colors.dart';

class LICScreen extends StatefulWidget {
  final Client client;
  LICScreen({this.client});

  @override
  _LICScreenState createState() => _LICScreenState();
}

class _LICScreenState extends State<LICScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.client.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("LIC for ${widget.client.name}"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "LIC for ${widget.client.name}",
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
                          builder: (context) => ComplianceHistoryForLIC(
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
                          builder: (context) => UpCommingComliancesScreenForLIC(
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
                              "Future Compliances",
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
                              builder: (context) => LICPayment(
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
                              "Payment of LIC",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

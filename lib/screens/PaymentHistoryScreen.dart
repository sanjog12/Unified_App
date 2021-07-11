import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/PaymentHistory.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final UserBasic userBasic;

  const PaymentHistoryScreen({Key key, this.userBasic}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<PaymentHistory>>(
                future: HistoriesDatabaseHelper().paymentHistory(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PaymentHistory>> snapshot) {
                  print("1");
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        print("1 " + snapshot.data.length.toString());
                        return Container(
                          decoration: roundedCornerButton,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                            title: Text(snapshot.data[index].paymentId != null
                                ? "Payment ID: " +
                                    snapshot.data[index].paymentId
                                : "No History found"),
                            subtitle: Column(
                              children: [
                                Text(snapshot.data[index].dateOfPayment != null
                                    ? "Payment Date: " +
                                        snapshot.data[index].dateOfPayment
                                    : " "),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(snapshot.data[index].nameOfClient != null
                                    ? "Name of client: " +
                                        snapshot.data[index].nameOfClient
                                    : " "),
                              ],
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
            )
          ],
        ),
      ),
    );
  }
}

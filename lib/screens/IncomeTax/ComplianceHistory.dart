import 'package:flutter/material.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForIncomeTax.dart';
import 'package:unified_reminder/models/payment/IncomeTaxPaymentObject.dart';
import 'package:unified_reminder/screens/IncomeTax/HistoryDetailsView.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/GeneralServices/PDFView.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';

class ComplianceHistoryForIncomeTax extends StatefulWidget {
  final Client client;

  const ComplianceHistoryForIncomeTax({this.client});
  @override
  _ComplianceHistoryForIncomeTaxState createState() =>
      _ComplianceHistoryForIncomeTaxState();
}

class _ComplianceHistoryForIncomeTaxState
    extends State<ComplianceHistoryForIncomeTax> {
  
  @override
  void initState() {
    super.initState();
    HistoriesDatabaseHelper().getComplincesHistoryOfIncomeTax(widget.client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Income Tax History"),
        actions: [
          helpButtonActionBar("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20Incometax"),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
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
                    if(snapshot.data.length != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                            onPressed: () =>
                                _getHistoryDetails(snapshot.data[index].key),
                            child: Container(
                              decoration: roundedCornerButton,
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                padding: EdgeInsets.all(05),
                                child: ListTile(
                                  title: Text(snapshot.data[index].date),
                                  subtitle: Column(
                                    children: <Widget>[
                                      Text(snapshot.data[index].type),
                                      snapshot.data[index].type ==
                                          'INCOME_TAX_Return' ?
                                      Text("Tap to see uploaded challan if any",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),) : Text(
                                          ""),
                                    ],
                                  ),
                                  trailing:
                                  Text(snapshot.data[index].type ==
                                      'INCOME_TAX_Return'? " " :(snapshot.data[index].date=='Record Not found'?" ":"INR ${snapshot
                                      .data[index].amount}")),
                                  onTap: () {
                                    if (snapshot.data[index].type ==
                                        'INCOME_TAX') {
                                      _getHistoryDetails(snapshot.data[index].key);
                                    }
                                    else
                                      if (snapshot.data[index].type ==
                                        'INCOME_TAX_Return') {
                                      if (snapshot.data[index].amount != 'null') {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) => PDFViewer(
                                                      pdf: snapshot.data[index].amount,
                                                    )
                                            )
                                        );
                                      }
                                      else {
                                        flutterToast(message: "No File Were Uploaded");
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    else{
                      return Container(
                        height: 50,
                        padding: EdgeInsets.all(15),
                        child: Container(
                          decoration: roundedCornerButton,
                          height: 50,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text("No Record Found"),
                          ),
                        ),
                      );
                    }
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
      IncomeTaxPaymentObject incomeTaxPaymentObject = IncomeTaxPaymentObject();

      incomeTaxPaymentObject = await SingleHistoryDatabaseHelper()
          .getIncomeTaxHistoryDetails(widget.client, key);

      if (incomeTaxPaymentObject != null) {
        print(incomeTaxPaymentObject.BSRcode);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                IncomeTaxPaymentRecordRecordHistoryDetailsView(
              client: widget.client,
              incomeTaxPaymentObject: incomeTaxPaymentObject,
                  keyDB: key,
            ),
          ),
        ).then((value){
          setState(() {
          
          });
        });
      }
    }
  }
}


import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/ROCFormFilling.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';

class ROCRecordHistoryDetailsView extends StatefulWidget {
  
  final Client client;
  final ROCFormSubmission rocFormSubmission;

  const ROCRecordHistoryDetailsView({
    this.client,
    this.rocFormSubmission,
  });

  @override
  _ROCRecordHistoryDetailsViewState createState() =>
      _ROCRecordHistoryDetailsViewState();
}



class _ROCRecordHistoryDetailsViewState
    extends State<ROCRecordHistoryDetailsView> {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("ROC Record Details"),
      ),
      
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              
              Text(
                "${widget.client.name}\'s ROC Record Details",
                style: _theme.textTheme.headline.merge(
                  TextStyle(
                    fontSize: 26.0,
                  ),
                ),
              ),
              
              SizedBox(
                height: 30.0,
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Name of E-form"),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                      )
                    ],
                  ),
                  
                  SizedBox(
                    height: 10.0,
                  ),
                  
                  SizedBox(
                    height: 10.0,
                  ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("SRN number"),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                      )
                    ],
                  ),
                  
                  SizedBox(
                    height: 10.0,
                  ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Date of AGM Conclusion"),
                      
                      SizedBox(
                        height: 10.0,
                      ),
                      
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                        child: Text(
                          widget.rocFormSubmission.dateOfAGMConclusion,
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  
                  SizedBox(
                    height: 10.0,
                  ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      
                      Text("Date of Filling"),
                      
                      SizedBox(
                        height: 10.0,
                      ),
                      
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: fieldsDecoration,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

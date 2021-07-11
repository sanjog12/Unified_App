import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/payment/ESIMonthlyContributionObejct.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateRelated.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class MonthlyContributionESIC extends StatefulWidget {
  final Client client;

  const MonthlyContributionESIC({Key key, this.client}) : super(key: key);

  @override
  _MonthlyContributionState createState() => _MonthlyContributionState();
}

class _MonthlyContributionState extends State<MonthlyContributionESIC> {
  ESIMonthlyContributionObejct esiMonthlyContributionObejct =
      ESIMonthlyContributionObejct();
  bool loadingSaveButton = false;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  DateTime selectedDateOfPayment = DateTime.now();

  String nameOfFile = 'Attach File';
  String _selectedDateOfPayment = 'Select Date';
  String showDateOfPayment = ' ';

  File file;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ESI Monthly Contribution',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Monthly Contribution Payment',
                  style: _theme.textTheme.headline6.merge(
                    TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Enter your details to make payment for Monthly Contribution',
                  style: _theme.textTheme.bodyText2.merge(
                    TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Challan Number'),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TextFormField(
                        decoration:
                            buildCustomInput(hintText: 'Challan Number'),
                        onChanged: (String value) {
                          esiMonthlyContributionObejct.challanNumber = value;
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Amount of Payment',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          decoration: buildCustomInput(
                              hintText: 'Amount of Payment',
                              prefixText: "\u{20B9}"),
                          onChanged: (String value) {
                            esiMonthlyContributionObejct.amountOfPayment =
                                value;
                          },
                          validator: (String value) {
                            return requiredField(value, 'Amount of Payment');
                          },
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Date of Payment'),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: fieldsDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '$_selectedDateOfPayment',
                          ),
                          TextButton(
                            onPressed: () async {
                              selectedDateOfPayment =
                                  await DateChange.selectDateTime(
                                      context, 1, 1);
                              setState(() {
                                esiMonthlyContributionObejct.dateOfFilling =
                                    DateFormat('dd-MM-yyyy')
                                        .format(selectedDateOfPayment);
                                _selectedDateOfPayment =
                                    DateFormat('dd-MM-yyyy')
                                        .format(selectedDateOfPayment);
                              });
                            },
                            child: Icon(Icons.date_range),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Add Attachment'),
                    SizedBox(height: 10),
                    Container(
                      decoration: roundedCornerButton,
                      height: 50,
                      child: TextButton(
                        onPressed: () async {
                          FilePickerResult filePickerResult =
                              await FilePicker.platform.pickFiles();
                          file = File(filePickerResult.files.single.path);
                          List<String> temp = file.path.split('/');
                          esiMonthlyContributionObejct.addAttachment =
                              temp.last;
                          setState(() {
                            nameOfFile = temp.last;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.attach_file),
                            SizedBox(width: 6),
                            Text(nameOfFile),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: roundedCornerButton,
                  child: TextButton(
                    child: Text('Save Record'),
                    onPressed: () {
                      saveRecordESI();
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                helpButtonBelow(
                    "https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20ESI"),
                SizedBox(
                  height: 70.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveRecordESI() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      setState(() {
        loadingSaveButton = true;
      });
      await PaymentRecordToDataBase().addESIMonthlyContributionPayment(
          esiMonthlyContributionObejct, widget.client, file);
      Navigator.pop(context);
    } else {
      flutterToast(message: "Please fill all the fields");
    }
  }
}

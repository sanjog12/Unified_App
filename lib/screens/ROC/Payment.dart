import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/ROCPaymentObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/validators.dart';

class ROCPayment extends StatefulWidget {
  final Client client;

  const ROCPayment({this.client});
  @override
  _ROCPaymentState createState() => _ROCPaymentState();
}

class _ROCPaymentState extends State<ROCPayment> {
  bool buttonLoading = false;
  GlobalKey<FormState> _ROCPaymentFormKey = GlobalKey<FormState>();

  ROCPaymentObject rocPaymentObject = ROCPaymentObject();

  static DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);

  String _nameOfEForm;
  String _selectedDate = 'Select Date';

  @override
  void initState() {
    super.initState();
//    print(date);
    print(widget.client.email);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("ROC Payment"),
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Details of ROC",
                  style: _theme.textTheme.headline6.merge(
                    TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Form(
                  key: _ROCPaymentFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("CIN Number"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration:
                                buildCustomInput(hintText: "CIN Number"),
                            validator: (value) => requiredField(value, 'CIN'),
                            onSaved: (value) =>
                                rocPaymentObject.CINNumber = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Name Of E-form"),
                          SizedBox(
                            height: 10.0,
                          ),
                          DropdownButtonFormField(
                            hint: Text("Name of E-form"),
                            validator: (String value) {
                              return requiredField(value, "Name of E-form");
                            },
                            onSaved: (value) =>
                                rocPaymentObject.nameOfEForm = value,
                            decoration: buildCustomInput(),
                            items: [
                              DropdownMenuItem(
                                child: Text('Form ADT-1'),
                                value: 'Form ADT-1',
                              ),
                              DropdownMenuItem(
                                child: Text('Form AOC-4 and Form AOC-4 CFS'),
                                value: 'Form AOC-4 and Form AOC-4 CFS',
                              ),
                              DropdownMenuItem(
                                child: Text('Form AOC-4(XBRL)'),
                                value: 'Form AOC-4(XBRL)',
                              ),
                              DropdownMenuItem(
                                child: Text('Form MGT-7'),
                                value: 'Form MGT-7',
                              ),
                              DropdownMenuItem(
                                child: Text('Form CRA-4'),
                                value: 'Form CRA-4',
                              ),
                              DropdownMenuItem(
                                child: Text('Form MGT-14'),
                                value: 'Form MGT-14',
                              ),
                            ],
                            value: _nameOfEForm,
                            onChanged: (String v) {
                              this.setState(() {
                                _nameOfEForm = v;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Purpose of E-form"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration:
                                buildCustomInput(hintText: "Purpose of E-form"),
                            validator: (value) =>
                                requiredField(value, 'Purpose of E-form'),
                            onSaved: (value) =>
                                rocPaymentObject.purposeOfEForm = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Select Date"),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: fieldsDecoration,
                            child: TextButton(
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(2020, 1, 1),
//                                        maxTime: DateTime(2030, 6, 7),
                                    onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  List<String> dateData =
                                      date.toString().split(' ');
                                  String dateIs = dateData[0];
                                  setState(() {
                                    _selectedDate = dateIs;
                                  });
                                  print('confirm $date');
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '$_selectedDate',
                                  ),
                                  Icon(Icons.date_range),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Amount of Payment"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration:
                                buildCustomInput(hintText: "Amount of Payment"),
                            validator: (value) =>
                                requiredField(value, 'Amount Of Payment'),
                            onSaved: (value) => rocPaymentObject.amount = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        decoration: roundedCornerButton,
                        height: 50.0,
                        child: TextButton(
                          child: Text("Save Payment"),
                          onPressed: () {
                            addDetailsOfContribution();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> addDetailsOfContribution() async {
    try {
      if (_ROCPaymentFormKey.currentState.validate()) {
        _ROCPaymentFormKey.currentState.save();
        this.setState(() {
          buttonLoading = true;
        });

        rocPaymentObject.date = _selectedDate;

        bool done = await PaymentRecordToDataBase()
            .AddROCPayment(rocPaymentObject, widget.client);

        if (done) {
          Navigator.pop(context);
        }
      }
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Payment Not Saved This Time',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/PPFRecordObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class PPFRecord extends StatefulWidget {
  final Client client;

  const PPFRecord({this.client});
  @override
  _PPFRecordState createState() => _PPFRecordState();
}

class _PPFRecordState extends State<PPFRecord> {
  bool buttonLoading = false;
  GlobalKey<FormState> pPFRecordFormKey = GlobalKey<FormState>();

  PPFRecordObject ppfRecordObject = PPFRecordObject();



  String _selectedDateOfPayment = 'Select date';
  DateTime selectedDateOfPayment = DateTime.now();


  Future<void> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfPayment ,
        firstDate: DateTime(DateTime.now().year-1),
        lastDate: DateTime(DateTime.now().year+1)
    );
  
    if(picked != null && picked != selectedDateOfPayment){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateOfPayment = picked;
        _selectedDateOfPayment = DateFormat('dd/MMMM/yyyy').format(picked);
        ppfRecordObject.dateOfInvestment = _selectedDateOfPayment;
      });
    }
  }
  
  

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("PPF Record"),
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Details of PPF",
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
                  key: pPFRecordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Name Of Institution"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: buildCustomInput(hintText: "Name Of Institution"),
                            validator: (value) =>
                                requiredField(value, 'Name Of Institution'),
                            onSaved: (value) =>
                                ppfRecordObject.nameOfInstitution = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Account Number"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration:
                                buildCustomInput(hintText: "Account Number"),
                            validator: (value) =>
                                requiredField(value, 'Account number'),
                            onSaved: (value) =>
                                ppfRecordObject.accountNumber = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
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
                                buildCustomInput(hintText: "Amount of Payment", prefixText: "\u{20B9}"),
                            validator: (value) =>
                                requiredField(value, 'Amount Of Payment'),
                            onSaved: (value) => ppfRecordObject.amount = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Date of Payment"),
                          SizedBox(
                            height: 10.0,
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
                                  onPressed: () {
                                    selectDateTime(context);
                                  },
                                  child: Icon(Icons.date_range),
                                ),
                              ],
                            ),
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
                          child: Text("Save Record"),
                          onPressed: () {
                            addDetailsOfContribution();
                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      helpButtonBelow("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20PF"),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
  
                SizedBox(height: 70,),
              ],
            ),
          ),
        ));
  }

  Future<void> addDetailsOfContribution() async {
    try {
      if (pPFRecordFormKey.currentState.validate()) {
        pPFRecordFormKey.currentState.save();
        this.setState(() {
          buttonLoading = true;
        });

        bool done = await PaymentRecordToDataBase()
            .addPPFRecord(ppfRecordObject, widget.client);

        if (done) {
          Navigator.pop(context);
        }
      }
    } on PlatformException catch (e) {
      print(e.message);
      flutterToast(message: e.message);
    } catch (e) {
      print(e);
      flutterToast(message: 'Payment Not Saved This Time');
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
}

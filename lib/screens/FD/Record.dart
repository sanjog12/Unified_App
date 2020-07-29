import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/FDRecordObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateChange.dart';
import 'package:unified_reminder/utils/validators.dart';

class FDRecord extends StatefulWidget {
  final Client client;

  const FDRecord({this.client});
  @override
  _FDRecordState createState() => _FDRecordState();
}

class _FDRecordState extends State<FDRecord> {
  bool buttonLoading = false;
  GlobalKey<FormState> _FDRecordFormKey = GlobalKey<FormState>();

  FDRecordObject fdRecordObject = FDRecordObject();

  String selectedDateOfPayment = 'Select Date';
  DateTime selectedDateOfInvestment = DateTime.now();



  Future<void> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateOfInvestment ,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year+1)
    );
  
    if(picked != null && picked != selectedDateOfInvestment){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedDateOfInvestment = picked;
        selectedDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
        fdRecordObject.dateOfInvestment = selectedDateOfPayment;
      });
    }
  }
  
  
  

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Fixed Deposit Record"),
        ),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Details of Fixed Deposit",
                  style: _theme.textTheme.headline.merge(
                    TextStyle(
                      fontSize: 26.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Form(
                  key: _FDRecordFormKey,
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
                            decoration: buildCustomInput(
                                hintText: "Name Of Institution"),
                            validator: (value) =>
                                requiredField(value, 'Name Of Institution'),
                            onChanged: (value) =>
                                fdRecordObject.nameOfInstitution = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Fixed Deposit Number"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: buildCustomInput(
                                hintText: "Fixed Deposit Number"),
                            validator: (value) =>
                                requiredField(value, 'Fixed Deposit Number'),
                            onChanged: (value) =>
                                fdRecordObject.fixedDepositNo = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Principal Amount"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration:
                                buildCustomInput(hintText: "Principal Amount"),
                            validator: (value) =>
                                requiredField(value, 'Principal Amount'),
                            onChanged: (value) =>
                                fdRecordObject.principalAmount = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Date of Investment"),
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
                                  '$selectedDateOfPayment',
                                ),
                                FlatButton(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Maturity Amount"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration:
                                buildCustomInput(hintText: "Maturity Amount"),
                            validator: (value) =>
                                requiredField(value, 'Maturity Amount'),
                            onChanged: (value) =>
                                fdRecordObject.maturityAmount = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Rate Of Interest"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration:
                                buildCustomInput(hintText: "Rate Of Interest"),
                            validator: (value) =>
                                requiredField(value, 'Rate Of Interest'),
                            onChanged: (value) =>
                                fdRecordObject.rateOfInterest = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Term Of Investment"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: buildCustomInput(
                              hintText: "Term Of Investment",
                            ),
                            validator: (value) =>
                                requiredField(value, 'Term Of Investment(in months)'),
                            onChanged: (value) =>
                                fdRecordObject.termOfInvestment = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Second Holder (If Joint)"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: buildCustomInput(
                                hintText: "Second Holder Name"),
//                            validator: (value) =>
//                                requiredField(value, 'Term Of Investment'),
                            onChanged: (value) =>
                                fdRecordObject.secondHolderName = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Nominee Details"),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: buildCustomInput(hintText: "Name"),
                            validator: (value) => requiredField(value, 'Name'),
                            onChanged: (value) =>
                                fdRecordObject.nomineeName = value,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        decoration: roundedCornerButton,
                        height: 50.0,
                        child: FlatButton(
                          child: Text("Save Record"),
                          onPressed: () {
                            AddDetailsOfContribution();
                          },
                          
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> AddDetailsOfContribution() async {
    try {
      print(_FDRecordFormKey.currentState.validate());
      if (_FDRecordFormKey.currentState.validate()) {
        _FDRecordFormKey.currentState.save();
//        print("1");
        setState(() {
          buttonLoading = true;
        });
//        print("1");
        print(fdRecordObject.dateOfInvestment);
        fdRecordObject.maturityDate = DateChange.addMonthToDate(fdRecordObject.dateOfInvestment,int.parse(fdRecordObject.termOfInvestment));
//        print("1");
        bool done = await PaymentRecordToDataBase()
            .AddFDRecord(fdRecordObject, widget.client);
//        print("1");

        if (done) {
          Navigator.pop(context);
        }
      }
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Color(0xff666666),
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
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

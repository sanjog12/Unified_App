import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/MutualFundObject.dart';
import 'package:unified_reminder/models/MutualFundRecordObject.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/services/MutualFundHelper.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class AddMFScreen extends StatefulWidget {
  final Client client;

  const AddMFScreen({this.client});

  @override
  _AddMFScreenState createState() => _AddMFScreenState();
}

String _searchText = '';
bool listShow = false;

class _AddMFScreenState extends State<AddMFScreen> {
  String modeTypeSelected = 'Lump Sum';
  String frequency = 'Monthly';
  String numberOfInstalments = ' ';
  String _selectedDate = 'Select Date';
  String _selectedDateRaw = ' ';
  DateTime selectedDate = DateTime.now();
  MutualFundObject selectedMutualFundObject;
  MutualFundDetailObject mutualFundDetailObject;
  String _amount;
  var jsonResult;
  GlobalKey<FormState> _MFRecordFormKey = GlobalKey<FormState>();
  bool buttonLoading = false;
  bool searching = true;
  bool temp = false;
  bool listener = true;
  bool fetchDetails = false;
  TextEditingController _controller = TextEditingController();

  Future<DateTime> selectDateTime(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    return pickedDate;
  }

  Future<List<MutualFundObject>> getJsonData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/mutual_funds.json");
    jsonResult = json.decode(data);
    List<MutualFundObject> mutualFunds = [];
    var fundsData = jsonResult['mutual_fund_names'];
    for (var item in fundsData) {
      String fundName, fundCode, searchText;
      fundName = item['name'].toString().toUpperCase();
      fundCode = item['code'];
      searchText = _searchText.toUpperCase();

      List<String> fundNameList = fundName.split(searchText);
      if (fundNameList.length > 1) {
        MutualFundObject mutualFundObject =
            MutualFundObject(name: fundName, code: fundCode);
        mutualFunds.add(mutualFundObject);
      }
    }
    return mutualFunds;
  }

  @override
  void initState() {
    super.initState();
    listShow = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getJsonData();
    });
  }

  void stateManager() {
    if (modeTypeSelected == 'SIP') {
      temp = true;
    } else
      temp = false;
  }

  void onChange() {
    setState(() {
      _searchText = _controller.text;
      if (_searchText.length > 2) {
        listShow = true;
      } else {
        selectedMutualFundObject = null;
        listShow = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    if (listener) {
      _controller.addListener(onChange);
    } else if (listener == false) {
      _controller.dispose();
      _controller.removeListener(onChange);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add MF Portfolio"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 24.0, right: 24, left: 24, bottom: 100),
        child: Form(
          key: _MFRecordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Mutual Fund Payment",
                style: _theme.textTheme.headline6.merge(
                  TextStyle(
                    fontSize: 26.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '$_selectedDate',
                        ),
                        TextButton(
                          onPressed: () async {
                            DateTime selectedDate =
                                await selectDateTime(context);
                            setState(() {
                              _selectedDateRaw = selectedDate.toString();
                              _selectedDate =
                                  DateFormat("dd-MM-yyyy").format(selectedDate);
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
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Search Mutual Fund Name"),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _controller,
                    autofocus: false,
                    decoration: buildCustomInput(hintText: "Mutual Fund Name"),
//                    validator: (value) =>
//                        requiredField(value, 'Amount of payment'),
//                  onSaved: (value) => _searchText = value,
                  ),
                ],
              ),
              listShow
                  ? Container(
                      height: 150,
                      child: FutureBuilder<List<MutualFundObject>>(
                        future: getJsonData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<MutualFundObject>> snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              color: Colors.white70,
                              alignment: Alignment.center,
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        listShow = false;
                                        _searchText = snapshot.data[index].name;
                                        selectedMutualFundObject =
                                            MutualFundObject(
                                                name: snapshot.data[index].name,
                                                code:
                                                    snapshot.data[index].code);
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: Container(
                                      color: Colors.white70,
                                      margin: EdgeInsets.all(2),
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else
                            return SizedBox();
                        },
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 30.0,
              ),
              selectedMutualFundObject != null
                  ? Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("Selected Fund Name is"),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: fieldsDecoration,
                              child: Text(_searchText),
                            ),

                            SizedBox(
                              height: 20.0,
                            ),

                            Text("Nav Value"),

                            SizedBox(
                              height: 10.0,
                            ),

                            FutureBuilder<MutualFundDetailObject>(
                              future: MutualFundHelper()
                                  .getMutualFundDetailsData(
                                      selectedMutualFundObject.code,
                                      _selectedDateRaw),
                              builder: (BuildContext context,
                                  AsyncSnapshot<MutualFundDetailObject>
                                      snapshot) {
                                if (snapshot.data != null) {
                                  mutualFundDetailObject = snapshot.data;
                                  return Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: fieldsDecoration,
                                    child: Text(snapshot.data.nav),
                                  );
                                } else
                                  return Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: fieldsDecoration,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        JumpingDotsProgressIndicator(
                                          color: Colors.white,
                                          fontSize: 20,
                                          numberOfDots: 5,
                                          milliseconds: 300,
                                        ),
                                      ],
                                    ),
                                  );
                              },
                            ),

                            SizedBox(
                              height: 30.0,
                            ),

                            Text("Select Mode Type"),
                            SizedBox(
                              height: 10,
                            ),

//                              DropdownButtonFormField(
//                                hint: Text('Select mode type'),
//                                decoration: buildCustomInput(),
//                                validator: (value){
//                                  return requiredField(value, 'Select Mode Type');
//                                },
//                                items: [
//                                  DropdownMenuItem(
//                                    child: Text('SIP'),
//                                    value: 'SIP',
//                                  ),
//
//                                  DropdownMenuItem(
//                                    child: Text('Lump Sum'),
//                                    value: 'Lump Sum',
//                                  )
//                                ],
//
//                                value: modeTypeSelected,
//                                onChanged: (String v){
//                                  stateManager();
//                                  this.setState((){
//                                    modeTypeSelected =v;
//                                    selectedMutualFundObject = MutualFundObject(type: v);
//                                  });
//                                },
//                              ),

                            Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text("SIP"),
                                  leading: Radio(
                                    value: "SIP",
                                    groupValue: modeTypeSelected,
                                    onChanged: (String v) {
                                      setState(() {
                                        modeTypeSelected = v;
//                                          selectedMutualFundObject = MutualFundObject(type: v);
                                      });
                                      stateManager();
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text("Lump sum"),
                                  leading: Radio(
                                    value: "Lump sum",
                                    groupValue: modeTypeSelected,
                                    onChanged: (String v) {
                                      setState(() {
                                        modeTypeSelected = v;
//                                          selectedMutualFundObject = MutualFundObject(type: v);
                                      });
                                      stateManager();
                                    },
                                  ),
                                ),
                              ],
                            ),
  
  
                            modeTypeSelected == 'SIP'
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 30),
                                      Text("SIP Frequency", textAlign: TextAlign.left,),
                                      ListTile(
                                        title: Text("Monthly"),
                                        leading: Radio(
                                          value: "Monthly",
                                          groupValue: frequency,
                                          onChanged: (String v) {
                                            setState(() {
                                              frequency = v;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: Text("Quarterly"),
                                        leading: Radio(
                                          value: "Quarterly",
                                          groupValue: frequency,
                                          onChanged: (String v) {
                                            setState(() {
                                              frequency = v;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),

                            temp
                                ? Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text("Enter Number of Instalments"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          decoration: buildCustomInput(
                                              hintText:
                                                  'Enter number of Instalments',
                                              suffixText: "Months"),
                                          autofocus: false,
                                          validator: (value) {
                                            return requiredField(value,
                                                'Enter number of Instalments');
                                          },
                                          onSaved: (value) {
                                            fetchDetails = true;
                                            numberOfInstalments = value;
                                            selectedMutualFundObject
                                                .numberOfInstalments = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),

                            SizedBox(
                              height: 30,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text("Enter Amount"),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  autofocus: false,
                                  decoration: buildCustomInput(
                                      hintText: "Amount",
                                      prefixText: "\u{20B9}"),
                                  validator: (value) =>
                                      requiredField(value, 'Amount'),
                                  onSaved: (value) => _amount = value,
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 40.0,
                            ),

                            Container(
                              decoration: roundedCornerButton,
                              height: 50.0,
                              child: TextButton(
                                child: Text("Save Portfolio"),
                                onPressed: () {
//                                    if(fetchDetails)
//                                      fetchPreviousNAV();
                                  mFRecord();
                                  DateTime scheduledDate = DateTime.now()
                                      .subtract(Duration(hours: 60));
                                },
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            helpButtonBelow(
                                "https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20mutualfunds"),
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> mFRecord() async {
    try {
      if (_MFRecordFormKey.currentState.validate()) {
        _MFRecordFormKey.currentState.save();
        if (selectedMutualFundObject != null) {
          if (mutualFundDetailObject != null) {
            this.setState(() {
              buttonLoading = true;
            });

            MutualFundRecordObject mutualFundRecordObject =
                MutualFundRecordObject(
                    type: modeTypeSelected,
                    amount: _amount,
                    sipFrequency: frequency,
                    frequency: numberOfInstalments,
                    mutualFundObject: selectedMutualFundObject,
                    mutualFundDetailObject: mutualFundDetailObject);
            bool done = await PaymentRecordToDataBase()
                .addMFRecord(mutualFundRecordObject, widget.client);
            if (done) {
              flutterToast(message: "Portfolio has been created Successfully");
              Navigator.pop(context);
            }
          } else {
            flutterToast(message: 'Scheme No More Available!');
          }
        }
      } else {
        flutterToast(message: 'Scheme Not Selected');
      }
    } on PlatformException catch (e) {
      flutterToast(message: e.message);
    } catch (e) {
      flutterToast(message: 'Something went wrong');
    } finally {
      this.setState(() {
        buttonLoading = false;
      });
    }
  }
}

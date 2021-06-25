import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/quarterlyReturns/TDSQuarterlyReturnsObject.dart';
import 'package:unified_reminder/services/QuarterlyReturnsRecordToDatabase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class TDSQuarterly extends StatefulWidget {
  
  final Client client;

  const TDSQuarterly({Key key, this.client}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return _TDSQuarterly();
  }
}


class _TDSQuarterly extends State<TDSQuarterly>{
  
  bool loadingSave = false;
  String formTypeSelected;
  String _selectedDateOfFiling = 'Select date';
  String selectedDateOfFiling = ' ';
  DateTime selectedFilingDate = DateTime.now();
  TDSQuarterlyReturnsObject tdsQuarterlyReturnsObject = TDSQuarterlyReturnsObject();
  GlobalKey<FormState> _key = GlobalKey<FormState>();


  Future<Null> selectDateTime(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFilingDate ,
        firstDate: DateTime(2019),
        lastDate: DateTime(2021)
    );
  
    if(picked != null && picked != selectedFilingDate){
      setState(() {
        print('Checking ' + widget.client.company);
        selectedFilingDate= picked;
        print(picked);
        selectedDateOfFiling = DateFormat('dd-MM-yyyy').format(picked);
        tdsQuarterlyReturnsObject.dateOfFilledReturns = selectedDateOfFiling;
        _selectedDateOfFiling = DateFormat('dd-MMMM-yy').format(picked);
      });
    }
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("TDS Quarterly Returns"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "TDS Quarterly Returns",
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
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Date of Filled Returns"),
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
                                '$_selectedDateOfFiling',
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
                      height: 20.0,
                    ),
                    
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Name of Form"),
                        SizedBox(
                          height: 10.0,
                        ),
                        
                        DropdownButtonFormField(
                          hint: Text('Select Form'),
                          validator: (String value){
                            return requiredField(value, 'Name of Form');
                          },
                          decoration: buildCustomInput(),
                          items: [
                            DropdownMenuItem(
                              child: Text('24Q'),
                              value: '24Q',
                            ),
                            
                            DropdownMenuItem(
                              child: Text('26Q'),
                              value: '26Q',
                            )
                          ],
                          value: formTypeSelected,
                          onChanged: (String value){
                            tdsQuarterlyReturnsObject.nameOfForm = value;
                            setState(() {
                              formTypeSelected = value;
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("Acknowledgement Number"),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          onChanged: (String value){
                            tdsQuarterlyReturnsObject.acknowledgementNo = value;
                          },
                          decoration:
                              buildCustomInput(hintText: "Challan Number"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      decoration: roundedCornerButton,
                      height: 50.0,
                      child: loadingSave? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>
                            (Colors.white70),
                        ),
                      ):TextButton(
                        child: Text("Save Record"),
                        onPressed: () {
                          saveRecord();
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    helpButtonBelow("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20TDS"),
                    SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> saveRecord() async{
    if(_key.currentState.validate()){
      _key.currentState.save();
      
      setState(() {
        loadingSave = true;
      });
      
      await QuarterlyReturnsRecordToDatabase().addTDSQuarterlyReturns(tdsQuarterlyReturnsObject, widget.client);
      Navigator.pop(context);
      flutterToast(message: "Date has Been Recorded");
    }
  }
  
}

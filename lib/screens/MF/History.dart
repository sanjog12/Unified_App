import 'package:flutter/material.dart';
import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/MutualFundRecordObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryMF.dart';
import 'package:unified_reminder/screens/MF/HistoryListView.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/MutualFundHelper.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/utils/DateChange.dart';

class HistoryForFM extends StatefulWidget {
  final Client client;

  const HistoryForFM({this.client});
  @override
  _HistoryForFMState createState() => _HistoryForFMState();
}



class _HistoryForFMState extends State<HistoryForFM> {
  static DateTime now = DateTime.now();
  DateTime date = DateTime(now.year, now.month, now.day);
  
  String _fullDate = ' ';
  @override
  void initState() {
    super.initState();
    List<String> dateData = date.toString().split(' ');
    _fullDate = dateData[0];
    print(_fullDate);
  }
  
  String currentNav= "Calculating";
  bool got = false;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mutual Fund History"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<HistoryForMF>>(
                future: HistoriesDatabaseHelper()
                    .getHistoryOfFMRecord(widget.client),
                builder: (BuildContext context,
                    AsyncSnapshot<List<HistoryForMF>> snapshot){
                  print(snapshot.hasData);
                  if (snapshot.hasData){
                    print("History");
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: TextButton(
                            onPressed: (){
//                              print(snapshot.data[index].key.toString());
//                              fullDetails(snapshot.data[index].key.toString(),widget.client);
                            },
                            child:Text("test"))
                        );
                      },
                    );
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

  Widget showRecord(HistoryForMF mutualFundRecordObject,String key) {
    if(mutualFundRecordObject.amount != null){
    double units = (double.parse(mutualFundRecordObject.amount) /
        double.parse(mutualFundRecordObject.mutualFundDetailObject.nav));
    return Container(
      padding: EdgeInsets.all(20.0),
      color: buttonColor,
      child: Column(
        children: <Widget>[
          Text(mutualFundRecordObject.mutualFundObject.name),
          Divider(thickness: 1.5,),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Current Nav Value'),
                  SizedBox(height: 5),
                ],
              ),
              Column(
                children: <Widget>[
                  Text('Units'),
                  SizedBox(height: 5),
                  Text(units.toStringAsFixed(3)),
                ],
              ),
              Column(
                children: <Widget>[
                  Text('Investment'),
                  SizedBox(height: 5),
                  Text(mutualFundRecordObject.amount),
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[],
          )
        ],
      ),
    );}
    else{
      return Container(
        child: Text("No record present right now",),
      );
    }
  }
  
  getObject(String key){
    SingleHistoryDatabaseHelper().getMFHistory(key, widget.client).then((value){
      return value;
    });
  }
  
  Future<String> getTodayNa(String code) async{
    MutualFundDetailObject mutualFundDetailObject;
    String d;
    String date = DateTime.now().toString();
    List<String> temp = date.split(' ');
    String temp2 = temp[0].toString();
    List<String> dateData = temp2.split('-');
    String selectedDateString = '${dateData[2]}-${dateData[1]}-${dateData[0]}';
    String checkDate = DateChange.addDayToDate(selectedDateString, -4);
    print(checkDate);
    while(true){
      print("getTodayNav  " + checkDate);
      if(mutualFundDetailObject != null )
        d= mutualFundDetailObject.nav;
      mutualFundDetailObject = await MutualFundHelper().getMutualFundNAV(code, checkDate, checkDate);
      checkDate = DateChange.addDayToDate(checkDate, 1);
      if(mutualFundDetailObject == null)
        break;
    }
    return d;
  }
  
  
  Future<void> fullDetails(String key , Client client) async{
    if(key.isNotEmpty){
      print("1");
      MutualFundRecordObject mutualFundRecordObject = MutualFundRecordObject();
      mutualFundRecordObject = await SingleHistoryDatabaseHelper()
          .getMFHistory(key, client);
      print('2');
      print(mutualFundRecordObject.toString());
      
      if(mutualFundRecordObject != null){
	      print(mutualFundRecordObject.amount);
        print('3');
        Navigator.push(context,MaterialPageRoute(
          builder: (context) => HistoryView(
//            dbKey: key,
            client: client,
//            mutualFundRecordObject: mutualFundRecordObject,
          ),
        ),
        );
      }
    }
  }
}

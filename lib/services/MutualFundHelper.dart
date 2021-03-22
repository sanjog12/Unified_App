// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
import 'package:unified_reminder/models/MutualFundDetailObject.dart';
// import 'package:unified_reminder/models/history/HistoryMF.dart';
import 'package:unified_reminder/utils/DateChange.dart';

import 'networking.dart';

class MutualFundHelper {
  
  
  String open_api_url = 'https://api.mfapi.in/mf';
  
  
  Future<MutualFundDetailObject> getMutualFundDetailsData(
      String code, String date) async {
    String url = '$open_api_url/$code';

    print(date);
    MutualFundDetailObject mutualFundDetailObject;
    List<String> temp = date.split(' ');
    String temp2 = temp[0].toString();
    List<String> dateData = temp2.split('-');
    String selectedDateString = '${dateData[2]}-${dateData[1]}-${dateData[0]}';
    print('getMutualFund date ' + selectedDateString);
    String t = selectedDateString;
    bool check = true;
    NetworkHelper networkHelper = NetworkHelper(url: url);

    var getMutualFundData = await networkHelper.getDate();
//    print(getMutualFundData['data']);
//    print(selectedDateString);
    print(url);
    for(int i=0 ; i < 3 ;i++) {
      for (var item in getMutualFundData['data']) {
        if (item['date'] == selectedDateString) {
          print(item);
          mutualFundDetailObject =
              MutualFundDetailObject(date: t, nav: item['nav']);
          check = false;
          break;
        } else {
        
        }
      }
      if(check == false)
        break;
      selectedDateString = DateChange.addDayToDate(selectedDateString, 1);
      print(selectedDateString);
    }
    return mutualFundDetailObject;
  }
  
  

  Future<MutualFundDetailObject> getTodayNav(String code) async{
    print("today NAV");
    print(code);
    MutualFundDetailObject mutualFundDetailObject ;
    MutualFundDetailObject d;
    String date = DateTime.now().toString();
    List<String> temp = date.split(' ');
    String temp2 = temp[0].toString();
    List<String> dateData = temp2.split('-');
    String selectedDateString = '${dateData[2]}-${dateData[1]}-${dateData[0]}';
    String checkDate = DateChange.addDayToDate(selectedDateString, -1);

    print(mutualFundDetailObject);

    while(true){
      print(checkDate);
      if(mutualFundDetailObject != null ) {
        d = mutualFundDetailObject;
        break;
      }
      mutualFundDetailObject = await MutualFundHelper().getMutualFundNAV(
          code, checkDate, checkDate);
      checkDate = DateChange.addDayToDate(checkDate, -1);
    }
    print(d.date);
    print("returning");
    return d;
  }
  

  
  Future<MutualFundDetailObject> getMutualFundNAV(
      String code, String date, String actualDate) async {
//    print("inside getMutualFund");
//    print(code);
//    print(date);
    String url = '$open_api_url/$code';
    NetworkHelper networkHelper = NetworkHelper(url: url);
    MutualFundDetailObject mutualFundDetailObject ;

    var getMutualFundData = await networkHelper.getDate();
    print(url);
    
    for (var item in getMutualFundData['data']) {
      if (item['date'] == date) {
//        print('found');
        mutualFundDetailObject =
            MutualFundDetailObject(date: actualDate, nav: item['nav']);
        break;
      }
      else{
//        print('else');
      mutualFundDetailObject = null;}
    }
    
//    if(mutualFundDetailObject.nav != null)
//      print(mutualFundDetailObject.nav);
    print('returning ');
    return mutualFundDetailObject;
  }
  
}

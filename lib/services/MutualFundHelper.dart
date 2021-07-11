// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
import 'dart:collection';
import 'dart:convert';

import 'package:unified_reminder/models/MutualFundDetailObject.dart';

// import 'package:unified_reminder/models/history/HistoryMF.dart';
import 'package:unified_reminder/utils/DateRelated.dart';

import 'GeneralServices/networking.dart';

LinkedHashMap<String, dynamic> cache = LinkedHashMap.of({
  'meta': {'scheme_code': "1234567890"}
});

class MutualFundHelper {
  String open_api_url = 'https://api.mfapi.in/mf';
  
  

  Future<MutualFundDetailObject> getMutualFundDetailsData( String code, String date) async {
    String url = '$open_api_url/$code';
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

    for (int i = 0; i < 3; i++) {
      for (var item in getMutualFundData['data']) {
        if (item['date'] == selectedDateString) {
          print(item);
          mutualFundDetailObject =
              MutualFundDetailObject(date: t, nav: item['nav']);
          check = false;
          break;
        } else {}
      }
      if (check == false) break;
      selectedDateString = DateChange.addDayToDate(selectedDateString, 1);
      print(selectedDateString);
    }
    return mutualFundDetailObject;
  }
  
  

  Future<MutualFundDetailObject> getTodayNav(String code) async {
    MutualFundDetailObject mutualFundDetailObject;
    MutualFundDetailObject d;
    String date = DateTime.now().toString();
    List<String> temp = date.split(' ');
    String temp2 = temp[0].toString();
    List<String> dateData = temp2.split('-');
    String selectedDateString = '${dateData[2]}-${dateData[1]}-${dateData[0]}';
    String checkDate = DateChange.addDayToDate(selectedDateString, -1);

    // print(mutualFundDetailObject);

    while (true) {
      // print(checkDate);
      if (mutualFundDetailObject != null) {
        d = mutualFundDetailObject;
        break;
      }
      mutualFundDetailObject =
          await MutualFundHelper().getMutualFundNAV(code, checkDate, checkDate);
      checkDate = DateChange.addDayToDate(checkDate, -1);
    }
    // print(d.date);
    print("returning");
    return d;
  }

  Future<MutualFundDetailObject> getMutualFundNAV(String code, String date, String actualDate) async {
    MutualFundDetailObject mutualFundDetailObject;
    // print(cache['meta']['scheme_code'] == code);

    String url = '$open_api_url/$code';

    print("Code :" + cache['meta']['scheme_code'].toString());
    if (cache['meta']['scheme_code'] != code) {
      print("not cached");
      NetworkHelper networkHelper = NetworkHelper(url: url);
      var getMutualFundData = await networkHelper.getDate();
      cache = getMutualFundData;
    }

    List<LinkedHashMap<String, dynamic>> dateData = List.from(cache['data']);
    LinkedHashMap<String, dynamic> result =
        dateData.firstWhere((element) => element['date'] == date, orElse: () {
      return LinkedHashMap.from({"date": " ", "nav": " "});
    });

    print(result['date'] + "  " + result['nav']);

    if (result['date'] != " ") {
      mutualFundDetailObject =
          MutualFundDetailObject(date: actualDate, nav: result['nav']);
    }
    // else if()
    else {
      mutualFundDetailObject = null;
    }

    print('returning ');
    return mutualFundDetailObject;
  }
}

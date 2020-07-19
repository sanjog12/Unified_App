import 'package:firebase_database/firebase_database.dart';

class DropDownValuesHelper {
  Future<List<String>> getSectionsOfTDS() async {
    final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference dbf;

    List<String> dropDownData = [];
    dbf = firebaseDatabase.reference().child('dropDownForTDS');
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
//        print(values['value']);
        dropDownData.add(values['value']);
      });
    });
    return dropDownData;
  }

  Future<List<String>> getCompaniesOfLIC() async {
    final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference dbf;

    List<String> dropDownData = [];
    dbf = firebaseDatabase.reference().child('dropDownForLIC');
//    Stream data = dbf.onValue;
    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values['value']);
        dropDownData.add(values['value']);
      });
    });
    return dropDownData;
  }
}

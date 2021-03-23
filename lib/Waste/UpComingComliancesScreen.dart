// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:unified_reminder/models/UpComingComplianceObject.dart';
// import 'package:unified_reminder/models/client.dart';
// import 'package:unified_reminder/models/clientOptedCompliances.dart';
// import 'package:unified_reminder/services/SharedPrefs.dart';
// import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
// import 'package:unified_reminder/styles/colors.dart';
//
//
// class UpCommingComliancesScreen extends StatefulWidget {
//   final List<Client> clientList;
//
//   const UpCommingComliancesScreen({this.clientList});
//
//   @override
//   _UpComingComliancesScreenState createState() =>
//       _UpComingComliancesScreenState();
// }
//
//
//
// class _UpComingComliancesScreenState extends State<UpCommingComliancesScreen> {
//
//   final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
//
//   DatabaseReference dbf;
//
//   String firebaseUID;
//
//   List<Client> clientList = [];
//
//   List<ClientOptedCompliances> clientOptedCompliancesList = [];
//
//   bool loading = false;
//   bool list = false;
//
//   List<UpComingComplianceObject> upComingCompliancesList = [];
//
//
//
//   Future<void> temp() async{
//     firebaseUID = await SharedPrefs.getStringPreference('uid');
//     dbf = firebaseDatabase
//         .reference()
//         .child('user_clients')
// //        .child('user_compliances')
//         .child(firebaseUID)
//         .child('clients')
// //        .child('compliances')
//         ;
//
//     await dbf.once().then((DataSnapshot snapshot){
//       Map<dynamic,dynamic> map = snapshot.value;
// //      print(map.keys);
//       map.forEach((key,v) {
//         print("Key  :" + v.toString());
//
//         clientList.add(Client(
//             v["name"],
//             v["constitution"],
//             v["company"],
//             v["natureOfBusiness"],
//             v["email"].toString().replaceAll('.', ','),
//             v["phone"],
//             key
//         ),
//         );
//       });
//     });
//     print('   '+ clientList.length.toString());
//     print(clientList[1].email);
//   }
//
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     temp().whenComplete(() async{
//       // upComingCompliancesList = await UpComingComplianceDatabaseHelper().getUpComingComplincesForMonth(clientList).whenComplete((){
//       //   setState(() {
//       //     list = true;
//       //   });
//       // });
//       setState(() {
//         loading = true;
//       });
//     });
//   }
//
//
// //  static DateTime now = DateTime.now();
// //  static DateTime date = DateTime(now.year, now.month, now.day);
//
// //  static List<String> dateData = date.toString().split(' ');
// //
// //  static String fullDate = dateData[0];
// //  List<String> todayDateData = fullDate.toString().split('-');
// //  TodayDateObject todayDateObject;
// //
// //  Future<List<UpComingComplianceObject>> getUpComingComplincesForMonth() async {
// ////    todayDateObject = TodayDateObject(
// ////        year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
// //    print('values');
// //
// //    List<UpComingComplianceObject> UpComingComplinceData = [];
// //    print('values1');
// //
// //    dbf = firebaseDatabase.reference().child('upCommingComliances').child('01');
// //    print('values2');
// //
// //    await dbf.once().then((DataSnapshot snapshot) {
// //      print('values3');
// //
// //      Map<dynamic, dynamic> values = snapshot.value;
// //      print('values4');
// //
// //      values.forEach((key, values1) {
// //        print('values5');
// //
// //        print(values);
// //
// //        UpComingComplianceObject upComingComplianceObject =
// //            UpComingComplianceObject(
// //                date: values1['date'].toString(), label: values1['label']);
// //
// //        UpComingComplinceData.add(upComingComplianceObject);
// ////        print(upComingComplianceObject.amount);
// //      });
// //    });
// //    print('done');
// //    return UpComingComplinceData;
// //  }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Upcoming Compliances"),
// //       ),
// //       body: Container(
// //         padding: EdgeInsets.all(24.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: <Widget>[
// //             loading ? Expanded(
// //               child: FutureBuilder<List<UpComingComplianceObject>>(
// //                 future: UpComingComplianceDatabaseHelper()
// //                     .getUpComingComplincesForMonth(clientList),
// //                 builder: (BuildContext context,
// //                     AsyncSnapshot<List<UpComingComplianceObject>> snapshot) {
// //                   if (snapshot.hasData) {
// //                     return ListView.builder(
// //                       itemCount: snapshot.data.length,
// //                       itemBuilder: (BuildContext context, int index) {
// //                         print(snapshot.data);
// //                         return Container(
// //                           margin: EdgeInsets.symmetric(vertical: 10.0),
// //                           color: buttonColor,
// //                           child: ListTile(
// //                             title: Text(snapshot.data[index].name==null? snapshot.data[index].name==null : ' '),
// //                             subtitle: Text(
// //                                 '${snapshot.data[index].label} at ${snapshot.data[index].date}'),
// //                           ),
// //                         );
// //                       },
// //                     );
// //                   } else {
// //                     return Container(
// //                       height: 30.0,
// //                       width: 30.0,
// //                       child: Center(
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 3.0,
// //                           valueColor: AlwaysStoppedAnimation(
// //                             Colors.white,
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }
// //                 },
// //               ),
// //             ): Center(
// //               child: CircularProgressIndicator(
// //                 valueColor: AlwaysStoppedAnimation<Color>
// //                   (Colors.white),
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

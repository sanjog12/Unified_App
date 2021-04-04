import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/widgets/ListView.dart';

const String testDevice = 'FDB28FC6E21EA8FD4E1EAB3899FBD45C';

class ApplicableCompliances extends StatefulWidget {
  final Client client;
  ApplicableCompliances({this.client});
  @override
  _ApplicableCompliancesState createState() => _ApplicableCompliancesState();
}

class _ApplicableCompliancesState extends State<ApplicableCompliances> {
  
  FirestoreService firestoreService = FirestoreService();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  String firebaseUserId;
  
  @override
  void initState() {
    super.initState();
    getUserId();
    print(widget.client.toString());
    interstitialAd..load()..show();
//    bannerAd = createBannerAd()..load()..show(
//      anchorType: AnchorType.bottom,
//      horizontalCenterOffset: 10.0,
//      anchorOffset: 0.0,
//    );
  
  }
  
  
  InterstitialAd interstitialAd = InterstitialAd(
    adUnitId: 'ca-app-pub-4569649492742996~2564391573',
    request: AdRequest(),
    listener: AdListener(),
  );
//   InterstitialAd createInterstitialAd(){
//     return InterstitialAd(
//       adUnitId: 'ca-app-pub-4569649492742996/7190581030',
// //      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event){
//         print("interad " + event.toString());
//       }
//     );
//   }
  
  
  
  // static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //   testDevices: testDevice != null ?<String>[testDevice] : null,
  //   nonPersonalizedAds: true,
  //   keywords: <String>['game','mario'],
  // );

  void getUserId() async {
    var _firebaseUserId = await SharedPrefs.getStringPreference("uid");
    this.setState(() {
      firebaseUserId = _firebaseUserId;
    });
  }
  
  Future<List<Compliance>> _getUserCompliances() async {
    List<Compliance> clientsData = [];
    String clientEmail = widget.client.email.replaceAll('.', ',');

    dbf = firebaseDatabase
        .reference()
        .child(FsUserCompliances)
        .child(firebaseUserId)
        .child('compliances')
        .child(clientEmail);

    await dbf.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        Compliance compliance = Compliance(
            userEmail: values['clientEmail'],
            title: values['title'],
            value: values['value'],
            checked: null);
        clientsData.add(compliance);
      });
    });
    return clientsData;
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Applicable Compliances"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 24.0, right: 24, left: 24, bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            widget.client == null
                ? SizedBox()
                : Text(
                    "${widget.client.name}",
                    style: _theme.textTheme.headline6.merge(
                      TextStyle(
                        fontSize: 26.0,
                      ),
                    ),
                  ),
            SizedBox(
              height: 5.0,
            ),
            widget.client == null
                ? SizedBox()
                : Text(
                    "${widget.client.email}",
                    style: _theme.textTheme.bodyText2.merge(
                      TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
            SizedBox(
              height: 30.0,
            ),
            Expanded(
              child: FutureBuilder<List<Compliance>>(
                future: _getUserCompliances(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Compliance>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context,int index){
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: ExpansionTile(
                              title: Text(snapshot.data[index].title),
                              children: <Widget>[
                                listItem(snapshot.data[index].title,widget.client,context)
                              ],
                            ),
                        );
                        }
                    );
                  }else{
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>
                            (Colors.white),
                        ),
                      ),
                    );}
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

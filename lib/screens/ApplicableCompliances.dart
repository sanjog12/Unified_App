import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/widgets/ListView.dart';

const String testDevice = 'Mobile_Id';

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
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4569649492742996~2564391573');
    bannerAd = createBannerAd()..load()..show(
      anchorType: AnchorType.bottom,
      horizontalCenterOffset: 10.0,
      anchorOffset: 0.0,
    );
    interstitialAd = createInterstitialAd()..load()..show(
      anchorType: AnchorType.bottom,
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
    );
  }

  BannerAd bannerAd;
  BannerAd createBannerAd(){
    return BannerAd(
      adUnitId: 'ca-app-pub-4569649492742996/8555084850',
        size: AdSize.smartBanner,
//        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("ad " +event.toString());
        }
    );
  }
  
  InterstitialAd interstitialAd;
  InterstitialAd createInterstitialAd(){
    return InterstitialAd(
      adUnitId: 'ca-app-pub-4569649492742996/7190581030',
//      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event){
        print("interad " + event.toString());
      }
    );
  }
  
  
  
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ?<String>[testDevice] : null,
    nonPersonalizedAds: true,
    contentUrl: 'https://flutter.io',
    childDirected: false,
    keywords: <String>['game','mario'],
  );

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
  void dispose() {
    super.dispose();
    createBannerAd().dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Applicable Compliances"),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            widget.client == null
                ? SizedBox()
                : Text(
                    "${widget.client.name}",
                    style: _theme.textTheme.headline.merge(
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
                    style: _theme.textTheme.subtitle.merge(
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

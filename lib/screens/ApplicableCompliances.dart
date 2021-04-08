import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_reminder/Bloc/AdsProvider.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/widgets/ListView.dart';



class ApplicableCompliances extends StatefulWidget {
  final Client client;
  ApplicableCompliances({this.client});
  @override
  _ApplicableCompliancesState createState() => _ApplicableCompliancesState();
}

class _ApplicableCompliancesState extends State<ApplicableCompliances> {
  
  FirestoreService fireStoreService = FirestoreService();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  String firebaseUserId;
  
  BannerAd bannerAd;

  static final AdRequest request = AdRequest(
    testDevices: <String>['FDB28FC6E21EA8FD4E1EAB3899FBD45C'],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  final AdSize adSize = AdSize(width:300, height: 50);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialisation.then((status){
      setState(() {
        bannerAd = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }
  
  @override
  void initState() {
    super.initState();
    firebaseUserId = FirebaseAuth.instance.currentUser.uid;
    print(widget.client.toString());
  
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
        padding: EdgeInsets.only(top: 24.0, right: 24, left: 24,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            widget.client == null
                ? SizedBox()
                : Text(
                    "${widget.client.name}".toUpperCase(),
                    style: _theme.textTheme.headline6.merge(
                      TextStyle(
                        fontSize: 24.0,
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
            ),
            
            bannerAd == null
                ?SizedBox(height: 10,)
                :Container(height: 50, child: AdWidget(ad: bannerAd,),),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }
}

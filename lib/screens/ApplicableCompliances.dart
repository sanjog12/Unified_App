import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unified_reminder/Bloc/AdsProvider.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/Compliance.dart';
import 'package:unified_reminder/services/GeneralServices/Caching.dart';
import 'package:unified_reminder/services/GeneralServices/DocumentPaths.dart';
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
  AnimationController animationController;
  Animation animation;
  List<Compliance> listCompliances = [];
  bool loaded = false;
  GlobalKey<AnimatedListState> _myListKey = GlobalKey<AnimatedListState>();
  
  BannerAd bannerAd;

  static final AdRequest request = AdRequest(
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
    _getUserCompliances().then((value) async{
      
      listCompliances = value;
      setState(() {
        loaded = true;
      });
      await Future.delayed(Duration(milliseconds: 200));
      for(int i =0 ; i< listCompliances.length-1;i++){
        _myListKey.currentState.insertItem(i);
        await Future.delayed(Duration(milliseconds: 300));
      }
    });
    print(widget.client.toString());
  }
  
  
  
  
  Future<List<Compliance>> _getUserCompliances() async {
    List<Compliance> clientsData = [];
    String clientEmail = widget.client.email.replaceAll('.', ',');

    if(!compliancesCache.containsKey(clientEmail)) {
      print("true");
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
      compliancesCache[clientEmail] = clientsData;
    }
    else{
      print("false");
      print(compliancesCache[clientEmail]);
      clientsData = compliancesCache[clientEmail];
    }
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
                : Text("${widget.client.email}",
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
              child: AnimatedList(
                  key: _myListKey,
                  initialItemCount: listCompliances.length,
                  itemBuilder: (BuildContext context,int index,Animation animation){
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset(0, 0),
                      ).animate(animation),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: ExpansionTile(
                          title: Text(listCompliances[index].title),
                          children: <Widget>[
                            listItem(listCompliances[index].title,widget.client,context)
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            
            !loaded?Container(
              child: LinearProgressIndicator(),
            ):Container(),
                
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

import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/ApplicableCompliances.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/widgets/AppDrawer.dart';
import 'AddSingleClient.dart';

const String testDevice = 'Mobile_Id';
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference dbf;
  String firebaseUserId;
  Client client ;
  List<UpComingComplianceObject> upComingCompliancesList = [];
  bool loading = false;
  bool list = false;
  bool clientLoad = false;
  String firebaseUID;
  List<Client> clientList = [];
  ScrollController controller = ScrollController();
  GlobalKey key = GlobalKey();
  

  Future<List<Client>> _getClients() async {
    List<Client> clientsData = [];
    dbf = firebaseDatabase
        .reference()
        .child(FsUserClients)
        .child(firebaseUserId)
        .child('clients');
    await dbf.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        Client client = Client(
            values["name"],
            values["constitution"],
            values["company"],
            values["natureOfBusiness"],
            values["email"],
            values["phone"],
            key
        );
        clientsData.add(client);
      });}
    });
    return clientsData;
  }

  Future<void> temp() async{
    firebaseUID = await SharedPrefs.getStringPreference('uid');
    dbf = firebaseDatabase
        .reference()
        .child('user_clients')
        .child(firebaseUID)
        .child('clients');
    
    print(firebaseUID);
  
    await dbf.once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> map = snapshot.value;
      map.forEach((key,v) {
        print("Key  :" + v.toString());
        if(map.isNotEmpty) {
          clientList.add(Client(
              v["name"],
              v["constitution"],
              v["company"],
              v["natureOfBusiness"],
              v["email"].toString().replaceAll('.', ','),
              v["phone"],
              key
          ),
          );
        }
      });
    });
  }

//  BannerAd bannerAd;
//  BannerAd createBannerAd(){
//    return BannerAd(
////      adUnitId: 'ca-app-pub-4569649492742996/8555084850',
//      size: AdSize.smartBanner,
//      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
//      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event){
//        print("ad " +event.toString());
//      }
//    );
//  }

//  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    testDevices: testDevice != null ?<String>[testDevice] : null,
//    nonPersonalizedAds: true,
//    contentUrl: 'https://flutter.io',
//    childDirected: false,
//    keywords: <String>['game','mario'],
//  );

  @override
  void initState() {
    super.initState();
    getUserId();
    _userController = StreamController();
    temp().whenComplete(() async{
      upComingCompliancesList = await UpComingComplianceDatabaseHelper().getUpComingComplincesForMonth(clientList).whenComplete((){
        setState(() {
          list = true;
          clientLoad = true;
        });
      });
      setState(() {
        loading = true;
      });
    });
//    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4569649492742996~2564391573');
//    bannerAd = createBannerAd()..load()..show(
//      anchorType: AnchorType.bottom,
//      horizontalCenterOffset: 10.0,
//      anchorOffset: 0.0,
//    );
  }
  

  StreamController _userController;
  

  loadUser() async {
    _getClients().then((res) async {
      _userController.add(res);
      return res;
    });
  }
  

  void getUserId() async {
    var _firebaseUserId = await SharedPrefs.getStringPreference("uid");
    this.setState(() {
      firebaseUserId = _firebaseUserId;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    
    return Scaffold(
      drawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SafeArea(
            child: AppDrawer(),
          ),
        ),
      ),
      
      appBar: AppBar(
        title: Text("Unified Reminder"),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSingleClient(),
            ),
          );
        },
        backgroundColor: textboxColor,
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      
      body:
      Container(
        padding: EdgeInsets.all(24.0),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Text(
              "Your Clients",
              style: _theme.textTheme.headline.merge(
                TextStyle(
                  fontSize: 26.0,
                ),
              ),
            ),
            Text(
              "Clients you manage.",
              style: TextStyle(
                height: 1.5,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            
            ExpansionTile(
              title: Text('Upcoming Compliances'),
              children:<Widget>[
                  list?ListView.builder(
                    controller: controller,
                  scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: upComingCompliancesList.length,
                  itemBuilder: (BuildContext context,int index){
                      if(upComingCompliancesList.length != 0){
                        return upComingCompliancesList[index].label != " "?Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                )
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  SizedBox(height: 10,),
                                  Text(upComingCompliancesList[index].name !=null ? upComingCompliancesList[index].name :' ',style: TextStyle(
                                    fontSize: 15,
                                  )),
                                  
                                  Divider(
                                    thickness: 1.5,
                                  ),
                                  
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(' - ${upComingCompliancesList[index].label} due on ${upComingCompliancesList[index].date}  ${DateFormat("MMMM").format(DateTime.now())}'),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          ),
                        ):Container();
                      }
                      else{
                        return Container(
                          child: Text("Add Client First"),
                        );
                      }
                  },
              )
                : Container(
                    padding: EdgeInsets.all(10),
                    child:JumpingText("Loading.."),
                  ),],
            ),
            
            SizedBox(height: 30,),
            
            ExpansionTile(
              title: Text("Clients"),
              children:<Widget>[
                clientLoad ?Container(
                  padding: EdgeInsets.all(15),
                  child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: clientList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
//                              client = snapshot.data[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>ApplicableCompliances(
                                client: clientList[index],
                                )));
                            },
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            ),
                          title: Text(clientList[index].name.replaceFirst(clientList[index].name[0], clientList[index].name[0].toUpperCase())),
                          );
                        }),
                  )
                :Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: JumpingText("Loading..")
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
//  @override
//  void dispose() {
//    bannerAd.dispose();
//    createBannerAd().dispose();
//    super.dispose();
//  }
}

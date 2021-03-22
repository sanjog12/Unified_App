import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/compliance.dart';
// import 'package:unified_reminder/router.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/EPFScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/ESIScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/FDScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/GSTScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/IncomeTaxScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/LICScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/MFScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/PPFScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/ROCScreen.dart';
import 'file:///C:/Users/sanjo/OneDrive/Desktop/unified_reminder/lib/Waste/TDSScreen.dart';

class DashboardGrid extends StatelessWidget {
  final Compliance compliance;
  final Client client;
  final BuildContext context;
//  final String complianceName;
//  final String complianceKey;
  DashboardGrid({this.compliance, this.context, this.client});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OpenScreen(compliance.value, client);
        print(compliance.value);
      },
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white24,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.pie_chart,
                size: 48.0,
              ),
              Text(
                compliance.title,
                style: TextStyle(
                  fontSize: 18.0,
                  height: 1.5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void OpenScreen(String path, var client) {
//    print(path);
    switch (path) {
      case 'income_tax':
//        print("Going here");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IncomeTaxScreen(
              client: client,
            ),
          ),
        );
        break;
      case 'gst':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GSTScreen(
              client: client,
            ),
          ),
        );
        break;
      case 'tds':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TDSScreen(
              client: client,
            ),
          ),
        );
        break;
      case 'epf':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EPFScreen(
              client: client,
            ),
          ),
        );
        break;
      case 'esi':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ESIScreen(
              client: client,
            ),
          ),
        );
        break;
      case 'roc':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ROCScreen(
              client: client,
            ),
          ),
        );
        break;

      case 'ppf':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PPFScreen(
              client: client,
            ),
          ),
        );
        break;
      case 'fd':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FDScreen(
              client: client,
            ),
          ),
        );
        break;
      case 'lic':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LICScreen(
              client: client,
            ),
          ),
        );
        break;

      case 'mf':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MFScreen(
              client: client,
            ),
          ),
        );
        break;
//      default:
//        return SetupGSTRoute;
    }
  }
//
//  String getSuitablePath(String value) {
//    switch (value) {
//      case 'tds':
//        return TDSScreenRoute;
//      case 'income_tax':
//        return IncomeTaskScreenRoute;
//    }
//  }
}

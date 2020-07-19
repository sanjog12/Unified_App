import 'package:flutter/material.dart';
import 'package:unified_reminder/screens/AccountActivation.dart';
import 'package:unified_reminder/screens/Clients.dart';
import 'package:unified_reminder/screens/ComplianceHistory.dart';
import 'package:unified_reminder/screens/Dashboard.dart';
import 'package:unified_reminder/screens/GSTScreen.dart';
import 'package:unified_reminder/screens/IncomeTaxScreen.dart';
import 'package:unified_reminder/screens/LoginPage.dart';
import 'package:unified_reminder/screens/ManageClients.dart';
import 'package:unified_reminder/screens/RegisterPage.dart';
import 'package:unified_reminder/screens/RegisterType.dart';
import 'package:unified_reminder/screens/SelectClients.dart';
import 'package:unified_reminder/screens/TDS/Payment.dart';
import 'package:unified_reminder/screens/TDS/QuarterlyReturns.dart';
import 'package:unified_reminder/screens/TDSScreen.dart';

const LoginPageRoute = "/login";
const RegisterPageRoute = "/register";
const ActivateAccountRoute = "/activate-account";
const ApplicableCompliancesRoute = "/applicable-compliances";
const RegisterTypeRoute = "/register-type";
const SelectClientsRoute = "/select-clients";
const DashboardRoute = "/dashboard";
const TDSScreenRoute = "/tds";
const GSTScreenRoute = "/gst";
//const ESIScreenRoute = "/esi";
const ComplianceHistoryRoute = "/compliance-history";
const TDSPaymentRoute = "/tds-payment";
const TDSQuaterlyRoute = "/tds-quarterly";
const ClientsListRoute = "/client-list";
const PersonalInfoRoute = "/personal-info";
const IncomeTaskScreenRoute = "/income-task";
const ManageClientsRoute = "/manage-clients";
const SetupGSTRoute = "/setup-gst";

Route onGenerateRoute(RouteSettings settings) {
  print(settings.toString());
  switch (settings.name) {
    case LoginPageRoute:
      return MaterialPageRoute(builder: (BuildContext context) => LoginPage());
//    case RegisterPageRoute:
//      return MaterialPageRoute(
//          builder: (BuildContext context) => RegisterPage());
    case ActivateAccountRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => AccountActivation());
    case ApplicableCompliancesRoute:
//      return MaterialPageRoute(
//          builder: (BuildContext context) =>
//              ApplicableCompliances(arguments: settings.arguments));
    case RegisterTypeRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => RegisterPage());
    case SelectClientsRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) =>
              SelectClients(arguments: settings.arguments));
    case DashboardRoute:
      return MaterialPageRoute(builder: (BuildContext context) => Dashboard());
    case TDSScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => TDSScreen());
    case ComplianceHistoryRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ComplianceHistory());
    case TDSPaymentRoute:
      return MaterialPageRoute(builder: (BuildContext context) => TDSPayment());
    case TDSQuaterlyRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => TDSQuarterly());
    case ClientsListRoute:
      return MaterialPageRoute(builder: (BuildContext context) => Clients());
//    case PersonalInfoRoute:
//      return MaterialPageRoute(
//          builder: (BuildContext context) => PersonalInfo());
    case IncomeTaskScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => IncomeTaxScreen());
//    case ManageClientsRoute:
//      return MaterialPageRoute(
//          builder: (BuildContext context) =>
//              ManageClients(compliance: settings.arguments));
//    case GSTScreenRoute:
//      return MaterialPageRoute(
//          builder: (BuildContext context) =>
//              GSTScreen(arguments: settings.arguments));
//    case TDSScreenRoute:
//      return MaterialPageRoute(
//          builder: (BuildContext context) =>
//              TDSScreen(arguments: settings.arguments));
//    case IncomeTaskScreenRoute:
//      return MaterialPageRoute(
//          builder: (BuildContext context) =>
//              IncomeTaskScreen(arguments: settings.arguments));

//    default:
//      return MaterialPageRoute(builder: (BuildContext context) => LoginPage());
  }
}

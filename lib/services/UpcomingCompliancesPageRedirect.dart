

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/EPF/UpcomingCompliancesEPF.dart';
import 'package:unified_reminder/screens/ESIC/Upcomingcompliances2.dart';
import 'package:unified_reminder/screens/GST/UpcomingCompliancesGST.dart';
import 'package:unified_reminder/screens/IncomeTax/UpComingComliancesScreen.dart';
import 'package:unified_reminder/screens/LIC/UpComingComliancesScreen.dart';
import 'package:unified_reminder/screens/TDS/UpcommingCompliances2.dart';

void jumpToPage(BuildContext context, String condition, List<Client> clientList,String name){
	
	if(condition == "TDS"){
		Navigator.push(context, MaterialPageRoute(builder: (context) => UpcomingCompliancesTDS(
			client: clientList.firstWhere((element){
				return element.name == name;
			}),)));
	}
	
	else if(condition == "LIC"){
		Navigator.push(context, MaterialPageRoute(builder: (context) => UpComingCompliancesScreenForLIC(
			client: clientList.firstWhere((element){
				return element.name == name;
			}),
		)));
	}
	
	else if(condition == "Income Tax"){
		Navigator.push(context, MaterialPageRoute(builder: (context)=>UpComingComliancesScreenForIncomeTax(
				client: clientList.firstWhere((element){
					return element.name == name;
				})
		)));
	}
	
	else if(condition == "GST"){
		Navigator.push(context, MaterialPageRoute(builder: (context) => UpcomingCompliancesGST(
			client: clientList.firstWhere((element){
				return element.name == name;
			}),
		)));
	}
	
	else if(condition =="EPF"){
		Navigator.push(context, MaterialPageRoute(builder: (context)=> UpcomingCompliancesEPF(
			client: clientList.firstWhere((element){
				return element.name == name;
			}),
		)));
	}
	
	else if(condition == 'ESI'){
		Navigator.push(context, MaterialPageRoute(builder: (context)=> UpcomingCompliancesESI(
			client: clientList.firstWhere((element){
				return element.name == name;
			}),
		)));
	}
}
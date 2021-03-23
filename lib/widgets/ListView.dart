import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/EPF/ComplianceHistory.dart';
import 'package:unified_reminder/screens/EPF/UpcomingCompliancesEPF.dart';
import 'package:unified_reminder/screens/ESIC/HistoryESI.dart';
import 'package:unified_reminder/screens/ESIC/Upcomingcompliances2.dart';
import 'package:unified_reminder/screens/FD/History.dart';
import 'package:unified_reminder/screens/FD/Record.dart';
import 'package:unified_reminder/screens/GST/HistoryGST.dart';
import 'package:unified_reminder/screens/GST/UpcomingCompliancesGST.dart';
import 'package:unified_reminder/screens/IncomeTax/ComplianceHistory.dart';
import 'package:unified_reminder/screens/IncomeTax/UpComingComliancesScreen.dart';
import 'package:unified_reminder/screens/LIC/ComplianceHistoryForTDS.dart';
import 'package:unified_reminder/screens/LIC/Payment.dart';
import 'package:unified_reminder/screens/LIC/UpComingComliancesScreen.dart';
import 'package:unified_reminder/screens/MF/AddMFScreen.dart';
import 'package:unified_reminder/screens/MF/RecordDetail.dart';
import 'package:unified_reminder/screens/PPF/History.dart';
import 'package:unified_reminder/screens/PPF/Record.dart';
import 'package:unified_reminder/screens/ROC/History.dart';
import 'package:unified_reminder/screens/ROC/UpComingCompliancesScreen.dart';
import 'package:unified_reminder/screens/TDS/History.dart';
import 'package:unified_reminder/screens/TDS/UpcommingCompliances2.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';

	 FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
	 DatabaseReference dfb;
	
	 String stringDateAGM =' ';
	 bool agmRecorded = true;
	
	
	

	 Future<void> agmDate(Client client) async{
		 String firebaseUserId= await SharedPrefs.getStringPreference("uid");
		 try{
			 dfb = firebaseDatabase.reference()
					 .child('complinces')
					 .child('ROC')
					 .child(firebaseUserId)
					 .child(client.email.replaceAll('.', ','));
			 print('1');
			 await dfb.once().then((DataSnapshot snapshot){
				 print('2');
				 Map<dynamic,dynamic> values = snapshot.value;
				 print('3');
				 stringDateAGM = values.keys.first.toString();
			 });
			 print('4');
			 agmRecorded = true;
		 }catch(e){
			 print('error');
			 agmRecorded = true;
		 }
	 }


	
	Widget listItem(String item , Client client,BuildContext context) {
		switch(item){
			case 'TDS':
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.push(context,
									  MaterialPageRoute(builder: (context)=>HistoryTDS(
										  client: client,)
									  ),);
						  	},
						  	child: Text("History of Compliances"),
						  ),
						),
						
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.push(
									  context,
									  MaterialPageRoute(
										  builder: (context) => UpcomingCompliancesTDS(
											  client: client,
										  ),
									  ),
								  );
						  	},
						  	child: Text("Upcoming Compliances"),
						  ),
						),
					],
				);
				break;
				
			case "EPF":
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.of(context).push(MaterialPageRoute(
										  builder: (context) => ComplianceHistoryForEPF(
											  client: client,
										  )));
						  	},
						  	child: Text("History of Compliances"),
						  ),
						),
						
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
						  		Navigator.push(context, MaterialPageRoute(
									  builder: (context)=>UpcomingCompliancesEPF(
										  client: client,
									  )
								  ));
						  	},
						  	child: Text("Upcoming Compliances"),
						  ),
						),
//						Container(
//							padding: EdgeInsets.all(15),
//						  child: GestureDetector(
//						  	onTap: (){
//								  Navigator.push(
//										  context,
//										  MaterialPageRoute(
//												  builder: (context) => MonthlyContribution(
//													  client: client,
//												  )));
//						  	},
//						  	child: Text("Monthly Contribution"),
//						  ),
//						),
					],
				);
				break;
		
			case "Income Tax":
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.of(context).push(MaterialPageRoute(
										  builder: (context) => ComplianceHistoryForIncomeTax(
												  client: client)));
						  	},
						  	child: Text("History of Compliances"),
						  ),
						),
						
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.push(
										  context,
										  MaterialPageRoute(
												  builder: (context) =>
														  UpComingComliancesScreenForIncomeTax(
															  client: client,
														  )));
						  	},
						  	child: Text("Upcoming Compliances"),
						  ),
						),

//						Container(
//							padding: EdgeInsets.all(15),
//						  child: GestureDetector(
//						  	onTap: (){
//								  Navigator.of(context).push(MaterialPageRoute(
//										  builder: (context) => IncomeTaxPayment(
//											  client: client,
//										  )));
//						  	},
//						  	child: Text("Payment of Income Tax"),
//						  ),
//						),
					],
				);
				break;
				
			case "GST":
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding :EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.of(context).push(MaterialPageRoute(
										  builder: (context) => HistoryGST(
											  client: client,
										  )));
						  	},
						  	child: Text("History of Compliances"),
						  ),
						),
						
						Container(
							padding :EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.of(context).push(
									  MaterialPageRoute(
										  builder: (context) => UpcomingCompliancesGST(
											  client: client,
										  ),
									  ),
								  );
						  	},
						  	child: Text("Upcoming Compliances"),
						  ),
						),
					],
				);
				break;
				
			case "PPF":
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.of(context).push(MaterialPageRoute(
										  builder: (context) => HistoryForPPF(
											  client: client,
										  )));
						  	},
						  	child: Text("Portfolio of PPF",textAlign: TextAlign.justify,softWrap: true,),
						  ),
						),
						
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.push(
									  context,
									  MaterialPageRoute(
										  builder: (context) => PPFRecord(
											  client: client,
										  ),
									  ),
								  );
						  	},
						  	child: Text("Add Record",textAlign: TextAlign.justify,softWrap: true,),
						  ),
						),
					],
				);
				break;
			
			case "MUTUAL FUND":
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.of(context).push(MaterialPageRoute(
										  builder: (context) => HistoryMFTry(
											  client: client,
										  )));
						  	},
						  	child: Text("Portfolios"),
						  ),
						),
						
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.push(
									  context,
									  MaterialPageRoute(
										  builder: (context) => AddMFScreen(
											  client: client,
										  ),
									  ),
								  );
						  	},
						  	child: Text("Add Record"),
						  ),
						),
					],
				);
				break;
			
				
			case "ROC":
				agmDate(client);
				return agmRecorded?Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
							child: GestureDetector(
								onTap: () {
									Navigator.of(context).push(
										MaterialPageRoute(
											builder: (context) =>
													HistoryForROC(
														client: client,
														stringDateAGM: stringDateAGM,
													),
										),
									);},
								child: Text("History of Compliances"),
							),
						),
							
						Container(
							padding: EdgeInsets.all(15),
							child: GestureDetector(
								onTap: () {
									Navigator.of(context).push(
										MaterialPageRoute(
											builder: (context) =>
													UpComingCompliancesScreenForROC(
														client: client,
														agmRecorded: stringDateAGM == ' ' ? false : true,
														stringAGMDate: stringDateAGM,
													),
										),
									);},
								child: Text("Upcoming Compliances"),
							),
						),
					],
				):Container(
				  child: Center(child: CircularProgressIndicator(
				  	valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
				  ),),
				);
			break;
			
			case "FIXED DEPOSIT":
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.of(context).push(MaterialPageRoute(
										  builder: (context) => HistoryForFD(
											  client: client,
										  )));
						  	},
						  	child: Text("FD Portfolio"),
						  ),
						),
						
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.push(
									  context,
									  MaterialPageRoute(
										  builder: (context) => FDRecord(
											  client: client,
										  ),
									  ),
								  );
						  	},
						  	child: Text("Add record"),
						  ),
						),
					],
				);
				break;
			
			case "LIC":
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.of(context).push(MaterialPageRoute(
										  builder: (context) => ComplianceHistoryForLIC(
											  client: client,
										  )));
						  	},
						  	child: Text("Insurance Portfolio"),
						  ),
						),
						
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.push(
									  context,
									  MaterialPageRoute(
										  builder: (context) => UpComingCompliancesScreenForLIC(
											  client: client,
										  ),
									  ),
								  );
						  	},
						  	child: Text("Upcoming Premium Date"),
						  ),
						),
						Container(
							padding: EdgeInsets.all(15),
						  child: GestureDetector(
						  	onTap: (){
								  Navigator.push(
										  context,
										  MaterialPageRoute(
												  builder: (context) => LICPayment(
													  client: client,
												  )));
						  	},
						  	child: Text("Insurance Details"),
						  ),
						),
					],
				);
				break;
			
			case "ESI":
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						Container(
							padding: EdgeInsets.all(15),
							child: GestureDetector(
								onTap: (){
									Navigator.of(context).push(MaterialPageRoute(
											builder: (context) => HistoryESI(
												client: client,
											)));
								},
								child: Text("History of Compliances"),
							),
						),
						
						Container(
							padding: EdgeInsets.all(15),
							child: GestureDetector(
								onTap: (){
									Navigator.push(
											context,
											MaterialPageRoute(
													builder: (context) => UpcomingCompliancesESI(
														client: client,
													)
											)
									);
								},
								child: Text("Upcoming Compliances"),
							),
						),
					],
				);
				break;
				
			default:
				return Container();
		}
	}
	


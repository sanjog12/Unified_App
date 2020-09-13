import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/TodayDateObject.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/doneComplianceObject.dart';
import 'package:unified_reminder/screens/TDS/Payment.dart';
import 'package:unified_reminder/screens/TDS/QuarterlyReturns.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';


class UpcomingCompliancesTDS extends StatefulWidget {
	final Client client;

  const UpcomingCompliancesTDS({Key key, this.client}) : super(key: key);
  @override
  _UpcomingCompliancesTDSState createState() => _UpcomingCompliancesTDSState();
}

class _UpcomingCompliancesTDSState extends State<UpcomingCompliancesTDS> {
	final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
	DatabaseReference dbf;
	
	static DateTime now = new DateTime.now();
	static DateTime date = new DateTime(now.year, now.month, now.day);
	
	static List<String> dateData = date.toString().split(' ');
	
	static String fullDate = dateData[0];
	List<String> todayDateData = fullDate.toString().split('-');
	TodayDateObject todayDateObject;
	
	Future<List<UpComingComplianceObject>> _getUpComings() async {
		todayDateObject = TodayDateObject(
				
				year: todayDateData[0], month: todayDateData[1], day: todayDateData[2]);
		List<UpComingComplianceObject> compliancesForListView = [];
		List<UpComingComplianceObject> compliances =
		await UpComingComplianceDatabaseHelper()
				.getUpComingComplincesForMonthOfTDS(widget.client);
		
		String clientEmail = widget.client.email.replaceAll('.', ',');
		
		List<doneComplianceObject> clientDones =
		await UpComingComplianceDatabaseHelper()
				.getClientDoneCompliances(clientEmail, todayDateObject, 'TDS');
		
		compliances.forEach((element) {
			if (getSingleDone(clientDones, element.key)) {
				compliancesForListView.add(element);
			}
		});
		if (compliancesForListView.length <= 0) {
			UpComingComplianceObject upComingComplianceObject =
			UpComingComplianceObject(
					key: 'nothing',
					date: 'This Month',
					label: 'No TDS Compliance in this month');
			
			compliancesForListView.add(upComingComplianceObject);
		}
		return compliancesForListView;
	}
	
	bool getSingleDone(List<doneComplianceObject> dones, String subkey) {
		print(dones[0].key);
		if (dones[0].key != null) {
			doneComplianceObject singleDone;
			dones.forEach((element) {
				print(element.key);
				if (subkey == element.key) {
					singleDone = element;
				}
			});
			
			if (singleDone != null && singleDone.value == 'done') {
				return false;
			}
		}
		
		return true;
	}
	
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text("TDS Upcoming Compliances"),
		    actions: <Widget>[
			    helpButtonActionBar("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20TDS"),
		    ],
	    ),
	    
	    body: Container(
		      padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 70),
		      child: Column(
			      crossAxisAlignment: CrossAxisAlignment.stretch,
			      children: <Widget>[
			      	Expanded(
			      	  child: FutureBuilder<List<UpComingComplianceObject>>(
					      future: UpComingComplianceDatabaseHelper().getUpComingComplincesForMonthOfTDS(widget.client),
					      builder: (BuildContext context,AsyncSnapshot<List<UpComingComplianceObject>> snapshot){
					      	if(snapshot.hasData){
							      if(snapshot.data.length == 0){
								      return ListView(
								        children :<Widget>[
									        Container(
										        decoration: roundedCornerButton,
										        child: ListTile(
											        title: Text("No Upcoming Compliances"),
										        ),
									        ),
								        ],
								      );
							      }
					      		print(snapshot.data.length);
					      		return ListView.builder(
									          itemCount: snapshot.data.length ,
									          itemBuilder: (BuildContext context, int index){
									          	return Container(
											          padding: EdgeInsets.all(15),
									          	  child: Container(
											          decoration: roundedCornerButton,
									          	    child: ListTile(
											          title: Text(
													          '${snapshot.data[index].label} due on ${snapshot.data[index].date} '
															          '${DateFormat('MMMM').format(DateTime.now())}'
											          ),
											          onTap: (){
											          	if(snapshot.data[index].label.split(" ")[1] == "payment"){
											          		Navigator.push(context,
														          MaterialPageRoute(
															          builder: (context)=> TDSPayment(
																          client: widget.client,
															          )
														          )
													          );
												          }else{
											          		Navigator.push(context,
														          MaterialPageRoute(
															          builder: (context)=> TDSQuarterly(
																          client: widget.client,
															          )
														          )
													          );
												          }
											          },
										              ),
										            ),
										          );
									          });
					      	}else{
					      		return Container(
								      height: 30.0,
								      width: 30.0,
								      child: Center(
									      child: CircularProgressIndicator(
										      strokeWidth: 3.0,
										      valueColor: AlwaysStoppedAnimation(
											      Colors.white,
										      ),
									      ),
								      ),
							      );
						      }
					      },
				      ),
				      )
			      ],
		      ),
	    ),
    );
  }
}

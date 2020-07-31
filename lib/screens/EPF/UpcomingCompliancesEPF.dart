import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/EPF/DetailsOfContibution.dart';
import 'package:unified_reminder/screens/EPF/MonthlyContribution.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';

class UpcomingCompliancesEPF extends StatefulWidget {
	final Client client;

  const UpcomingCompliancesEPF({Key key, this.client}) : super(key: key);
	
  @override
  _UpcomingCompliancesEPFState createState() => _UpcomingCompliancesEPFState();
}

class _UpcomingCompliancesEPFState extends State<UpcomingCompliancesEPF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text("Upcoming Compliances"),
	    ),
	    
	    body: Container(
		    padding: EdgeInsets.all(15),
		    child: Container(
			    child: Column(
				    children: <Widget>[
					    Expanded(
						    child: FutureBuilder<List<UpComingComplianceObject>>(
							    future: UpComingComplianceDatabaseHelper().getUpcomingCompliancesForMonthEPF(widget.client),
							    builder: (BuildContext context, AsyncSnapshot<List<UpComingComplianceObject>> snapshot){
								    if(snapshot.hasData){
								    	if(snapshot.data.length == 0){
								    		return ListView(
											    children: <Widget>[
											    	Container(
													    margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
													    decoration: roundedCornerButton,
													    child: ListTile(
														    title: Text("No Upcoming compliances"),
													    ),
												    ),
											    ],
										    );
									    }
									    return ListView.builder(
										    itemCount: snapshot.data.length,
										    itemBuilder: (BuildContext context, int index){
										    	if(snapshot.data[index].date != 'This Month') {
												    DateTime t = DateTime.now();
												    DateTime t2 = DateTime(t.year, t.month,
														    int.parse(snapshot.data[index].date));
												    String date = DateFormat('dd MMMM').format(t2);
												    print(t2);
												    return Container(
													    margin: EdgeInsets.symmetric(vertical: 10.0),
													    decoration: roundedCornerButton,
													    child: ListTile(
														    title: Text("${snapshot.data[index].label} due on $date"),
													    onTap: (){
														    	if(snapshot.data[index].label.split(" ")[1] == "Monthly") {
																    Navigator.push(context,
																		    MaterialPageRoute(
																				    builder: (context) =>
																						    MonthlyContribution(
																							    client: widget.client,)));
															    }
														    	else if(snapshot.data[index].label.split(" ")[1] == "Detailed"){
																    Navigator.push(context,
																		    MaterialPageRoute(
																				    builder: (context) => DetailsOfContribution(
																							    client: widget.client,)));}
														    	},
													    ),
												    );
											    }else{
										    		return Container(
													    margin: EdgeInsets.symmetric(vertical: 10.0),
													    decoration: roundedCornerButton,
										    		  child: ListTile(
													    title: Text(snapshot.data[index].label),
												    ),
										    		);
											    }
										    },
									    );
								    }else{
									    return  Container(
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
	    ),
    );
  }
}

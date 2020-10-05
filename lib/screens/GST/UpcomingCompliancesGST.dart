import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/doneComplianceObject.dart';
import 'package:unified_reminder/models/UpComingComplianceObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/GST/GSTRPayment.dart';
import 'package:unified_reminder/screens/GST/ReturnFillingGST.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';

class UpcomingCompliancesGST extends StatefulWidget {
	
	final Client client;

  const UpcomingCompliancesGST({Key key, this.client}) : super(key: key);
	
  @override
  _UpcomingCompliancesGSTState createState() => _UpcomingCompliancesGSTState();
}

class _UpcomingCompliancesGSTState extends State<UpcomingCompliancesGST> {
	
	List<UpComingComplianceObject> t1 = [];
	List<doneComplianceObject> t2 = [];
	
	Future<List<UpComingComplianceObject>> getUpcoming() async{
		t1=await UpComingComplianceDatabaseHelper().getUpComingComplincesForMonthOfGST(widget.client);
//		t2 = await UpComingComplianceDatabaseHelper().getClientDoneCompliances(widget.client.email, todayDate, snapshotKey)
	}
	
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('GST Upcoming Compliances'),
		    actions: <Widget>[
		    	helpButtonActionBar("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20GST"),
		    ],
	    ),
	    
	    body: Container(
			    padding: EdgeInsets.all(24),
			    child: Column(
				    crossAxisAlignment: CrossAxisAlignment.stretch,
				    children: <Widget>[
				    	Expanded(
						    child: FutureBuilder<List<UpComingComplianceObject>>(
							    future: UpComingComplianceDatabaseHelper().getUpComingComplincesForMonthOfGST(widget.client),
							    
							    builder: (BuildContext context, AsyncSnapshot<List<UpComingComplianceObject>> snapshot){
							    	if(snapshot.hasData){
							    		if(snapshot.data.length == 0){
							    			return ListView(
											    children: <Widget>[
											    	Container(
													    decoration: roundedCornerButton,
													    child: ListTile(
														    title: Text("No Upcoming Compliances"),
													    ),
												    )
											    ],
										    );
									    }
							    		return ListView.builder(
										    itemCount: snapshot.data.length,
											  itemBuilder: (BuildContext context, int index){
										    	DateTime t = DateTime.now();
											    DateTime t2 = DateTime(t.year,t.month,int.parse(snapshot.data[index].date));
											    String date = DateFormat('dd MMMM').format(t2);
										    	print(t2);
										    	return Container(
												    decoration: roundedCornerButton,
												    margin: EdgeInsets.symmetric(vertical: 10.0),
												    child: ListTile(
													    title: Text('${snapshot.data[index].label} due on $date'),
													    onTap: (){
													    	print(snapshot.data[index].key);
													    	if(snapshot.data[index].key == 'GSTR_1_QUARTERLY'){
															    Navigator.push(context,
																	    MaterialPageRoute(
																			    builder: (context)=> GSTReturnFilling(
																				    client: widget.client,
																			    )
																	    )
															    );
														    }
													    	else {
															    Navigator.push(context,
																	    MaterialPageRoute(
																			    builder: (context) =>
																					    GSTPayment(
																						    upComingComplianceObject: snapshot.data[index],
																						    client: widget.client,
																					    )
																	    )
															    );
														    }
													    },
												    ),
											    );
											  },
									    );
								    }else{
							    		return  Container(
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
					    ),
					    SizedBox(height: 70,),
				    ],
			    ),
	    ),
    );
  }
}



import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/payment/TDSPaymentObject.dart';
import 'package:unified_reminder/screens/TDS/DetailedHistory.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
// import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';

class HistoryTDS extends StatefulWidget {
	final Client client ;

  const HistoryTDS({Key key, this.client}) : super(key: key);
	
  @override
  _HistoryTDSState createState() => _HistoryTDSState();
}

class _HistoryTDSState extends State<HistoryTDS> {
	
	final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
	DatabaseReference dbf;
	String firebaseUserId;
	
	fireUser() async{
		firebaseUserId = await SharedPrefs.getStringPreference("uid");
	}
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('TDS Payment History'),
	    ),
	    
	    body: Container(
			  padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 70),
			   child: Column(
				   crossAxisAlignment: CrossAxisAlignment.stretch,
				   children: <Widget>[
				   	Expanded(
					    child: FutureBuilder<List<HistoryComplinceObject>>(
						    future: HistoriesDatabaseHelper().getComplincesHistoryOfTDS(widget.client),
						    
						    builder: (BuildContext context ,AsyncSnapshot<List<HistoryComplinceObject>> snapshot){
						    	if(snapshot.hasData){
						    		if(snapshot.data.length !=0) {
									    return ListView.builder(
										    itemCount: snapshot.data.length,
										    itemBuilder: (BuildContext context, int index) {
											    if (snapshot.data[index].amount != '26Q' &&
													    snapshot.data[index].amount != '24Q') {
												    return Container(
													    decoration: roundedCornerButton,
													    margin: EdgeInsets.symmetric(vertical: 10.0),
													    child: ListTile(
														    title: Text(
																    snapshot.data[index].date != null ? snapshot
																		    .data[index].date : 'No Saved Record '),
														    subtitle: Text(
																    snapshot.data[index].type != null ? snapshot
																		    .data[index].type : ' '),
														    trailing: Text(
																    snapshot.data[index].amount != null
																		    ? "INR ${snapshot.data[index].amount}"
																		    : ' '),
														    onTap: () {
															    getDetailedHistory(
																	    snapshot.data[index].key.toString());
														    },
													    ),
												    );
											    } else {
												    return Container(
													    margin: EdgeInsets.symmetric(vertical: 20.0),
													    decoration: roundedCornerButton,
													    child: ListTile(
														    title: Column(
															    crossAxisAlignment: CrossAxisAlignment
																	    .stretch,
															    children: <Widget>[
																    Text("TDS return Filing",
																	    textAlign: TextAlign.center,),
																    Divider(thickness: 1,),
																    SizedBox(height: 5,),
																    Text(snapshot.data[index].date != null
																		    ? snapshot.data[index].date
																		    : 'No Saved Record '),
															    ],
														    ),
														
														    subtitle: Column(
															    crossAxisAlignment: CrossAxisAlignment
																	    .stretch,
															    children: <Widget>[
																    SizedBox(height: 5,),
																    Text(snapshot.data[index].type != null
																		    ? snapshot.data[index].type
																		    : ' '),
																    SizedBox(height: 5,)
															
															    ],
														    ),
														    onLongPress: () {
															    editRecord(snapshot.data[index]);
														    },
														    trailing: Column(
															    children: <Widget>[
																    Text(snapshot.data[index].amount != null
																		    ? snapshot.data[index].amount
																		    : ' '),
																    GestureDetector(
																	    onTap: () {
																		    showConfirmation(
																				    context, snapshot.data[index].key);
																	    },
																	    child: Icon(
																		    Icons.delete, color: Colors.red,),
																    )
															    ],
														    ),
//													        onTap: (){
//														        getDetailedHistory(snapshot.data[index].key.toString());
//													        },
													    ),
												    );
											    }
										    },
									    );
								    }else{
						    			return Column(
										    crossAxisAlignment: CrossAxisAlignment.stretch,
						    			  children: <Widget>[
						    			    Container(
										    decoration: roundedCornerButton,
						    			      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
						    			      child: ListTile(
										      title: Text('No Saved Records '),
									      ),
						    			    ),
						    			  ],
						    			);
								    }
							    }
						    	else{
						    		return Container(
									    height: 30.0,
									    width: 30.0,
									    margin: EdgeInsets.symmetric(vertical: 10.0),
									    child: Center(
										    child: CircularProgressIndicator(
											    valueColor: AlwaysStoppedAnimation<Color>
												    (Colors.white70),
										    ),
									    ),
								    );
							    }
					    },
					    ),
				    ),
				   ],
			   ),
	    ),
    );
  }
  
  Future<void> getDetailedHistory(String key) async{
  	if(key.isNotEmpty){
  		TDSPaymentObject tdsPaymentObject = TDSPaymentObject();
  		
  		tdsPaymentObject = await SingleHistoryDatabaseHelper().getTDSHistoryDetails(widget.client, key);
  		
  		if(tdsPaymentObject != null){
  		Navigator.push(context,
			  MaterialPageRoute(builder: (context)=>DetailedHistory(
				  client: widget.client,
				  tdsPaymentObject: tdsPaymentObject,
				  keyDB: key,
			  ))
		  );
		  }
	  }
  }
	
	
	Future<void> editRecord(HistoryComplinceObject historyComplinceObject) async{
		String formTypeSelected;
		DateTime selectDate = DateTime.now();
		String formNumber = historyComplinceObject.type;
//		showDate = historyComplinceObject.date;
		showDialog(
				context: context,
				builder: (context){
					String showDate = historyComplinceObject.date;
					return StatefulBuilder(
					  builder:(context,setState) {
					  	return AlertDialog(
							  title: Column(
								  children: <Widget>[
									  Text('Edit Details',style: TextStyle(fontWeight: FontWeight.bold),),
									  Divider(
										  thickness: 1.0,
									  ),
								  ],
							  ),
							
							  content: SingleChildScrollView(
								  child: Container(
										  padding: EdgeInsets.all(2),
										  child: Column(
											  crossAxisAlignment: CrossAxisAlignment.stretch,
											  children: <Widget>[
												  Text("Date of Filing"),
												  SizedBox(height: 10,),
												  Container(
													  padding: EdgeInsets.symmetric(horizontal: 10),
													  decoration: fieldsDecoration,
													  child: Row(
														  mainAxisAlignment: MainAxisAlignment.spaceBetween,
														  children: <Widget>[
															  Text(
																  '$showDate',
															  ),
															  TextButton(
																  onPressed: () async{
																	  final DateTime picked = await showDatePicker(
																			  context: context,
																			  initialDate: selectDate,
																			  firstDate: DateTime(DateTime.now().year - 1),
																			  lastDate: DateTime(DateTime.now().year + 1)
																	  );
																	
																	  if(picked != null && picked != selectDate){
																		  setState(() {
																			  selectDate = picked;
																			  print(picked);
																			  showDate = DateFormat('dd/MM/yyyy').format(picked);
																			  print(showDate);
																		  });
																	  }
																  },
																  child: Icon(Icons.date_range),
															  ),
														  ],
													  ),
												  ),
												
												  SizedBox(height: 20,),
												  Column(
													  crossAxisAlignment: CrossAxisAlignment.stretch,
													  children: <Widget>[
														  Text("Name of Form"),
														  SizedBox(
															  height: 10.0,
														  ),
														
														  DropdownButtonFormField(
															  hint: Text(historyComplinceObject.amount),
															  decoration: buildCustomInput(),
															
															  items: [
																  DropdownMenuItem(
																	  child: Text('24Q'),
																	  value: '24Q',
																  ),
																
																  DropdownMenuItem(
																	  child: Text('26Q'),
																	  value: '26Q',
																  )
															  ],
															  value: formTypeSelected,
															  onChanged: (String value){
																  setState(() {
																	  formTypeSelected = value;
																  });
															  },
														  )
													  ],
												  ),
												  SizedBox(height: 20,),
												  Column(
													  crossAxisAlignment: CrossAxisAlignment.stretch,
													  children: <Widget>[
														  Text("Acknowledgement Number"),
														  SizedBox(
															  height: 10.0,
														  ),
														  TextFormField(
															  initialValue: historyComplinceObject.type,
															  onChanged: (String value){
																  formNumber = value;
															  },
															  decoration:
															  buildCustomInput(hintText: "Challan Number"),
														  ),
													  ],
												  ),
												  SizedBox(height: 20,),
											  ],
										  )
								  ),
							  ),
							
							  actions: <Widget>[
								  TextButton(
									  child: Text('Save Changes'),
									  onPressed: () async{
										  dbf = firebaseDatabase.reference();
										  String firebaseUserId= await SharedPrefs.getStringPreference("uid");
										  dbf = firebaseDatabase.reference();
										  await dbf
												  .child('complinces')
												  .child('TDSQuarterlyReturns')
												  .child(firebaseUserId)
												  .child(widget.client.email)
												  .child(historyComplinceObject.key)
												  .update({
											  'dateOfFilledReturns':showDate,
											  'nameOfForm':formTypeSelected == null ? historyComplinceObject.amount:formTypeSelected,
											  'acknowledgementNo':formNumber,
										  });
										  Navigator.of(context).pop();
										  recordEditToast();
									  },
								  )
							  ],
						  );
					  },
					);
				}
		);
	}


  Future<void> showConfirmation(BuildContext context,String key) async{
	  return showDialog<void>(
			  context: context,
			  builder: (BuildContext context){
				  return AlertDialog(
					  title: Text('Confirm',textAlign: TextAlign.center,style: TextStyle(
						  fontWeight: FontWeight.bold,
					  ),),
					
					  shape: RoundedRectangleBorder(
						  borderRadius: BorderRadius.circular(10),
					  ),
					
					  content: SingleChildScrollView(
						  child: Column(
							  children: <Widget>[
								  SizedBox(height: 10,),
								  Text("Sure Want to Delete ?",style: TextStyle(
									  fontWeight: FontWeight.bold,
								  ),),
							  ],
						  ),
					  ),
					
					  actions: <Widget>[
						  TextButton(
							  child: Text('Yes'),
							  onPressed: () async{
								  Navigator.of(context).pop();
								  await deleteRecord(key);
								
							  },
						  ),
						
						  TextButton(
							  child: Text('No'),
							  onPressed: (){
								  Navigator.of(context).pop();
							  },
						  )
					  ],
				  );
			  }
	  );
  }


  Future<void> deleteRecord(key) async{
		
	  dbf = firebaseDatabase.reference();
	  await fireUser();
	  print(firebaseUserId);
	  print(widget.client.email);
	  print(key);
	  try {
		  await dbf
				  .child('complinces')
					.child('TDSQuarterlyReturns')
					.child(firebaseUserId)
					.child(widget.client.email)
		      .child(key)
				  .remove();
		  recordDeletedToast();
		
	  }on PlatformException catch(e){
		  Fluttertoast.showToast(
				  msg: e.message.toString(),
				  toastLength: Toast.LENGTH_SHORT,
				  gravity: ToastGravity.BOTTOM,
				  backgroundColor: Color(0xff666666),
				  textColor: Colors.white,
				  fontSize: 16.0);
	  }catch(e){
	  	print(e);
		  Fluttertoast.showToast(
				  msg: e.message.toString(),
				  toastLength: Toast.LENGTH_SHORT,
				  gravity: ToastGravity.BOTTOM,
				  backgroundColor: Color(0xff666666),
				  textColor: Colors.white,
				  fontSize: 16.0);
	  }
  }
}

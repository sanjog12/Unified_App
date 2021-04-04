import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/payment/GSTPaymentObject.dart';
import 'package:unified_reminder/screens/GST/DetailedHistory.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/PDFView.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';


class HistoryGST extends StatefulWidget {
	
	final Client client;

  const HistoryGST({Key key, this.client}) : super(key: key);
	
  @override
  _HistoryGSTState createState() => _HistoryGSTState();
}

class _HistoryGSTState extends State<HistoryGST> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('GST History'),
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
					    child: FutureBuilder<List<HistoryComplinceObject>>(
						    future: HistoriesDatabaseHelper().getComplincesHistoryOfGST(widget.client),
						    
						    builder: (BuildContext context , AsyncSnapshot<List<HistoryComplinceObject>> snapshot){
						    	if(snapshot.hasData) {
						    		print(snapshot.data.length);
						    		if(snapshot.data.length != 0) {
									    return ListView.builder(
											    itemCount: snapshot.data.length,
											    itemBuilder: (BuildContext context, int index) {
												    return Container(
													    decoration: roundedCornerButton,
													    margin: EdgeInsets.symmetric(vertical: 10.0),
													    child: ListTile(
														    title: Text(
																    snapshot.data[index].date != null ? snapshot
																		    .data[index].date : 'No Saved Record '),
														    contentPadding: EdgeInsets.all(5),
														    subtitle: Column(
															    crossAxisAlignment: CrossAxisAlignment.start,
															    children: <Widget>[
																    SizedBox(height: 10,),
																    Text(
																		    snapshot.data[index].type != null
																				    ? snapshot
																				    .data[index].type
																				    : ' '),
																    
																    snapshot.data[index].type ==
																		    'GSTR_1_QUARTERLY' ? Text(
																	    "Tap to see challan if any",
																	    style: TextStyle(
																			    fontStyle: FontStyle.italic,
																			    fontSize: 10
																	    ),) : Text(""),
															    ],
														    ),
														    trailing: snapshot.data[index].type ==
																    'GSTR_1_QUARTERLY' ? Text('') : Text(
																    snapshot.data[index].amount != null
																		    ? snapshot
																		    .data[index].amount
																		    : ' '),
														    onTap: () {
															    if (snapshot.data[index].type ==
																	    'GSTR_1_QUARTERLY' ) {
															    	if(snapshot.data[index].amount != 'null') {
																	    Navigator.push(context,
																			    MaterialPageRoute(
																					    builder: (context) =>
																							    PDFViewer(
																								    pdf: snapshot.data[index]
																										    .amount,
																							    )
																			    )
																	    );
																    }
															    	else{
																	    // Fluttertoast.showToast(
																			//     msg:"No File Were Uploaded",
																			//     toastLength: Toast.LENGTH_SHORT,
																			//     gravity: ToastGravity.BOTTOM,
																			//     backgroundColor: Color(0xff666666),
																			//     textColor: Colors.white,
																			//     fontSize: 16.0);
																    }
															    }
															    else {
																    detailedView(snapshot.data[index].key);
															    }
														    },
													    ),
												    );
											    }
									    );
								    }else{
						    			return Container(
										    decoration: roundedCornerButton,
										    margin: EdgeInsets.symmetric(vertical: 10.0),
						    			  child: ListTile(
											    title: Text("No Record Found"),
						    			  ),
						    			);
								    }
							    }else{
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
				    SizedBox(height: 70,),
			    ],
	      ),
	    ),
    );
  }
  
  Future<void> detailedView(String key) async{
  	print("key  " + key);
  	if(key != null){
  		GSTPaymentObject gstPaymentObject = await SingleHistoryDatabaseHelper().getGSTHistoryDetails(widget.client, key);
  		print(gstPaymentObject.amountOfPayment);
  		Navigator.push(context,
			  MaterialPageRoute(
				  builder: (context)=>DetailedHistoryGst(
					  client: widget.client,
					  gstPaymentObject: gstPaymentObject,
					  keyBD: key,
				  )
			  )
		  );
	  }else{
  		print('Error in GST History Screen');
	  }
  }
  
}

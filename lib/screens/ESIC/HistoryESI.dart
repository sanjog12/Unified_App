import 'package:flutter/material.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/history/HistoryComplinceObjectForTDS.dart';
import 'package:unified_reminder/models/payment/ESIMonthlyContributionObejct.dart';
import 'package:unified_reminder/screens/ESIC/DetailedHistoryESI.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';


class HistoryESI extends StatefulWidget {
	final Client client;

  const HistoryESI({Key key, this.client}) : super(key: key);
	
  @override
  _HistoryESIState createState() => _HistoryESIState();
}

class _HistoryESIState extends State<HistoryESI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('ESI Payment History'),
		    actions: <Widget>[
			    helpButtonActionBar("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20ESI"),
		    ],
	    ),
	    
	    body: Container(
		    padding: EdgeInsets.all(20),
			    child: Column(
				    crossAxisAlignment: CrossAxisAlignment.stretch,
				    
				    children: <Widget>[
				    	Expanded(
						    child: FutureBuilder<List<HistoryComplinceObject>>(
							    future: HistoriesDatabaseHelper().getComplincesHistoryOfESI(widget.client),
							    builder: (BuildContext context , AsyncSnapshot<List<HistoryComplinceObject>> snapshot){
							    	
							    	if(snapshot.hasData){
							    		return ListView.builder(
											    itemCount: snapshot.data.length,
											    itemBuilder: (BuildContext context , int index){
											    	return Container(
													    decoration: roundedCornerButton,
													    margin: EdgeInsets.symmetric(vertical: 10),
													    child: ListTile(
														    title: Text(snapshot.data[index].date != null ?snapshot.data[index].date : 'No record'),
														    subtitle: Text(snapshot.data[index].type != null?snapshot.data[index].type:' '),
														    trailing: Text(snapshot.data[index].amount !=null? snapshot.data[index].amount : ' '),
														    onTap: (){
														    	getCompleteDetails(snapshot.data[index].key);
														    },
													    ),
												    );
											    }
								      );
								    }
							    	
							    	else{
							    		return Container(
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
  
  
  Future<void> getCompleteDetails(String key) async{
  	if(key.isNotEmpty){
  		ESIMonthlyContributionObejct esiMonthlyContributionObejct = ESIMonthlyContributionObejct();
  		
  		esiMonthlyContributionObejct = await SingleHistoryDatabaseHelper().getESIHistoryDetails(widget.client, key);
  		if(esiMonthlyContributionObejct != null){
  			print("add attachment");
  			print(esiMonthlyContributionObejct.addAttachment);
  			Navigator.push(
					  context,
					  MaterialPageRoute(
						  builder: (context) => DetailedHistoryESI(
							  client: widget.client,
							  esiMonthlyContributionObejct: esiMonthlyContributionObejct,
							  keyDB: key,
						  )
					  )
			  ).whenComplete((){setState(() {});});
		  }
  		
	  }
  	
  }
}


import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/history/HistoryMF.dart';
import 'package:unified_reminder/screens/MF/RecordDetails.dart';
import 'package:unified_reminder/services/HistoriesDatabaseHelper.dart';
import 'package:unified_reminder/services/MutualFundHelper.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateChange.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';

HashMap<String,MutualFundDetailObject> storedNav = HashMap<String,MutualFundDetailObject>();

class MfRecords extends StatefulWidget {
	final Client client;
  const MfRecords({Key key, this.client}) : super(key: key);
	
  @override
  _MfRecordsState createState() => _MfRecordsState();
}

class _MfRecordsState extends State<MfRecords> {
	
	
	List<HistoryForMF> history = [];
	bool gotHistory = false;
	bool units = false;
	bool loadAmount = true;
	bool loadingNav = true;
	bool confirmation = false;
	List<String> listOfTotalUnits = [];
	List<String> deletedDateList = [];
	List<double> period = [];
	
	List<MutualFundDetailObject> mutualFund = [];
	List<MutualFundDetailObject> temp = [];
	int iterations;
	double totalUnits;
	
	
	Future<void> totalUnitsCalculate() async{
		print("total Units Calculate");
		print(history.length);
		for(int index =0 ; index< history.length;index++) {
			// print(index);
			double amount = double.parse(history[index].amount);
			// print("amount :"+amount.toString());
			if (history[index].type == "Lump sum") {
				// print('lump sum');
				double totalUnite = double.parse(history[index].amount)/double.parse(history[index].mutualFundDetailObject.nav);
				print(totalUnite);
				setState(() {
					listOfTotalUnits[index]= totalUnite.toStringAsFixed(4);
					period[index]=amount*1;
				});
				print(double.parse(listOfTotalUnits[index]));
			}
			else {
				// print('else');
				await getDeletedDateData(index);
				// print("else 2");
				double d=0;
				for(var v in mutualFund){
					print(v.nav);
					d = d + amount /double.parse(v.nav);
				}
				// print(d.toStringAsFixed(4));
				setState(() {
					listOfTotalUnits[index] = d.toStringAsFixed(4);
					period[index] = mutualFund.length*amount;
					// print(period[index]);
				});
			}
		}
	}
	
	Future<void> getObject() async{
		// print("Calling");
		history = await  HistoriesDatabaseHelper().getHistoryOfFMRecordTry(widget.client);
		setState(() {
		  gotHistory = true;
		});
	}
	
	
	Future<void> getDeletedDateData(int index) async {
		deletedDateList = await SingleHistoryDatabaseHelper().getDeletedRecordDates(widget.client, history[index].keyDate);
		// print(deletedDateList);
		
		iterations = int.parse(history[index].mutualFundObject.numberOfInstalments);
		// print('Iteration'+ iterations.toString());
		temp = await getNAV(history[index].mutualFundObject.code, history[index].mutualFundDetailObject.date,
				iterations, deletedDateList);
		
//		temp.removeLast();
		
		setState((){
			mutualFund = temp;
			loadingNav = false;
			loadAmount = false;
		});
		
	}
	
	@override
  void initState() {
    super.initState();
    getObject().whenComplete((){
    	// print("when Completed");
    	// print(history.length);
    	listOfTotalUnits = List.filled(history.length, "null");
    	// print("1");
    	period = List.filled(history.length, null);
    	// print("2");
    	totalUnitsCalculate();
    	// print("back");
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text("Mutual Funds PortFolios"),
	    ),
	    
	    body: history.length != 0?Container(
		    padding: EdgeInsets.all(20),
		    child: gotHistory ? Container(
				    child: ListView.builder(
					    itemCount: history.length,
						    itemBuilder: (BuildContext context, index){
					    	return Container(
							    decoration: BoxDecoration(
									    borderRadius: BorderRadius.circular(10)
							    ),
							    padding: EdgeInsets.all(10),
							    child: Container(
								    decoration: roundedCornerButton,
								    child: history.length != 0?ListTile(
									    title: Column(
										    crossAxisAlignment: CrossAxisAlignment.stretch,
									      children: <Widget>[
									      	Container(
											      height: 10,
											      color: listOfTotalUnits[index] != 'null'?(double.parse(listOfTotalUnits[index])*double.parse(history[index].todayNAV.nav))-
													      period[index] <0?Colors.red:Colors.green:Colors.blueGrey,
										      ),
									        
									        SizedBox(height: 10,),
									        
									        Text(history[index].mutualFundObject.name != null?
										    history[index].mutualFundObject.name:"No Portfolio Found",style: TextStyle(color: Colors.white),),
									      ],
									    ),
									    
									    subtitle: Column(
										    crossAxisAlignment: CrossAxisAlignment.stretch,
										    children: <Widget>[
										    	SizedBox(height: 10,),
											    Divider(thickness: 1.5,),
											    history[index].mutualFundObject.name != "No Record Found" ?Row(
												    mainAxisAlignment: MainAxisAlignment.spaceBetween,
											      children: <Widget>[
											    	  Column(
													      children: <Widget>[
														      Text("Current NAV:",style: TextStyle(fontWeight: FontWeight.bold),),
														      SizedBox(height: 5,),
														      Text(history[index].todayNAV.nav),
													      ],
												      ),
												      Column(
													      children: <Widget>[
														      Text("Total Units:",style: TextStyle(fontWeight: FontWeight.bold)),
														      SizedBox(height: 5,),
														      listOfTotalUnits[index] != 'null'?Text(listOfTotalUnits[index]):JumpingDotsProgressIndicator(
															      fontSize: 30,
															      color: Colors.white,
															      numberOfDots: 4,
														      ),
													      ],
												      ),
											      ],
										      ):Container(),
										    
										      SizedBox(height: 15,),
											    
											    history[index].mutualFundObject.name != "No Record Found" ?Row(
											      children: <Widget>[
												      Text("Total Investment: ",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
												      SizedBox(width: 10,),
												      period[index] != null
														      ?Text(period[index].toString(),textAlign: TextAlign.start)
														      :JumpingDotsProgressIndicator(
													      color: Colors.white,
													      fontSize: 30,
													      numberOfDots: 4,
												      ),
												      SizedBox(height: 5,),
											      ],
										      ):Container(),
										    
										      SizedBox(height: 15,),
											    
											    history[index].mutualFundObject.name != "No Record Found" ?Row(
											      children: <Widget>[
												      Text("Current Value: ",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.start),
												      SizedBox(width: 10,),
												      listOfTotalUnits[index] != 'null'
														      ?Text((double.parse(listOfTotalUnits[index])*double.parse(history[index].todayNAV.nav)).toStringAsFixed(4),
														      textAlign: TextAlign.end)
														      :JumpingDotsProgressIndicator(
													      fontSize: 30,
													      color: Colors.white,
													      numberOfDots: 4,
												      ),
												      SizedBox(width: 7,),
												      listOfTotalUnits[index] != 'null'?Text((double.parse(listOfTotalUnits[index])*double.parse(history[index].todayNAV.nav))-
														      period[index]<0 ?
												      ((double.parse(listOfTotalUnits[index])*double.parse(history[index].todayNAV.nav))- period[index]).toStringAsFixed(3)
														      :"+"+ ((double.parse(listOfTotalUnits[index])*double.parse(history[index].todayNAV.nav)) - period[index]).toStringAsFixed(3),
													      
													      style: TextStyle(color: (double.parse(listOfTotalUnits[index])*double.parse(history[index].todayNAV.nav))-
															      period[index] <0?Colors.red:Colors.green,fontSize: 12),
													      textAlign: TextAlign.end,
												      )
														      :Text(""),
											      ],
										      ):Container(),
											    SizedBox(height: 10,)
									      ],
								      ),
									    onTap: (){
									    	if(period[index] == null){
									    		flutterToast(message: "Your portfolio is being calculated ... please wait");
									    		return null;
										    }
									    	Navigator.push(context,
											    MaterialPageRoute(
												    builder:(context)=>RecordDetail(
													    storedNav: storedNav,
													    client: widget.client,
													    historyForMF: history[index],
													    totalInvestment: period[index].toString(),
													    currentValue: (double.parse(listOfTotalUnits[index])*double.parse(history[index].todayNAV.nav)).toStringAsFixed(4),
													    totalUnits: listOfTotalUnits[index],
												    )
											    ),
										    );
									    },
							      ):ListTile(
									    title: Text("No record found"),
								    ),
							    ),
						    );
					    }
					    ),
		    ):Container(
				    padding: EdgeInsets.all(10),
				    child: Center(
					    child: CircularProgressIndicator(
						    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
					    ),
				    ),
		    ),
	    ):Container(
		    padding: EdgeInsets.all(10),
		    child: Center(
			    child: CircularProgressIndicator(
				    valueColor: AlwaysStoppedAnimation<Color>
					    (Colors.white),
			    ),
		    ),
	    ),
    );
  }
	
	
	
	Future<List<MutualFundDetailObject>> getNAV(String code, String actualDate, int maxIteration, List<String> deletedList) async {
		String tempDate;
		List<MutualFundDetailObject> listMfDetails = [];
		MutualFundDetailObject mfDetails = MutualFundDetailObject();
		print(mfDetails);
		int countIteration=0;
		
		while (mfDetails != null) {
			if (countIteration >= maxIteration)
				break;
			tempDate = actualDate;
			
			if(!storedNav.containsKey(tempDate + code)) {
				for (int i = 0; i < 4; i++) {
					// print(tempDate);
					mfDetails =
					await MutualFundHelper().getMutualFundNAV(code, tempDate, actualDate);
					if (mfDetails != null)
						break;
					else
						tempDate = DateChange.addDayToDate(tempDate, 1);
				}
				
				
				if (mfDetails != null) {
					if (!deletedList.contains(mfDetails.date)) {
						listMfDetails.add(mfDetails);
						
						// print(mfDetails.date + code);
						storedNav[mfDetails.date + code] = mfDetails;
					}
				}
			}else{
				listMfDetails.add(
						MutualFundDetailObject(date: storedNav[tempDate + code].date, nav: storedNav[tempDate + code].nav)
				);
			}
			actualDate = DateChange.addMonthToDate(actualDate,1);
			countIteration++;
		}
		return listMfDetails;
	}
	
}

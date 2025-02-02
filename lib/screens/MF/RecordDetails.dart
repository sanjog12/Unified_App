import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/history/HistoryMF.dart';
import 'package:unified_reminder/services/MutualFundHelper.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/services/SingleHistoryDatabaseHelper.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateChange.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';



class RecordDetail extends StatefulWidget {
	
	final HashMap<String,MutualFundDetailObject> storedNav;
	final HistoryForMF historyForMF ;
	final Client client;
	final String totalUnits;
	final String currentValue;
	final String totalInvestment;

  const RecordDetail({Key key, this.historyForMF, this.currentValue, this.totalUnits, this.totalInvestment, this.client, this.storedNav}) : super(key: key);
  
  @override
  _RecordDetailState createState() => _RecordDetailState();
}


class _RecordDetailState extends State<RecordDetail> {
	
	int iterations =10 ;
	double progressIndicator = 0.0;
	bool loadingNav = true;
	bool loadDelete = false;
	bool confirmation = false;
	bool waiting = true;
	String firebaseUserId;
	List<MutualFundDetailObject> mutualFund = [];
	List<MutualFundDetailObject> mutualFundTemp = [];
	List<MutualFundDetailObject> temp = [];
	List<String> deletedDateList = [];
	final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
	DatabaseReference dbf;
	
	
	@override
	void initState() {
		super.initState();
		print(widget.historyForMF.type);
	}
	
	getListOfNav() async* {
		temp.removeLast();
		setState((){
		  mutualFund = temp;
		  loadingNav = false;
		});
		print('Size of ' + mutualFund.length.toString());
	}
	
	fireUser() async{
		firebaseUserId = await SharedPrefs.getStringPreference("uid");
	}
	
	
	Icon getIcon(int index){
		double t1 = double.parse(mutualFund[index].nav);
		double t2 = double.parse(mutualFund[index==0?index:index-1].nav);
		
		if(t1<t2){
			return Icon(Icons.arrow_downward,color: Colors.red,) ;
		}
		
		else if(t1>t2){
			return Icon(Icons.arrow_upward,color: Colors.green,);
		}
		
		else{
			return Icon(Icons.star);
		}
	}
	
	
	Future<void> deleteRecord(int index , BuildContext context) async{
		
		showDialog<void>(
			context: context,
			builder: (BuildContext context) {
				if(waiting){
				return AlertDialog(
					title: Text('Confirmation', style: TextStyle(
						fontWeight: FontWeight.bold,
					
					),),
					
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(10),
					),
					content: SingleChildScrollView(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: <Widget>[
								SizedBox(height: 10,),
								Text("Delete Record of ${mutualFund[index].date} ?")
							],
						),
					),
					actions: <Widget>[
						Row(
							children: <Widget>[
								TextButton(
									child: Text("Yes"),
									onPressed: () async{
										try {
											setState(() {
												waiting = false;
											});
											await SingleHistoryDatabaseHelper().deletRecordMF(
													widget.historyForMF.keyDate, widget.client, mutualFund[index].date);
											
											setState(() {
												waiting = false;
												mutualFund.removeAt(index);
											});
											Navigator.pop(context);
											print("Successful");
										}catch(e){
											print(e);
										}
										
										setState(() {
											waiting = true;
										});
									},
								),
								
								TextButton(
									child: Text("No"),
									onPressed: () {
										setState(() {
											confirmation = false;
										});
										Navigator.of(context).pop();
									},
								),
							],
						)
					],
				);
			}else{
				return Center(child: CircularProgressIndicator(
					valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
				),);
				}
			}
			);
	}
	
	
	
	@override
	Widget build(BuildContext context) {
		final ThemeData _themeData = Theme.of(context);
		
		
		return Scaffold(
			appBar: AppBar(
				title: Text("MF Portfolio Details"),
				actions: <Widget>[
					GestureDetector(
						onTap:() {
							showConfirmation(context);
						},
						child: Icon(Icons.delete,color: Colors.red,),
					)
				],
			),
			body: SingleChildScrollView(
				child: Container(
					padding: EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 70),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: <Widget>[
							Text(
								'${widget.client.name}\'s Mutual Fund Record',
								style: _themeData.textTheme.headline6.merge(TextStyle(
									fontSize: 26.0,
								)),
							),
							
							SizedBox(
								height: 30,
							),
							
							Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: <Widget>[
									Text("Mutual Fund Name"),
									SizedBox(
										height: 10,
									),
									
									Container(
										padding: EdgeInsets.all(15),
										decoration: fieldsDecoration,
										child: Text(
											'${widget.historyForMF.mutualFundObject.name}',
											style: TextStyle(
													color: whiteColor
											),
										),
									)
								],
							),
							
							SizedBox(
								height: 30,
							),
							
							Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: <Widget>[
									Text("Type"),
									SizedBox(
										height: 10,
									),
									
									Container(
										padding: EdgeInsets.all(15),
										decoration: fieldsDecoration,
										child: Text(
											'${widget.historyForMF.type}',
											style: TextStyle(
													color: whiteColor
											),
										),
									)
								],
							),
							
							SizedBox(
								height: 30,
							),
							
							Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: <Widget>[
									Text("Amount every month"),
									
									SizedBox(
										height: 10,
									),
									
									Container(
										padding: EdgeInsets.all(15),
										decoration: fieldsDecoration,
										child: Text(
											widget.historyForMF.amount,
											style: TextStyle(
												color: whiteColor,
											),
										),
									),
									
									SizedBox(
										height: 30,
									),
									
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											Text("Number of Installment"),
											
											SizedBox(
												height: 10,
											),
											
											Container(
												padding: EdgeInsets.all(15),
												decoration: fieldsDecoration,
												child: Text(
													widget.historyForMF.mutualFundObject.numberOfInstalments,
													style: TextStyle(
														color: whiteColor,
													),
												),
											),
											],),
											
											SizedBox(
												height: 30,
											),
									
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											Text("Starting Date"),
											SizedBox(
												height: 10,
											),
											
											Container(
												padding: EdgeInsets.all(15),
												decoration: fieldsDecoration,
												child: Text(
														'${widget.historyForMF
																.mutualFundDetailObject.date}'
												),
											)
										],
									),
									
									SizedBox(
										height: 30,
									),
									
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											Text("NAV value on ${widget.historyForMF
													.mutualFundDetailObject.date}"),
											SizedBox(
												height: 10,
											),
											
											Container(
												padding: EdgeInsets.all(15),
												decoration: fieldsDecoration,
												child: Text(
														'${widget.historyForMF
																.mutualFundDetailObject.nav}'
												),
											)
										],
									),
									
									SizedBox(
										height: 30,
									),
									
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											Text("NAV value on ${widget.historyForMF
													.todayNAV.date}"),
											SizedBox(
												height: 10,
											),
											Container(
												padding: EdgeInsets.all(15),
												decoration: fieldsDecoration,
												child: Text(
														'${widget.historyForMF
																.todayNAV.nav}'
												),
											)
										],
									),
									
									SizedBox(height: 30,),
									
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											Text("Total Units"),
											SizedBox(
												height: 10,
											),
											Container(
												padding: EdgeInsets.all(15),
												decoration: fieldsDecoration,
												child: Text(
														'${widget.totalUnits}'
												),
											)
										],
									),
									
									SizedBox(height: 30),
									
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											Text("Total Investment"),
											SizedBox(
												height: 10,
											),
											Container(
												padding: EdgeInsets.all(15),
												decoration: fieldsDecoration,
												child: Text(
														'${widget.totalInvestment}'
												),
											)
										],
									),
									
									SizedBox(height: 30),
									
									Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											Text("Current Value"),
											SizedBox(
												height: 10,
											),
											Container(
												padding: EdgeInsets.all(15),
												decoration: fieldsDecoration,
												child: Row(
												  children: <Widget>[
												    Text(
												    		'${widget.currentValue}'
												    ),
													  SizedBox(width: 10,),
													  Text(double.parse(widget.currentValue)-double.parse(widget.totalInvestment) <0 ?'':'+',style: TextStyle(
														  fontSize: 12,
														  color: double.parse(widget.currentValue)-double.parse(widget.totalInvestment) <0 ?Colors.red:Colors.green,
													  ),),
													  Text('${(double.parse(widget.currentValue)-double.parse(widget.totalInvestment)).toStringAsFixed(4)}',style: TextStyle(
														  fontSize: 12,
														  color: double.parse(widget.currentValue)-double.parse(widget.totalInvestment) <0 ?Colors.red:Colors.green,
													  ),)
												  ],
												),
											)
										],
									),
									
									SizedBox(height: 30),
									
									widget.historyForMF.type == 'SIP' ?
									StreamBuilder<List<MutualFundDetailObject>>(
										stream: getNAV(),
										builder: (BuildContext context, AsyncSnapshot<List<MutualFundDetailObject>> snapShot){
											if(snapShot.hasData){
											return Column(
												crossAxisAlignment: CrossAxisAlignment.stretch,
											  children: <Widget>[
											    SingleChildScrollView(
											    	child: DataTable(
													    columnSpacing: 2,
													    columns: [
													    	DataColumn(label: Text("Date",style: TextStyle(
															    fontWeight: FontWeight.bold,
															    fontSize: 15,
														    ),),),

														    DataColumn(label: Text(" ")),
														    DataColumn(label: Text("NAV",style: TextStyle(
															    fontWeight: FontWeight.bold,
															    fontSize: 15,
														    ),)),
													    ],

													    rows: mutualFund.asMap().map((i,mutual) => MapEntry(i,DataRow(
															    selected: mutualFundTemp.contains(mutual),
															    cells: [
															    	DataCell(
																	    Text(mutual.date),
																    ),
																    DataCell(i==0? Container() :TextButton(child: Icon(Icons.delete , color: Colors.red),
																	    onPressed: (){
																    	deleteRecord(i,context);
																    	},)
																    ),

																    DataCell(
																	    Row(
																		    children: <Widget>[
																		    	Text(mutual.nav),
																			    i==0? Container() :getIcon(i),
																		    ],
																	    ),
																    )
															    ]
													    )
													    )).values.toList(),
												    ),
											    ),
												  SizedBox(height: 30,)
											  ],
											);}
											return CircularProgressIndicator();
											},
									): Container(),
									
									// widget.historyForMF.type == 'SIP' ?
									// 		Container(
									// 			height: 100,
									// 		  child: LineChart(
									// 		  	LineChartData(
									// 		  		minX: 0,
									// 		  		maxX: 100,
									// 				  minY: 0,
									// 				  maxY: 100,
									// 		  		lineBarsData: [
									// 		  			LineChartBarData(
									// 		  				spots: [
									// 		  					FlSpot(10,10),
									// 		  					FlSpot(20,10),
									// 		  					FlSpot(30,10),
									// 		  				]
									// 		  			)
									// 		  		],
									// 		  	)
									// 		  ),
									// 		)
									// 		:Container(),
								
								],
							),
							
							SizedBox(height: 70,),
						],
					),
				),
			),
		);
	}
	
	
	Stream<List<MutualFundDetailObject>> getNAV() async* {
		String code = widget.historyForMF.mutualFundObject.code;
		String startDate = widget.historyForMF.mutualFundDetailObject.date;
		deletedDateList = await SingleHistoryDatabaseHelper().getDeletedRecordDates(widget.client, widget.historyForMF.keyDate);
		iterations = int.parse(widget.historyForMF.mutualFundObject.numberOfInstalments);
		
		String tempDate;
		MutualFundDetailObject mutualFundDetailObject = MutualFundDetailObject();
		print(mutualFundDetailObject);
		int countInstallment=0;
		while (mutualFundDetailObject != null) {
			if (countInstallment >= iterations)
				break;
			tempDate = startDate;
			for (int i = 0; i < 3; i++) {
				if(widget.storedNav.containsKey(tempDate+code)){
					mutualFundDetailObject = widget.storedNav[tempDate+code];
				}
				else {
					mutualFundDetailObject =
					await MutualFundHelper().getMutualFundNAV(code, tempDate, startDate);
				}
				
				if (mutualFundDetailObject != null)
					break;
				else
					tempDate = DateChange.addDayToDate(tempDate, 1);
			}
			if (mutualFundDetailObject != null){
				if (!deletedDateList.contains(mutualFundDetailObject.date)) {
					mutualFund.add(mutualFundDetailObject);
				}
		}
			startDate = DateChange.addMonthToDate(startDate,1);
			countInstallment++;
			yield mutualFund;
		}
  }
	
	Future<void> showConfirmation(BuildContext context) async{
		loadDelete = true;
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
									await deletePortfolio();
									Navigator.of(context).pop();
									Navigator.pop(context);
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
	
	
	Future<void> deletePortfolio() async{
		dbf = firebaseDatabase.reference();
		await fireUser();
		print(firebaseUserId);
		print(widget.client.email);
		print(widget.historyForMF.key);
		try {
			try {
				await dbf
						.child('complinces')
						.child('MFRecordHelper')
						.child(firebaseUserId)
						.child(widget.client.email)
						.child(widget.client.email)
						.child(widget.historyForMF.keyDate)
						.remove();
				dbf = firebaseDatabase.reference();
			}catch(e){
				print(e);
			}
			await dbf
					.child('complinces')
					.child('MFRecord')
					.child(firebaseUserId)
					.child(widget.client.email)
					.child(widget.historyForMF.key)
					.remove();
			
			recordDeletedToast();
			Navigator.pop(context);
//			Navigator.pop(context);
//			Navigator.push(context,
//				MaterialPageRoute(
//					builder: (context)=> HistoryMFTry(
//						client: widget.client,
//					)
//				)
//			);
			
		}on PlatformException catch(e){
			print(e.message);
			flutterToast(message: e.message);
		}catch(e){
			print(e);
			flutterToast(message: "Something wrong");
		}
	}
}

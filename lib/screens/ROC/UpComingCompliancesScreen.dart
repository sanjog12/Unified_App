import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/services/NotificationWork.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateChange.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';


class UpComingCompliancesScreenForROC extends StatefulWidget {
	
	final Client client;
	bool agmRecorded;
	String stringAGMDate;
  UpComingCompliancesScreenForROC({Key key, this.client,this.agmRecorded,this.stringAGMDate}) : super(key: key);
	
  @override
  _UpComingCompliancesScreenForROCState createState() => _UpComingCompliancesScreenForROCState();
}



class _UpComingCompliancesScreenForROCState extends State<UpComingCompliancesScreenForROC> {
	
	FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
	DatabaseReference dfb;
	
	
	GlobalKey<FormState> rocFromKey = GlobalKey<FormState>();
	
	String tempDate = "Select Date";
	
	String _selectedDateOfAgm = 'Select Date';
	DateTime selectedDateOfAgmSubmission = DateTime.now();

	bool buttonLoading = false;
	bool loading = false;
	bool adt = true;
	bool aoc = true;
	bool aoc_4 = true;
	bool mgt_7 = true;
	bool cra_4 = true;
	bool mgt_14 = true;
	
	
	String tableDateUse = ' ';
	NotificationServices notificationServices = NotificationServices();
	
	
	
	GestureDetector makeWidget(String formType, int days) {
	 	String date = DateChange.addDayToDate(widget.stringAGMDate, days);
		return GestureDetector(
			onTap: () async{
				await dialogSRNofForms(formType, context);
				
				flutterToast(message: "Successfully Saved");
				setState(() {
				});
			},
		  child: Container(
		  	decoration: roundedCornerButton,
		  	child: Container(
		  		padding: EdgeInsets.all(8),
		  		child: Column(
		  			crossAxisAlignment: CrossAxisAlignment.stretch,
		  			children: <Widget>[
		  				Text(formType ,textAlign: TextAlign.center,style: TextStyle(
		  					fontWeight: FontWeight.bold,
		  				),),
		  				Divider(
		  					thickness: 0.5,
		  					color: Colors.white70,
		  				),
		  				SizedBox(height: 15,),
		  				Row(
		  					mainAxisAlignment: MainAxisAlignment.spaceBetween,
		  				  children: <Widget>[
		  				    Text("Due Date :",textAlign:TextAlign.start,style: TextStyle(
							      fontWeight: FontWeight.bold,
		  				    ),),
		  					  
		  					  
		  					  Text(date,textAlign: TextAlign.end,style: TextStyle(
								    fontWeight: FontWeight.bold,
							    ),),
							    
							    
		  				  ],
		  				),
						  
						  SizedBox(height: 5,),
						  
						  Text('Tap to Enter SRN & Date of Filing',style: TextStyle(
							  fontStyle: FontStyle.italic,
							  fontSize: 8,
						  ),),
						  
						  SizedBox(height: 70,)
		  			],
		  		),
		  	),
		  ),
		);
	}  // make a card on the screen to show which card is pending
	
	
	
	String convertDate(DateTime dateTime) {
		
		String dateTimeString = dateTime.toString();
		List<String> temp = dateTimeString.split(' ');
		String temp2 = temp[0].toString();
		List<String> dateData = temp2.split('-');
		print(dateData[2].toString());
		print('${dateData[2]}-${dateData[1]}-${dateData[0]}');
		return '${dateData[2]}-${dateData[1]}-${dateData[0]}';
	}
	
	
	
	
	Future<void> selectDateTime(BuildContext context) async{
		final DateTime picked = await showDatePicker(
				context: context,
				initialDate: selectedDateOfAgmSubmission ,
				firstDate: DateTime(DateTime.now().year-1),
				lastDate: DateTime(DateTime.now().year+1)
		);

		if(picked != null && picked != selectedDateOfAgmSubmission){
			setState(() {
				print('Checking ' + widget.client.company);
			  selectedDateOfAgmSubmission = picked;
			  _selectedDateOfAgm = DateFormat('dd-MM-yyyy').format(picked);

			});
		}
	}
	
	Future<void> checkFilledForms() async{
		String firebaseUserId= await SharedPrefs.getStringPreference("uid");
		dfb = firebaseDatabase
				.reference()
				.child('complinces')
				.child('ROC')
				.child(firebaseUserId)
				.child(widget.client.email.replaceAll('.', ','))
				.child(widget.stringAGMDate);
		
		dfb.once().then((DataSnapshot snapshot){
			Map<dynamic,dynamic> values = snapshot.value;
			if(values != null){
				values.forEach((key,v){
					print(key);
					if(key == "Form ADT-1"){
						print(key);
						setState(() {
							adt = false;
						});
						
					}else if(key == "From AOC-4 & AOC-4 CFS"){
						print(key);
						setState(() {
							aoc = false;
						});
					}else if(key == "Form AOC-4(XBRL)"){
						print(key);
						setState(() {
							aoc_4 = false;
						});
						
					}else if(key == "Form MGT-7"){
						setState(() {
							mgt_7 = false;
						});
					}else if(key == "Form CRA-4"){
						setState(() {
							cra_4 = false;
						});
					}else if(key == "Form MGT-14"){
						setState(() {
							mgt_14 = false;
						});
					}
					
				});
			}
		});
		
		setState(() {
			loading = true;
		});
	}  // Checking which forms has been filled
	
	
	@override
  void initState() {
    super.initState();
    checkFilledForms();
	}
	
	
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text("ROC Upcoming Compliances"),
	    ),
	    
	    body: SingleChildScrollView(
	      child: Container(
		    padding: EdgeInsets.all(24),
		    child: loading?Form(
			    key: rocFromKey,
		      child: Column(
			    crossAxisAlignment: CrossAxisAlignment.stretch,
			    children: <Widget>[
			    	
			    	widget.agmRecorded? Container(
					    padding: EdgeInsets.all(15),
					    child: Column(
						    children: <Widget>[
						    	
						    	Text('AGM Conclusion Date : ${widget.stringAGMDate}',style: TextStyle(
								    fontWeight: FontWeight.bold,
								    fontSize: 25,
							    ),),
							    
							    adt?Column(
							      children: <Widget>[
							        SizedBox(height: 30,),
								      makeWidget("Form ADT-1", 15),
							      ],
							    ):Container(),
							    
							    aoc?Column(
							      children: <Widget>[
							        SizedBox(height: 30,),
								      makeWidget("From AOC-4 & AOC-4 CFS", 30),
							      ],
							    ):Container(),
							    
							
							    aoc_4?Column(
							      children: <Widget>[
							        SizedBox(height: 30,),
								      makeWidget("Form AOC-4(XBRL)", 30),
							      ],
							    ):Container(),
							    
							
							    mgt_7?Column(
							      children: <Widget>[
							        SizedBox(height: 30,),
								      makeWidget("Form MGT-7", 60),
							      ],
							    ):Container(),
							
							    cra_4?Column(
							      children: <Widget>[
							        SizedBox(height: 30,),
								      makeWidget("Form CRA-4", 30),
							      ],
							    ):Container(),
							
							    mgt_14?Column(
							      children: <Widget>[
							        SizedBox(height: 30,),
								      makeWidget("Form MGT-14", 30),
							      ],
							    ):Container(),
							
							    
							
							    SizedBox(height: 50,),
							    
							    Column(
								    crossAxisAlignment: CrossAxisAlignment.stretch,
							      children: <Widget>[
							        Container(
								        decoration: BoxDecoration(
									        borderRadius: BorderRadiusDirectional.circular(10),
									        color: buttonColor,
								        ),
								        margin: EdgeInsets.symmetric(horizontal: 20),
								        child: TextButton(
									        child: Text("Edit Date"),
									        onPressed: (){
									        	setState(() {
									        		widget.agmRecorded = false;
									        	});
									        	},
								        ),
							        ),
							      ],
							    )
						    ],
					    ),
				    ) :Column(
					    crossAxisAlignment: CrossAxisAlignment.stretch,
					    children: <Widget>[
						    Text("AGM Submission date"),
						    SizedBox(
							    height: 10.0,
						    ),
						    Container(
							    padding: EdgeInsets.symmetric(horizontal: 10),
							    decoration: fieldsDecoration,
							    child: Row(
								    mainAxisAlignment: MainAxisAlignment.spaceBetween,
								    children: <Widget>[
									    Text(
										    '$_selectedDateOfAgm',
									    ),
									    TextButton(
										    onPressed: () {
										    	selectDateTime(context);
										    },
										    child: Icon(Icons.date_range),
									    ),
								    ],
							    ),
						    ),
						    
						    SizedBox(
							    height: 30.0,
						    ),
						    Container(
							    decoration: BoxDecoration(
								    borderRadius: BorderRadiusDirectional.circular(10),
								    color: buttonColor,
							    ),
							    height: 50.0,
							    child: TextButton(
								    child: buttonLoading? Container(
									    child: CircularProgressIndicator(
										    valueColor: AlwaysStoppedAnimation<Color>
											    (Colors.white70),
									    ),
								    ) :Text("Save Details"),
								    onPressed: () {
								    	showConfirmation(context, _selectedDateOfAgm);
								    },
							    ),
						    ),
					    ],
				    ),
				
				    SizedBox(
					    height: 30,
				    ),
			    ],
		      ),
		    ): Container(
			    child: Center(
				    child: CircularProgressIndicator(
					    valueColor: AlwaysStoppedAnimation<Color>
						    (Colors.white70),
				    ),
			    ),
		    ),
		    
	      ),
	    ),
    );
  }
  
  
  Future<void> dialogSRNofForms( String formType , BuildContext context ) async{

		String SRN = ' ';
		String date = ' ';

		await showDialog<void>(
				context: context,
				builder: (builder){
					return StatefulBuilder(
					  builder:(context,setState) {
						  return AlertDialog(
							  title: Column(
								  children: <Widget>[
									  Text('Enter details',
										  style: TextStyle(fontWeight: FontWeight.bold),),
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
												  Text("SRN No. of $formType"),
												  SizedBox(height: 10,),
												  TextFormField(
													  decoration: buildCustomInput(hintText: 'SRN no.'),
													  onChanged: (value) {
														  setState(() {
															  SRN = value;
														  });
													  },
												  ),
												  SizedBox(height: 20,),
												  Text("Date Of Filling"),
												  SizedBox(height: 10,),
												  Container(
													  padding: EdgeInsets.symmetric(horizontal: 10),
													  decoration: fieldsDecoration,
													  child: Row(
														  mainAxisAlignment: MainAxisAlignment.spaceBetween,
														  children: <Widget>[
															  Text(
																  tempDate,
															  ),
															  TextButton(
																  onPressed: () async {
																	  final DateTime picked = await showDatePicker(
																			  context: context,
																			  initialDate: DateTime.now(),
																			  firstDate: DateTime(DateTime.now().year - 1),
																			  lastDate: DateTime(DateTime.now().year + 1)
																	  );
																	  if (picked != null) {
																		  print(picked);
																		  setState(() {
																			  tempDate =  DateFormat('dd-MM-yyyy').format(picked);
																		  });
																		  date = tempDate;
																		  print(tempDate);
																	  }
																  },
																  child: Icon(Icons.date_range),
															  ),
														  ],
													  ),
												  ),
												  SizedBox(height: 20,),
											  ],
										  )
								  ),
							  ),
							
							  actions: <Widget>[
								  TextButton(
									  child: Text('Save Details'),
									  onPressed: () async {
										  String firebaseUserId = FirebaseAuth.instance.currentUser.uid;
										  dfb = firebaseDatabase.reference();
										  await dfb.child('complinces')
												  .child('ROC')
												  .child(firebaseUserId)
												  .child(widget.client.email.replaceAll('.', ','))
												  .child(widget.stringAGMDate)
												  .child(formType)
												  .set({
											  'SRN No': SRN,
											  'Date of Filing': date,
										  });
										  checkFilledForms();
										  Navigator.pop(context);
									  },
								  )
							  ],
						  );
					  }
					);
				}
		);
  } //Pop-up to enter from SRN number and date of submission
  
  
	Future<void> agmDateEntryDB(int i) async {
		try {
			if (rocFromKey.currentState.validate()) {
				rocFromKey.currentState.save();
				
				String firebaseUserId= await SharedPrefs.getStringPreference("uid");
				
				// nd() async{
				// 	dfb = firebaseDatabase.reference()
				// 			.child('complinces')
				// 			.child('ROC')
				// 			.child(firebaseUserId)
				// 			.child(widget.client.email.replaceAll('.', ','));
				// 	await dfb.once().then((DataSnapshot snapshot){
				// 		Map<dynamic,dynamic> values = snapshot.value;
				// 		widget.stringAGMDate = values.keys.first.toString();
				// 	});
				// }
				this.setState(() {
					buttonLoading = true;
				});
				
				dfb = firebaseDatabase.reference();
				try {
					print('database started');
					await dfb.child('complinces')
							.child('ROC')
							.child(firebaseUserId)
							.child(widget.client.email.replaceAll('.', ',')).remove();
					dfb = firebaseDatabase.reference();
					await dfb.child('complinces')
							.child('ROC')
							.child(firebaseUserId)
							.child(widget.client.email.replaceAll('.', ','))
							.child(convertDate(selectedDateOfAgmSubmission))
							.set({
						'AGM Date' : '',
					});
					widget.stringAGMDate = convertDate(selectedDateOfAgmSubmission);
					setState(() {
					  widget.agmRecorded = true;
					});
					
					flutterToast(message: i != 1 ? "Date has Been Recorded" : "Date has been updated");
				}on PlatformException catch(e){
					print("Patform" + e.toString());
					flutterToast(message: e.message);
				}catch(e){
					print(e);
					flutterToast(message: "Something went wrong");
				}
			}
			else{
				flutterToast(message: "Please Enter date");
			}
		} on PlatformException catch (e) {
			flutterToast(message: e.message);
		} catch (e) {
			flutterToast(message: 'Payment Not Saved due to some error');
		} finally {
			this.setState(() {
				buttonLoading = false;
			});
		}
	}  //Enter date in the DB when editing or adding agm date
	
	
	Future<void> showConfirmation(BuildContext context,String date) async{
	 	buttonLoading = true;
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
							  Text('$date '+'?',style: TextStyle(
								  fontWeight: FontWeight.bold,
							  ),),
						  ],
					  ),
				  ),
				  
				  actions: <Widget>[
				  	TextButton(
						  child: Text('Confirm Date'),
						  onPressed: () async{
						  	Navigator.of(context).pop();
							  await agmDateEntryDB(0);
							  await setUpComingCompliances();
						  },
					  ),
					  
					  TextButton(
						  child: Text('Edit Date'),
						  onPressed: (){
						  	Navigator.of(context).pop();
						  },
					  )
				  ],
			  );
		  }
	  );
	}  //Pop-up to confirm editing date or adding date -> setUpComingCompliances
	
	
	Future<void> setUpComingCompliances() async{
	 	// print("setUpComingCompliances");
	  String firebaseUserId= await SharedPrefs.getStringPreference("uid");
	  dfb = firebaseDatabase.reference();
	  await dfb.child('usersUpcomingCompliances')
	  .child(firebaseUserId)
	  .child(widget.client.email)
	  .child('ROC')
	  .remove();
	  
	 	updateDBUpcoming(String form ,String month,String date) async {
		  dfb = firebaseDatabase.reference();
		  await dfb.child('usersUpcomingCompliances')
		      .child(firebaseUserId)
		      .child(widget.client.email)
				  .child('ROC')
				  .child(month)
				  .child(form)
				  .set({
				    'date': date,
				    'label': 'Due Date for filling $form',
		      });
	  }
	  
	  try {
		  
		  
		  updateDBUpcoming('Form ADT-1', DateChange.addDayToDate(
				  convertDate(selectedDateOfAgmSubmission), 15).split('-')[1],
				  DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 15).split('-')[0]);
		  await NotificationServices().deleteNotification('${widget.client.key}1001');
		  NotificationServices().reminderNotificationService('${widget.client.key}1001', "${widget.client.name}'s Form ADT-1(ROC)",
				  "${widget.client.name}'s Form ADT-1(ROC) is on  ${DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 15)}"
				  , selectedDateOfAgmSubmission.add(Duration(days: 15))
		  );
		  
		  
		  
		  updateDBUpcoming('From AOC-4 & AOC-4 CFS', DateChange.addDayToDate(
				  convertDate(selectedDateOfAgmSubmission), 30).split('-')[1]
				  , DateChange.addDayToDate(
						  convertDate(selectedDateOfAgmSubmission), 30).split('-')[0]);
		  await NotificationServices().deleteNotification('${widget.client.key}1002');
		  NotificationServices().reminderNotificationService('${widget.client.key}1002', "${widget.client.name}'s From AOC-4 & AOC-4 CFS(ROC)",
				  "${widget.client.name}'s From AOC-4 & AOC-4 CFS(ROC) is on  ${DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 30)}"
				  , selectedDateOfAgmSubmission.add(Duration(days: 30))
		  );
		  
		  
		  updateDBUpcoming('Form AOC-4(XBRL)', DateChange.addDayToDate(
				  convertDate(selectedDateOfAgmSubmission), 30).split('-')[1]
				  , DateChange.addDayToDate(
						  convertDate(selectedDateOfAgmSubmission), 30).split('-')[0]);
		  await NotificationServices().deleteNotification('${widget.client.key}1003');
		  NotificationServices().reminderNotificationService('${widget.client.key}1003', "${widget.client.name}'s Form AOC-4(XBRL)(ROC)",
				  "${widget.client.name}'s Form Form AOC-4(XBRL)(ROC) is on  ${DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 30)}"
				  , selectedDateOfAgmSubmission.add(Duration(days: 30))
		  );
		  
		  
		  updateDBUpcoming('Form MGT-7', DateChange.addDayToDate(
				  convertDate(selectedDateOfAgmSubmission), 60).split('-')[1]
				  , DateChange.addDayToDate(
						  convertDate(selectedDateOfAgmSubmission), 60).split('-')[0]);
		  await NotificationServices().deleteNotification('${widget.client.key}1004');
		  NotificationServices().reminderNotificationService('${widget.client.key}1004', "${widget.client.name}'s Form MGT-7(ROC)",
				  "${widget.client.name}'s Form MGT-7(ROC) is on  ${DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 60)}"
				  , selectedDateOfAgmSubmission.add(Duration(days: 60))
		  );
		  
		  
		  updateDBUpcoming('Form CRA-4', DateChange.addDayToDate(
				  convertDate(selectedDateOfAgmSubmission), 30).split('-')[1]
				  , DateChange.addDayToDate(
						  convertDate(selectedDateOfAgmSubmission), 30).split('-')[0]);
		  await NotificationServices().deleteNotification('${widget.client.key}1005');
		  NotificationServices().reminderNotificationService('${widget.client.key}1005', "${widget.client.name}'s Form CRA-4(ROC)",
				  "${widget.client.name}'s Form CRA-4(ROC) is on  ${DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 30)}"
				  , selectedDateOfAgmSubmission.add(Duration(days: 30))
		  );
		  
		  
		  updateDBUpcoming('Form MGT-14', DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 30).split('-')[1]
				  , DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 30).split('-')[0]);
		  await NotificationServices().deleteNotification('${widget.client.key}1006');
		  NotificationServices().reminderNotificationService('${widget.client.key}1006', "${widget.client.name}'s Form MGT-14(ROC)",
				  "${widget.client.name}'s Form MGT-14 is on  ${DateChange.addDayToDate(convertDate(selectedDateOfAgmSubmission), 30)}"
				  , selectedDateOfAgmSubmission.add(Duration(days: 30))
		  );
		  
		  print('success');
	  } on PlatformException catch(e){
		  flutterToast(message: e.message);
	  } catch(e){
		  flutterToast(message: "Something went wrong");
	  }
	}    // Weather update or add new agm this will update notification and upcoming compliances in user.
	
}

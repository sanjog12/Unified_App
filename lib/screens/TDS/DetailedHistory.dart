import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/TDSPaymentObject.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';


class DetailedHistory extends StatefulWidget {
	
	final TDSPaymentObject tdsPaymentObject ;
	final Client client;
	final String keyDB;

  const DetailedHistory({Key key, this.keyDB, this.tdsPaymentObject, this.client}) : super(key: key);
	
  @override
  _DetailedHistoryState createState() => _DetailedHistoryState();
}

class _DetailedHistoryState extends State<DetailedHistory> {
	
	TDSPaymentObject _tdsPaymentObject ;
	bool edit= false;
	bool loadingDelete = false;
	DateTime selectedDateOfPayment = DateTime.now();
	String showDateOfPayment ;
	String _showDateOfPayment;
	final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
	DatabaseReference dbf;
	String firebaseUserId;
	
	
	Future<Null> selectDateTime(BuildContext context) async{
		print(selectedDateOfPayment);
		final DateTime picked = await showDatePicker(
				context: context,
				initialDate: selectedDateOfPayment,
				firstDate: DateTime(DateTime.now().year - 1),
				lastDate: DateTime(DateTime.now().year , DateTime.now().month+1 , DateTime.now().day+2)
		);
		
		if(picked != null && picked != selectedDateOfPayment){
			setState(() {
				print('Checking ' + widget.client.company);
				selectedDateOfPayment= picked;
				print(picked);
				showDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
				_tdsPaymentObject.dateOfPayment = showDateOfPayment;
				_showDateOfPayment = DateFormat('dd-MMMM-yyyy').format(picked);
			});
		}
	}
	
	fireUser() async{
		firebaseUserId = await SharedPrefs.getStringPreference("uid");
	}
	
	
	@override
  void initState() {
    super.initState();
    _tdsPaymentObject = widget.tdsPaymentObject;
    _showDateOfPayment = widget.tdsPaymentObject.dateOfPayment;
  }
	
  @override
  Widget build(BuildContext context) {
	  final ThemeData _theme = Theme.of(context);
    return Scaffold(
	    appBar: AppBar(
		    title: Text('TDS Detailed History'),
	    ),
	    
	    body: SingleChildScrollView(
		    child: Container(
			    padding: EdgeInsets.only(top: 24.0, right: 24, left: 24, bottom: 70),
			    child: Column(
				    crossAxisAlignment: CrossAxisAlignment.stretch,
				    children: <Widget>[
				    	
				    	Text('Details of the payment paid  ${widget.tdsPaymentObject.dateOfPayment}',
					    style: _theme.textTheme.headline6.merge(TextStyle(
						    fontSize: 26.0,
					    )),
					    ),
				    	
				    	SizedBox(height: 40,),
				    	
				    	Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
						    	Text("BSR Code"),
							    SizedBox(
								    height: 10,
							    ),
							    edit ?TextFormField(
								    initialValue: _tdsPaymentObject.BSRcode !=null ? _tdsPaymentObject.BSRcode : "",
								    onChanged: (String value){
									    _tdsPaymentObject.BSRcode = value;
								    },
								    decoration: buildCustomInput(hintText: " BSR Code"),
							    )
									    :Container(
								    padding: EdgeInsets.all(15),
								    decoration: fieldsDecoration,
								    child: widget.tdsPaymentObject.BSRcode != null
										    ? Text(widget.tdsPaymentObject.BSRcode, style: TextStyle(color: Colors.white),)
										    :Text("No provided",style: TextStyle(color: Colors.white)),
							    )
						    ],
					    ),
					
					    SizedBox(height: 30,),
					    
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
							    Text("Challan Number"),
							    SizedBox(
								    height: 10,
							    ),
							    edit ?TextFormField(
								    initialValue: widget.tdsPaymentObject.challanNumber != null? widget.tdsPaymentObject.challanNumber:"",
								    onChanged: (String value) {
									    _tdsPaymentObject.challanNumber = value;
								    },
								    decoration:
								    buildCustomInput(hintText: "Challan Number"),
							    )
									    :Container(
								    padding: EdgeInsets.all(15),
								    decoration: fieldsDecoration,
								    child: widget.tdsPaymentObject.challanNumber != null
										    ? Text(widget.tdsPaymentObject.challanNumber, style: TextStyle(color: Colors.white),
								    ):Text("Not Provided", style: TextStyle(color: Colors.white)),
							    )
						    ],
					    ),
			
			        SizedBox(height: 30,),
					    
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
							    Text("Section"),
							    SizedBox(
								    height: 10,
							    ),
							    edit? DropdownButtonFormField(
								    isExpanded: true,
								    hint: Text('Select Form'),
								    decoration: buildCustomInput(),
								    items: [
									    DropdownMenuItem(
										    child: Text('Payment to contractor and sub-contractor 194D'),
										    value: 'Payment to contractor and sub-contractor 194D',
									    ),
									
									    DropdownMenuItem(
										    child: Text('Winning from horse race 194C'),
										    value: 'Winning from horse race 194C',
									    ),
									
									    DropdownMenuItem(
										    child: Text('Winning from lottery or crossword puzzle 194BB'),
										    value: 'Winning from lottery or crossword puzzle 194BB',
									    ),
									
									    DropdownMenuItem(
										    child: Text('Interest o security 194B'),
										    value: 'Interest o security 194B',
									    ),
									
									    DropdownMenuItem(
										    child: Text('Interest other than'),
										    value: 'Interest other than',
									    ),
									
									    DropdownMenuItem(
										    child: Text('Interest on Securities 194'),
										    value: 'Interest on Securities 194',
									    ),
									
									    DropdownMenuItem(
										    child: Text('TDS on PF withdraw 193'),
										    value: 'TDS on PF withdraw 193',
									    ),
									
									    DropdownMenuItem(
										    child: Text('192-Salary 192A'),
										    value: '192-Salary 192A',
									    ),
									
									    DropdownMenuItem(
										    child: Text('Payment in respect of life insurance policy 194E'),
										    value: 'Payment in respect of life insurance policy 194E',
									    ),
									
									    DropdownMenuItem(
										    child: Text('Insurance Commission 194DA'),
										    value: 'Insurance Commission 194DA',
									    ),
								    ],
								    value: _tdsPaymentObject.section,
								    onChanged: (String value){
									    _tdsPaymentObject.section = value;
									    setState(() {
										    _tdsPaymentObject.section = value;
									    });
								    },
							    )
									    :Container(
								    padding: EdgeInsets.all(15),
								    decoration: fieldsDecoration,
								    child: Text(
									    widget.tdsPaymentObject.section,
									    style: TextStyle(color: Colors.white),
								    ),
							    )
						    ],
					    ),
			
			        SizedBox(height: 30,),
					    
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
							    Text("Date Of Payment"),
							    SizedBox(
								    height: 10,
							    ),
							    edit?Container(
								    padding: EdgeInsets.symmetric(horizontal: 10),
								    decoration: fieldsDecoration,
								    child: Row(
									    mainAxisAlignment: MainAxisAlignment.spaceBetween,
									    children: <Widget>[
										    Text(
											    '$_showDateOfPayment',
										    ),
										    TextButton(
											    onPressed: () {
												    selectDateTime(context);
											    },
											    child: Icon(Icons.date_range),
										    ),
									    ],
								    ),
							    )
									    :Container(
								    padding: EdgeInsets.all(15),
								    decoration: fieldsDecoration,
								    child: Text(
									    widget.tdsPaymentObject.dateOfPayment,
									    style: TextStyle(color: Colors.white),
								    ),
							    ),
							    ],),
							    
							    SizedBox(height: 30,),
							    
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
						    	Text("Amount Paid"),
							    SizedBox(
									    height: 10,
									  ),
							    edit?TextFormField(
								    initialValue: _tdsPaymentObject.amountOfPayment,
								    onChanged: (String value){
									    _tdsPaymentObject.amountOfPayment = value;
								    },
								    keyboardType: TextInputType.numberWithOptions(decimal: true),
								    decoration:
								    buildCustomInput(hintText: "Amount of Payment", prefixText: "\u{20B9}"),
							    )
									    :Container(
									    padding: EdgeInsets.all(15),
									    decoration: fieldsDecoration,
									    child: Text( "\u{20B9} " +
										    widget.tdsPaymentObject.amountOfPayment,
										    style: TextStyle(color: Colors.white),
									    ),
									   ),
						    ],),
					    
					    SizedBox(height: 40,),
					    
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
						    	Container(
								    decoration: roundedCornerButton,
						    	  child: edit
									      ?TextButton(
						              child: Text("Save Changes"),
						              onPressed: () async{
						              	await editRecord();
						              },
					              )
									      :TextButton(
								      child: Text("Edit"),
								      onPressed: (){
								      	setState(() {
								      	  edit = true;
								      	});
								      },
							      ),
						    	),
							    
							    SizedBox(
								    height: 20,
							    ),
							    
							    Container(
								    decoration: roundedCornerButton,
							      child: TextButton(
								      child: loadingDelete
										      ?Center(
									      child: CircularProgressIndicator(
										      valueColor: AlwaysStoppedAnimation<Color>
											      (Colors.white),
									      ),
								      )
										      :Text("Delete"),
								      onPressed: () async{
									      loadingDelete = true;
									      bool temp = false;
								      	temp = await showConfirmationDialog(context);
								      	if(temp){
								      		deleteRecord();
									      }
								      },
							      ),
							    ),
						    ],),
				    ],),
	    ),
    ),
    );
  }
  
  Future<void> editRecord() async{
		print("editRecord");
  	dbf = firebaseDatabase.reference();
  	await fireUser();
  	print("got firebaseId");
  	print(firebaseUserId);
		print(widget.client.email);
		print(widget.keyDB);
		print(_tdsPaymentObject.BSRcode);
  	try{
		  dbf
				  .child('complinces')
				  .child('TDSPayments')
				  .child(firebaseUserId)
				  .child(widget.client.email)
				  .child(widget.keyDB)
				  .update({
			  'BSRcode': _tdsPaymentObject.BSRcode,
			  'section': _tdsPaymentObject.section,
			  'challanNumber': _tdsPaymentObject.challanNumber,
			  'amountOfPayment': _tdsPaymentObject.amountOfPayment,
			  'dateOfPayment': _tdsPaymentObject.dateOfPayment,
			  'addAttachment': _tdsPaymentObject.addAttachment,  });
		
		  recordEditToast();
		  setState(() {
		    edit = false;
		  });
		  
	  }on PlatformException catch(e){
		  flutterToast(message: e.message);
	  }catch(e){
		  flutterToast(message: "Something went wrong");
	  }
  }
	
	
	Future<void> showConfirmation(BuildContext context) async{
		loadingDelete = true;
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
								child: Text('Confirm'),
								onPressed: () async{
									Navigator.of(context).pop();
									await deleteRecord();
									
								},
							),
							
							TextButton(
								child: Text('Edit'),
								onPressed: (){
									Navigator.of(context).pop();
								},
							)
						],
					);
				}
		);
	}
	
	
	Future<void> deleteRecord() async{
		dbf = firebaseDatabase.reference();
		await fireUser();
		print(firebaseUserId);
		print(widget.client.email);
		print(widget.keyDB);
		try {
			await dbf
					.child('complinces')
					.child('TDSPayments')
					.child(firebaseUserId)
					.child(widget.client.email)
					.child(widget.keyDB)
					.remove();
			
			recordDeletedToast();
			
			Navigator.pop(context);
			
		}on PlatformException catch(e){
			flutterToast(message: e.message);
		}catch(e){
			flutterToast(message: "Something went wrong");
		}
	}
  
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/GSTPaymentObject.dart';
import 'package:unified_reminder/services/PDFView.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';

class DetailedHistoryGst extends StatefulWidget {
	
	final Client client;
	final GSTPaymentObject gstPaymentObject;
	final String keyBD;
	
	const DetailedHistoryGst({Key key, this.keyBD, this.client, this.gstPaymentObject})
			: super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StateDetailedHistoryGst();
  }
}

class _StateDetailedHistoryGst extends State<DetailedHistoryGst>{
	
	bool edit = false;
	bool loadingDelete= false;
	bool newFile = false;
	
	final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
	DatabaseReference dbf;
	String firebaseUserId;
	FirebaseStorage firebaseStorage = FirebaseStorage.instance;
	
	
	DateTime selectedDate = DateTime.now();
	String selectedDateDB ;
	String nameOfFile;
	File file;
	
	GSTPaymentObject _gstPaymentObject;
	
	
	Future<Null> selectDateTime(BuildContext context) async{
		final DateTime picked = await showDatePicker(
				context: context,
				initialDate: selectedDate,
				firstDate: DateTime(DateTime.now().year - 1),
				lastDate: DateTime(DateTime.now().year + 1)
		);
		
		if(picked != null && picked != selectedDate){
			setState(() {
				print('Checking ' + widget.client.company);
				selectedDate = picked;
				print(picked);
				selectedDateDB = DateFormat('dd-MM-yyyy').format(picked);
				_gstPaymentObject.dueDate = selectedDateDB;
			});
		}
	}
	
	fireUser() async{
		firebaseUserId = await SharedPrefs.getStringPreference("uid");
	}
	
	
	@override
	void initState() {
		super.initState();
		print("file name "+widget.gstPaymentObject.addAttachment.toString());
		_gstPaymentObject = widget.gstPaymentObject;
		selectedDateDB = widget.gstPaymentObject.dueDate;
		nameOfFile = widget.gstPaymentObject.addAttachment;
	}
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('GST Payment Record'),
	    ),
	    
	    
	    body: SingleChildScrollView(
		    child: Container(
			    padding: EdgeInsets.all(24),
			    child: Column(
				    crossAxisAlignment: CrossAxisAlignment.stretch,
				    children: <Widget>[
				    	
				    	Text(widget.client.name + '\'s GST Payment Details',style: TextStyle(
						    fontSize: 25,
						    fontWeight: FontWeight.bold,
					    ),),
					    
					    SizedBox(height: 50,),
					    
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
						    	Text('Constitution'),
							    SizedBox(height: 10),
							    Container(
								    padding: EdgeInsets.all(15),
								    decoration: fieldsDecoration,
								    child: Text(
									    widget.gstPaymentObject.section,
								    ),
							    ),
						    ],
					    ),
					    
					    SizedBox(height: 30,),
					    
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
						    	Text('Challan Number'),
							    SizedBox(height: 10,),
							    edit?TextFormField(
								    initialValue: widget.gstPaymentObject.challanNumber,
								    decoration: buildCustomInput(hintText: 'Challan Number'),
								    onChanged: (String value){
									    _gstPaymentObject.challanNumber= value;
								    },
							    )
									    :Container(
								    padding : EdgeInsets.all(15),
								    decoration: fieldsDecoration,
								    child: Text(
									    widget.gstPaymentObject.challanNumber,
								    ),
							    ),
							  ],
					    ),
							
							SizedBox(height: 30,),
							    
							Column(
							   crossAxisAlignment: CrossAxisAlignment.stretch,
							   children: <Widget>[
							   	Text('Amount of Payment'),
							    SizedBox(height: 10,),
							    edit?TextFormField(
								    initialValue: widget.gstPaymentObject.amountOfPayment,
								    decoration: buildCustomInput(hintText: 'Amount of Payment'),
								    onChanged: (String value){
									    _gstPaymentObject.amountOfPayment = value;
								    },
							    )
									    :Container(
								    padding: EdgeInsets.all(15),
								    decoration: fieldsDecoration,
								    child: Text(
									    widget.gstPaymentObject.amountOfPayment,
								    ),
							    ),
							  ],
							),
					    
					    SizedBox(height: 30,),
									    
							Column(
							    crossAxisAlignment: CrossAxisAlignment.stretch,
							    children: <Widget>[
							    	Text('Date of Payment'),
								    SizedBox(height: 10,),
								    edit?Container(
									    padding: EdgeInsets.symmetric(horizontal: 10),
									    decoration: fieldsDecoration,
									    child: Row(
										    mainAxisAlignment: MainAxisAlignment.spaceBetween,
										    children: <Widget>[
											    Text(
												    '$selectedDateDB',
											    ),
											    FlatButton(
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
											    widget.gstPaymentObject.dueDate,
										   ),
							      ),
							   ],
							 ),
					    
					    SizedBox(
						    height: 30,
					    ),
					
					    edit?Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
							    Text( _gstPaymentObject.addAttachment != "null"? "Add New File":"Add challan PDF"),
							    SizedBox(height: 10,),
							    Container(
								    decoration: roundedCornerButton,
								    height: 50,
								    child: FlatButton(
									    onPressed: () async{
										    file = await FilePicker.getFile();
										    List<String> temp = file.path.split('/');
										    print(temp.last);
										    setState(() {
											    nameOfFile = temp.last;
											    newFile = true;
											    print(newFile);
										    });
									    },
									
									    child: Row(
										    children: <Widget>[
											    Icon(Icons.attach_file),
											    SizedBox(width: 6),
											    Text(nameOfFile !='null'?nameOfFile:"Add File"),
										    ],
									    ),
								    ),
							    ),
							    SizedBox(height: 30,),
						    ],
					    ):Container(),
					    
					    _gstPaymentObject.addAttachment != "null"?
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
						    	Container(
								    decoration: roundedCornerButton,
						    	  child: FlatButton(
								    child: Row(
									    mainAxisAlignment: MainAxisAlignment.spaceBetween,
								      children: <Widget>[
								        Text("Click to see challan"),
									      Divider(color: Colors.white,height: 10,),
									      Container(child: GestureDetector(child: Icon(Icons.delete,color: Colors.red),
										      onTap: (){print("pressed");deletePDF(context);},),
										      color: Colors.white,)
								      ],
								    ),
								    onPressed: (){
								    	Navigator.push(context,
										    MaterialPageRoute(
											    builder: (context)=>PDFViewer(
												    pdf: widget.gstPaymentObject.addAttachment,
											    ),
										    ),
									    );
								    },
							    ),
						    	),
						    ],
					    )
					    :Container(),
					    
					    
					    SizedBox(height: 50,),
					
					    Column(
						    crossAxisAlignment: CrossAxisAlignment.stretch,
						    children: <Widget>[
							    Container(
								    decoration: roundedCornerButton,
								    child: edit
										    ?FlatButton(
									    color: buttonColor,
									    child: Text("Save Changes"),
									    onPressed: () async{
										    await editRecord();
										    Navigator.pop(context);
									    },
								    )
										    :FlatButton(
									    color: buttonColor,
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
								    child: FlatButton(
									    color: buttonColor,
									    child: loadingDelete
											    ?Center(
										    child: CircularProgressIndicator(
											    valueColor: AlwaysStoppedAnimation<Color>
												    (Colors.white),
										    ),
									    )
											    :Text("Delete"),
									    onPressed: () async{
										    await showConfirmation(context);
										    Navigator.pop(context);
									    },
								    ),
							    ),
						    ],
					    ),
				    ],
			    ),
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
		print(widget.keyBD);
//    print();
		try{
			if(newFile == true){
				print("1");
				FirebaseStorage firebaseStorage = FirebaseStorage.instance;
				if(widget.gstPaymentObject.addAttachment != "null"){
					print("2");
					String path =  firebaseStorage.ref().child('files').child(widget.gstPaymentObject.addAttachment).path;
					print("3");
					await firebaseStorage.ref().child(path).delete().then((_)=>print("Done Task"));
				}
				print("4");
				String name = await PaymentRecordToDataBase().uploadFile(file);
				print("5");
				dbf = firebaseDatabase.reference();
				dbf
						.child('complinces')
						.child('GSTPayments')
						.child(firebaseUserId)
						.child(widget.client.email)
						.child(widget.keyBD)
						.update({
					'addAttachment': name,
				});
			}
			
			dbf
					.child('complinces')
					.child('GSTPayments')
					.child(firebaseUserId)
					.child(widget.client.email)
					.child(widget.keyBD)
					.update({
			 'challanNumber' : _gstPaymentObject.challanNumber,
			 'amountOfPayment' : _gstPaymentObject.amountOfPayment,
			 'dueDate' : _gstPaymentObject.dueDate,
			 'section' : _gstPaymentObject.section,
			});
			Navigator.pop(context);
			Fluttertoast.showToast(
					msg: "Changes Saved",
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
			
		}on PlatformException catch(e){
			Fluttertoast.showToast(
					msg: e.message.toString(),
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
		}catch(e){
			Fluttertoast.showToast(
					msg: e.message.toString(),
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
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
							FlatButton(
								child: Text('Confirm'),
								onPressed: () async{
									await deleteRecord();
									Navigator.of(context).pop();
								},
							),
							
							FlatButton(
								child: Text('Cancel'),
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
		FirebaseStorage firebaseStorage = FirebaseStorage.instance;
		await fireUser();
		print(firebaseUserId);
		print(widget.client.email);
		print(widget.keyBD);
		try {
			if(_gstPaymentObject.addAttachment != 'null') {
				String path = firebaseStorage
						.ref()
						.child('files')
						.child(widget.gstPaymentObject.addAttachment)
						.path;
				await firebaseStorage.ref().child(path).delete().then((_) =>
						print("Done Task"));
			}
			await dbf
					.child('complinces')
					.child('GSTPayments')
					.child(firebaseUserId)
					.child(widget.client.email)
					.child(widget.keyBD)
					.remove();
			String section = widget.gstPaymentObject.section.replaceAll(' ', '_');
			print(section);
			print(widget.gstPaymentObject.dueDate.split('-')[1]);
			dbf = firebaseDatabase.reference();
			dbf
					.child('usersUpcomingCompliances')
					.child(firebaseUserId)
					.child(widget.client.email)
					.child(DateTime.now().year.toString())
					.child(widget.gstPaymentObject.dueDate.split('-')[1])
					.child('GST')
					.child(section)
					.set(null);
			Fluttertoast.showToast(
					msg: "Record Deleted",
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
			Navigator.pop(context);
			
		}on PlatformException catch(e){
			Fluttertoast.showToast(
					msg: e.message.toString(),
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
		}catch(e){
			Fluttertoast.showToast(
					msg: e.message.toString(),
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
		}
	}
 
	Future<void> deletePDF(BuildContext context) async{
		try{
			print(widget.gstPaymentObject.section.replaceAll(' ', '_'));
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
							FlatButton(
								child: Text('Confirm'),
								onPressed: () async{
									try {
										FirebaseStorage firebaseStorage = FirebaseStorage.instance;
										String path = firebaseStorage
												.ref()
												.child('files')
												.child(widget.gstPaymentObject.addAttachment)
												.path;
										firebaseStorage = FirebaseStorage.instance;
										await firebaseStorage.ref().child(path).delete();
										print("here");
										await fireUser();
										dbf = firebaseDatabase.reference();
										dbf
												.child('complinces')
												.child('GSTPayments')
												.child(firebaseUserId)
												.child(widget.client.email)
												.child(widget.keyBD)
												.update({
											'addAttachment': 'null',
										});
										Navigator.of(context).pop();
										Navigator.pop(context);
										Fluttertoast.showToast(
												msg: "PDF Deleted",
												toastLength: Toast.LENGTH_SHORT,
												gravity: ToastGravity.BOTTOM,
												timeInSecForIos: 1,
												backgroundColor: Color(0xff666666),
												textColor: Colors.white,
												fontSize: 16.0);
									}catch(e){
										print(e.toString());
									}
								},
							),
							
							FlatButton(
								child: Text('Cancel'),
								onPressed: (){
									Navigator.of(context).pop();
								},
							)
						],
					);
				}
		);}catch(e){
			Fluttertoast.showToast(
					msg: e.message.toString(),
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
		}
	}
}

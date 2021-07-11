import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/payment/GSTPaymentObject.dart';
import 'package:unified_reminder/services/GeneralServices/PDFView.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/DateRelated.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

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
		}
	}
	
	fireUser() async{
		firebaseUserId = FirebaseAuth.instance.currentUser.uid;
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
								    decoration: buildCustomInput(hintText: 'Amount of Payment', prefixText: "\u{20B9}"),
								    onChanged: (String value){
									    _gstPaymentObject.amountOfPayment = value;
								    },
							    )
									    :Container(
								    padding: EdgeInsets.all(15),
								    decoration: fieldsDecoration,
								    child: Text("\u{20B9} " +
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
											    TextButton(
												    onPressed: () async{
															selectedDate = await DateChange.selectDateTime(context, 1, 1);
															setState(() {
																selectedDateDB = DateFormat('dd-MM-yyyy').format(selectedDate);
																_gstPaymentObject.dueDate = selectedDateDB;
															});
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
								    child: TextButton(
									    onPressed: () async{
										    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles();
										    file = File(filePickerResult.files.single.path);
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
						    	  child: TextButton(
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
								    child: edit ?
								    TextButton(
									    child: Text("Save Changes"),
									    onPressed: () async{
										    await editRecord();
										    Navigator.pop(context);
									    },
								    ) :
								    TextButton(
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
										    	await deleteRecord();
										    }
									    },
								    ),
							    ),
						    ],
					    ),
					    SizedBox(height: 70,),
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
					String path =  firebaseStorage.ref().child('files').child(widget.gstPaymentObject.addAttachment).fullPath;
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
			recordEditToast();
			
		}on PlatformException catch(e){
			print(e.message);
			flutterToast(message: e.message);
		}on FirebaseException catch(e){
			flutterToast(message: e.message);
		}catch(e){
			print(e);
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
									await deleteRecord();
									Navigator.of(context).pop();
								},
							),
							
							TextButton(
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
						.fullPath;
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
			recordDeletedToast();
			Navigator.pop(context);
			Navigator.pop(context);
//			Navigator.push(context,
//				MaterialPageRoute(
//					builder: (context) => HistoryGST(
//						client: widget.client,
//					)
//				)
//			);
			
		}on PlatformException catch(e){
			print(e.message);
			flutterToast(message: e.message);
		}on FirebaseException catch(e){
			flutterToast(message: e.message);
		}
		catch(e){
			print(e);
			flutterToast(message: "Something went wrong");
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
							TextButton(
								child: Text('Confirm'),
								onPressed: () async{
									try {
										FirebaseStorage firebaseStorage = FirebaseStorage.instance;
										String path = firebaseStorage
												.ref()
												.child('files')
												.child(widget.gstPaymentObject.addAttachment)
												.fullPath;
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
										flutterToast(message: "PDF Deleted");
									}catch(e){
										print(e.toString());
									}
								},
							),
							
							TextButton(
								child: Text('Cancel'),
								onPressed: (){
									Navigator.of(context).pop();
								},
							)
						],
					);
				}
		);}catch(e){
			print(e);
			flutterToast(message: "Something went wrong");
		}
	}
}

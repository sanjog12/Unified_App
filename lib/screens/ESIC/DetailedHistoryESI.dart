import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/Client.dart';
import 'package:unified_reminder/models/payment/ESIMonthlyContributionObejct.dart';
import 'package:unified_reminder/services/GeneralServices/PDFView.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class DetailedHistoryESI extends StatefulWidget {
	final Client client;
	final ESIMonthlyContributionObejct esiMonthlyContributionObejct;
	final String keyDB;
  const DetailedHistoryESI({Key key, this.keyDB, this.client,this.esiMonthlyContributionObejct}) : super(key: key);
  @override
  _DetailedHistoryESIState createState() => _DetailedHistoryESIState();
}


class _DetailedHistoryESIState extends State<DetailedHistoryESI> {
	
	final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
	DatabaseReference dbf;
	bool loadingDelete = false;
	bool edit = false;
	bool newFile = false;
	String firebaseUserId;
	String nameOfFile = "Add File";
	ESIMonthlyContributionObejct _esiMonthlyContributionObejct;
	DateTime selectedDate = DateTime.now();
	String selectedDateDB;
	File file;
	
	
	Future<void> selectDateTime(BuildContext context) async{
		final DateTime picked = await showDatePicker(
				context: context,
				initialDate: selectedDate ,
				firstDate: DateTime(DateTime.now().year - 1),
				lastDate: DateTime(DateTime.now().year+1)
		);
		
		if(picked != null && picked != selectedDate){
			setState(() {
				print('Checking ' + widget.client.company);
				selectedDate = picked;
				selectedDateDB = DateFormat('dd-MM-yyyy').format(picked);
				_esiMonthlyContributionObejct.dateOfFilling = selectedDateDB;
			});
		}
	}
	
	
	fireUser() async{
		firebaseUserId = FirebaseAuth.instance.currentUser.uid;
	}
	
	
	@override
  void initState() {
    super.initState();
		_esiMonthlyContributionObejct = widget.esiMonthlyContributionObejct;
		selectedDateDB = widget.esiMonthlyContributionObejct.dateOfFilling;
  }
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('ESI Details'),
	    ),
	    
	    body: SingleChildScrollView(
	      child: Container(
		    padding: EdgeInsets.all(20),
		    child: Column(
			    crossAxisAlignment: CrossAxisAlignment.stretch,
			    children: <Widget>[
			    	Column(
					    crossAxisAlignment: CrossAxisAlignment.stretch,
					    children: <Widget>[
					    	Text('Date of Filling '),
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
										    '$selectedDateDB',
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
								    widget.esiMonthlyContributionObejct.dateOfFilling,
								    style: TextStyle(color: Colors.white),
							    ),
						    )
					    ],
				    ),
				
				    
				    SizedBox(height: 30,),
				
				    Column(
					    crossAxisAlignment: CrossAxisAlignment.stretch,
					    children: <Widget>[
						    Text('Challan Number'),
						    SizedBox(
							    height: 10,
						    ),
						
						    edit?TextFormField(
							    initialValue: widget.esiMonthlyContributionObejct.challanNumber,
							    decoration: buildCustomInput(hintText: 'Challan Number'),
							    onChanged: (String value){
								    _esiMonthlyContributionObejct.challanNumber = value;
							    },
						    )
								    :Container(
							    padding: EdgeInsets.all(15),
							    decoration: fieldsDecoration,
							    child: Text(
								    widget.esiMonthlyContributionObejct.challanNumber,
								    style: TextStyle(color: Colors.white),
							    ),
						
						    )
					    ],
				    ),
				    
				    SizedBox(height: 30,),
				    
				    Column(
					    crossAxisAlignment: CrossAxisAlignment.stretch,
					    children: <Widget>[
						    Text('Amount of Payment'),
						    SizedBox(
							    height: 10,
						    ),
						
						    edit?TextFormField(
							    initialValue: widget.esiMonthlyContributionObejct.amountOfPayment,
							    decoration: buildCustomInput(hintText: 'Amount of Payment', prefixText: "\u{20B9}"),
							    onChanged: (String value){
								    _esiMonthlyContributionObejct.amountOfPayment= value;
							    },
						    )
								    :Container(
							    padding: EdgeInsets.all(15),
							    decoration: fieldsDecoration,
							    child: Text("\u{20B9} " +
								    widget.esiMonthlyContributionObejct.amountOfPayment,
								    style: TextStyle(color: Colors.white),
							    ),
						    )
					    ],
				    ),
				
				    SizedBox(height: 30,),
				
				    edit?Column(
					    crossAxisAlignment: CrossAxisAlignment.stretch,
					    children: <Widget>[
						    Text(_esiMonthlyContributionObejct.addAttachment != null?'Add New File':"Add File"),
						    SizedBox(height: 10,),
						    Container(
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
									    });
								    },
								
								    child: Row(
									    children: <Widget>[
										    Icon(Icons.attach_file),
										    SizedBox(width: 6),
										    Text(nameOfFile),
									    ],
								    ),
							    ),
						    ),
						    SizedBox(height: 30,),
					    ],
				    ):Container(),
				
				    widget.esiMonthlyContributionObejct.addAttachment != "null"?
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
													    pdf: widget.esiMonthlyContributionObejct.addAttachment,
												    )
										    )
								    );
							    },
						      ),
						    )
					    ],
				    ):Container(),
				    
				    SizedBox(height: 50,),
				    
				    Column(
					    crossAxisAlignment: CrossAxisAlignment.stretch,
					    children: <Widget>[
						
						    Container(
							    decoration: roundedCornerButton,
							    child: edit?TextButton(
								    child: Text("Save Changes"),
								    onPressed: (){
									    editRecord();
								    },
							    ) :TextButton(
								    child: Text("Edit"),
								    onPressed: (){
									    setState(() {
										    edit= true;
									    });
								    },
							    ),
						    ),
						
						    SizedBox(height: 20,),
						
						    Container(
							    decoration: roundedCornerButton,
							    child: TextButton(
								    child: Text("Delete Record"),
								    onPressed: () async{
									    loadingDelete = true;
									    bool t= false;
									    t=await showConfirmationDialog(context);
									    if(t){
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
		print(widget.keyDB);
		print(_esiMonthlyContributionObejct.challanNumber);
		try{
			
			if(newFile == true){
				print("1");
				FirebaseStorage firebaseStorage = FirebaseStorage.instance;
				if(_esiMonthlyContributionObejct.addAttachment != "null") {
					String path = firebaseStorage
							.ref()
							.child('files')
							.child(widget.esiMonthlyContributionObejct.addAttachment)
							.fullPath;
					await firebaseStorage.ref().child(path).delete().then((_) =>
							print("Done Task"));
				}
				print("4");
				String name = await PaymentRecordToDataBase().uploadFile(file);
				print("5");
				dbf = firebaseDatabase.reference();
				await dbf
						.child('complinces')
						.child('ESIMonthlyContributionPayments')
						.child(firebaseUserId)
						.child(widget.client.email)
						.child(widget.keyDB)
						.update({
					'addAttachment': name,
				});
				
				setState(() {
				  widget.esiMonthlyContributionObejct.addAttachment = name;
				});
			}
			
			await dbf
					.child('complinces')
					.child('ESIMonthlyContributionPayments')
					.child(firebaseUserId)
					.child(widget.client.email)
					.child(widget.keyDB)
					.update({
			'challanNumber': _esiMonthlyContributionObejct.challanNumber,
			'amountOfPayment': _esiMonthlyContributionObejct.amountOfPayment,
			'dateOfFilling': _esiMonthlyContributionObejct.dateOfFilling,
			});
			recordEditToast();
			
		}on PlatformException catch(e){
			print(e.message);
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
									Navigator.of(context).pop();
									await deleteRecord();
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
		print(widget.keyDB);
		try {
			
			try {
				String path = firebaseStorage
						.ref()
						.child('files')
						.child(widget.esiMonthlyContributionObejct.addAttachment)
						.fullPath;
				await firebaseStorage.ref().child(path).delete().then((_) =>
						print("Done Task"));
			}catch(e){
				print(e);
			}
			
			await dbf
					.child('complinces')
					.child('ESIMonthlyContributionPayments')
					.child(firebaseUserId)
					.child(widget.client.email)
					.child(widget.keyDB)
					.remove();
			recordDeletedToast();
			Navigator.pop(context);
			Navigator.pop(context);

		}on PlatformException catch(e){
			print(e.message);
			flutterToast(message: e.message);
		}catch(e){
			print(e);
			flutterToast(message: "Something went wrong");
		}
	}
	
	
	Future<void> deletePDF(BuildContext context) async{
		try{
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
													.child(widget.esiMonthlyContributionObejct.addAttachment)
													.fullPath;
											firebaseStorage = FirebaseStorage.instance;
											await firebaseStorage.ref().child(path).delete();
											print("here");
											await fireUser();
											dbf = firebaseDatabase.reference();
											await dbf
													.child('complinces')
													.child('ESIMonthlyContributionPayments')
													.child(firebaseUserId)
													.child(widget.client.email)
													.child(widget.keyDB)
													.update({
												'addAttachment': 'null',
											});
											setState(() {
											  widget.esiMonthlyContributionObejct.addAttachment = 'null';
													
											});
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

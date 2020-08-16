import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/quarterlyReturns/GSTReturnFillingsObject.dart';
import 'package:unified_reminder/services/QuarterlyReturnsRecordToDatabase.dart';
import 'package:unified_reminder/styles/styles.dart';

class ESIReturnFilling extends StatefulWidget {
	final Client client;
	
	const ESIReturnFilling({this.client});
	@override
	_GSTReturnFillingState createState() => _GSTReturnFillingState();
}

class _GSTReturnFillingState extends State<ESIReturnFilling> {
	bool buttonLoading = false;
	GlobalKey<FormState> gSTReturnFillingsFormKey = GlobalKey<FormState>();
	
	GSTReturnFillingsObject gstReturnFillingsObject = GSTReturnFillingsObject();
	
	String selectedDateDB = "Select Date";
	DateTime selectedDate = DateTime.now();
	File file;
	String nameOfFile = "Select File";
	
	Future<Null> selectDateTime(BuildContext context) async{
		final DateTime picked = await showDatePicker(
			context: context,
			initialDate: selectedDate,
			firstDate: DateTime(DateTime.now().year-1),
			lastDate: DateTime(DateTime.now().year+1),
		);
		
		if(picked != null && picked != selectedDate){
			setState(() {
				print('Checking ' + widget.client.company);
				selectedDate= picked;
				print(picked);
				selectedDateDB = DateFormat('dd-MM-yyyy').format(picked);
				gstReturnFillingsObject.dateOfFilledReturns = selectedDateDB;
				selectedDateDB = DateFormat('dd-MM-yy').format(picked);
			});
		}
	}
	
	
	
	@override
	Widget build(BuildContext context) {
		final ThemeData _theme = Theme.of(context);
		return Scaffold(
				appBar: AppBar(
					title: Text("Income Tax Returns"),
				),
				body: Container(
					padding: EdgeInsets.only(top: 24.0, left: 24 , right: 24, bottom: 70),
					child: SingleChildScrollView(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: <Widget>[
								Text(
									"Income Tax Return Filling",
									style: _theme.textTheme.headline.merge(
										TextStyle(
											fontSize: 26.0,
										),
									),
								),
								SizedBox(
									height: 50.0,
								),
								Form(
									key: gSTReturnFillingsFormKey,
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											SizedBox(
												height: 30.0,
											),
											Column(
												crossAxisAlignment: CrossAxisAlignment.stretch,
												children: <Widget>[
													Text("Date of Filling"),
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
													),
												],
											),
											SizedBox(
												height: 30.0,
											),
											Column(
												crossAxisAlignment: CrossAxisAlignment.stretch,
												children: <Widget>[
													Text('Add Attachment'),
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
												],
											),
											SizedBox(
												height: 40.0,
											),
											Container(
												decoration: roundedCornerButton,
												height: 50.0,
												child: FlatButton(
													child: Text("Save Record"),
													onPressed: () {
														ReturnFillingsIncomeTax();
													},
												),
											),
									SizedBox(height: 20,),
									helpButtonBelow("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20ESI"),
									SizedBox(
										height: 30.0,
									),
										],
									),
								)
							],
						),
					),
				));
	}
	
	Future<void> ReturnFillingsIncomeTax() async {
		try {
			if (gSTReturnFillingsFormKey.currentState.validate()) {
				gSTReturnFillingsFormKey.currentState.save();
				this.setState(() {
					buttonLoading = true;
				});
				
				bool done = await QuarterlyReturnsRecordToDatabase()
						.AddGSTReturnFillings(
						gstReturnFillingsObject, widget.client,file);
				
				if (done) {
					Fluttertoast.showToast(
							msg: "Successfully Recorded",
							toastLength: Toast.LENGTH_SHORT,
							gravity: ToastGravity.BOTTOM,
							timeInSecForIos: 1,
							backgroundColor: Color(0xff666666),
							textColor: Colors.white,
							fontSize: 16.0);
					Navigator.pop(context);
				}
			}
		} on PlatformException catch (e) {
			Fluttertoast.showToast(
					msg: e.message,
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
		} catch (e) {
			Fluttertoast.showToast(
					msg: 'Payment Not Saved This Time',
					toastLength: Toast.LENGTH_SHORT,
					gravity: ToastGravity.BOTTOM,
					timeInSecForIos: 1,
					backgroundColor: Color(0xff666666),
					textColor: Colors.white,
					fontSize: 16.0);
		} finally {
			this.setState(() {
				buttonLoading = false;
			});
		}
	}
}

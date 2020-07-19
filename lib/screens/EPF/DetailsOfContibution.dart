import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/payment/EPFMonthlyContributionObejct.dart';
import 'package:unified_reminder/models/quarterlyReturns/EPFDetailsOfContributionObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/validators.dart';

class DetailsOfContribution extends StatefulWidget {
	final Client client;

  const DetailsOfContribution({Key key, this.client}) : super(key: key);
  @override
  _DetailsOfContributionState createState() => _DetailsOfContributionState();
}

class _DetailsOfContributionState extends State<DetailsOfContribution> {
	
	bool buttonLoading = false;
	GlobalKey<FormState> _MonthlyContributionFormKey = GlobalKey<FormState>();
	
	EPFDetailsOfContributionObject epfDetailsOfContributionObject = EPFDetailsOfContributionObject();
	
	bool loadingSaveButton = false;
	
	DateTime selectedDateOfPayment = DateTime.now();
	
	String nameOfFile = 'Attach File';
	String _selectedDateOfPayment = 'Select Date';
	String showDateOfPayment = ' ';
	
	File file;
	
	
	
	Future<Null> selectDateTime(BuildContext context) async{
		final DateTime picked = await showDatePicker(
			context: context,
			initialDate: selectedDateOfPayment ,
			firstDate: DateTime(DateTime.now().year-1),
			lastDate: DateTime(DateTime.now().year+1),
		);
		
		if(picked != null && picked != selectedDateOfPayment){
			setState(() {
				selectedDateOfPayment = picked;
				showDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
				epfDetailsOfContributionObject.dateOfFilling = showDateOfPayment;
				setState(() {
					_selectedDateOfPayment = DateFormat('dd-MM-yyyy').format(picked);
				});
				
			});
		}
	}
	
	
  @override
  Widget build(BuildContext context) {
	  final ThemeData _theme = Theme.of(context);
    return Scaffold(
	    appBar: AppBar(
		    title: Text('Details of Contribution'),
	    ),
	    
	    body: Container(
		    padding: EdgeInsets.all(24),
		    child: SingleChildScrollView(
			    child: Column(
				    crossAxisAlignment: CrossAxisAlignment.stretch,
				    children: <Widget>[
					    Text(
						    "Details of Contribution Payments",
						    style: _theme.textTheme.title.merge(
							    TextStyle(
								    fontSize: 26.0,
							    ),
						    ),
					    ),
					    SizedBox(
						    height: 10.0,
					    ),
					    Text(
						    "Enter your details for Details of Contribution ",
						    style: _theme.textTheme.subtitle.merge(
							    TextStyle(
								    fontWeight: FontWeight.w300,
							    ),
						    ),
						    textAlign: TextAlign.start,
					    ),
					    SizedBox(
						    height: 50.0,
					    ),
					    Form(
						    key: _MonthlyContributionFormKey,
						    child: Column(
							    crossAxisAlignment: CrossAxisAlignment.stretch,
							    children: <Widget>[
								    Column(
									    crossAxisAlignment: CrossAxisAlignment.stretch,
									    children: <Widget>[
										    Text("Date of Payment"),
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
														    '$_selectedDateOfPayment',
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
								    
								    SizedBox(height: 30.0),
								
								    Column(
									    crossAxisAlignment: CrossAxisAlignment.stretch,
									    children: <Widget>[
										    Text("Amount of Payment"),
										    SizedBox(
											    height: 10.0,
										    ),
										    TextFormField(
											    decoration:
											    buildCustomInput(hintText: "Amount of Payment"),
											    validator: (value) =>
													    requiredField(value, 'Amount Of Payment'),
											    onChanged: (value) => epfDetailsOfContributionObject
													    .amountOfPayment = value,
										    ),
									    ],
								    ),
								    
								    SizedBox(height: 30.0),
								
								    Column(
									    crossAxisAlignment: CrossAxisAlignment.stretch,
									    children: <Widget>[
										    Text("Challan Number"),
										    SizedBox(
											    height: 10.0,
										    ),
										    TextFormField(
											    decoration:
											    buildCustomInput(hintText: "Challan Number"),
											    validator: (value) =>
													    requiredField(value, 'Challan number'),
											    onChanged: (value) => epfDetailsOfContributionObject
													    .challanNumber = value,
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
										    SizedBox(height: 10),
										    Container(
											    decoration: roundedCornerButton,
											    height: 50,
											    child: FlatButton(
												    onPressed: () async{
													    file = await FilePicker.getFile();
													    List<String> temp = file.path.split('/');
													    epfDetailsOfContributionObject.addAttachment = temp.last;
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
									    ],),
								    SizedBox(
									    height: 50.0,
								    ),
								    Container(
									    decoration: roundedCornerButton,
									    height: 50.0,
									    child: FlatButton(
										    child: Text("Save Payment"),
										    onPressed: () {
										    	detailsMonthlyContribution();
										    },
									    ),
								    ),
								    SizedBox(
									    height: 50.0,
								    ),
							    ],
						    ),
					    )
				    ],
			    ),
		    ),
	    ),
    );
  }
	
	Future<void> detailsMonthlyContribution() async {
		try {
			if (_MonthlyContributionFormKey.currentState.validate()) {
				_MonthlyContributionFormKey.currentState.save();
				this.setState(() {
					buttonLoading = true;
				});
				
				bool done = await PaymentRecordToDataBase()
						.AddDetailsOfContribution(epfDetailsOfContributionObject, widget.client, file);
				
				if (done) {
					Fluttertoast.showToast(
							msg: "Successfully Saved",
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
					msg: 'Details did not saved this time',
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

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/models/quarterlyReturns/EPFDetailsOfContributionObject.dart';
import 'package:unified_reminder/services/PaymentRecordToDatatBase.dart';
import 'package:unified_reminder/styles/styles.dart';
import 'package:unified_reminder/utils/ToastMessages.dart';
import 'package:unified_reminder/utils/validators.dart';

class DetailsOfContribution extends StatefulWidget {
	final Client client;

  const DetailsOfContribution({Key key, this.client}) : super(key: key);
  @override
  _DetailsOfContributionState createState() => _DetailsOfContributionState();
}

class _DetailsOfContributionState extends State<DetailsOfContribution> {
	
	bool buttonLoading = false;
	GlobalKey<FormState> _monthlyContributionFormKey = GlobalKey<FormState>();
	
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
		    title: Text('EPF Details of Contribution'),
	    ),
	    
	    body: Container(
		    padding: EdgeInsets.all(20),
		    child: SingleChildScrollView(
			    child: Column(
				    crossAxisAlignment: CrossAxisAlignment.stretch,
				    children: <Widget>[
					    Text(
						    "Details of Contribution Payments",
						    style: _theme.textTheme.headline6.merge(
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
						    style: _theme.textTheme.bodyText2.merge(
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
						    key: _monthlyContributionFormKey,
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
													    TextButton(
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
											    buildCustomInput(hintText: "Amount of Payment", prefixText: "\u{20B9}"),
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
											    child: TextButton(
												    onPressed: () async{
													    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles();
													    file = File(filePickerResult.files.single.path);
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
									    child: TextButton(
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
					    ),
					    SizedBox(height: 70,),
				    ],
			    ),
		    ),
	    ),
    );
  }
	
	Future<void> detailsMonthlyContribution() async {
		try {
			if (_monthlyContributionFormKey.currentState.validate() && epfDetailsOfContributionObject.dateOfFilling != '' ) {
				_monthlyContributionFormKey.currentState.save();
				this.setState(() {
					buttonLoading = true;
				});
				
				bool done = await PaymentRecordToDataBase()
						.addDetailsOfContribution(epfDetailsOfContributionObject, widget.client, file);
				
				if (done) {
					flutterToast(message: "Successfully Saved");
					Navigator.pop(context);
				}
			}
		} on PlatformException catch (e) {
			print(e.message);
			flutterToast(message: e.message);
		} catch (e) {
			print(e);
			flutterToast(message: 'Details did not saved this time');
		} finally {
			this.setState(() {
				buttonLoading = false;
			});
		}
	}
}

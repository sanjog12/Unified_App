import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/TDS/Payment.dart';
import 'package:unified_reminder/screens/TDS/QuarterlyReturns.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';


class UpcomingCompliances extends StatefulWidget {
	final Client client;

  const UpcomingCompliances({Key key, this.client}) : super(key: key);
  @override
  _UpcomingCompliancesState createState() => _UpcomingCompliancesState();
}



class _UpcomingCompliancesState extends State<UpcomingCompliances> {
	
	var currentDate = DateTime.now();
	DateFormat format = DateFormat('MM');
	String currentMonthString = ' ';
	
	bool loadingMonth = true;
	
	
	void currentMonth() {
		setState(() {
			currentMonthString = format.format(currentDate);
		  loadingMonth = false;
		});
	}
	
	DateTime nextMonth() {
		 return DateTime(currentDate.year, currentDate.month+1, currentDate.day);
	}
	
	Widget tdsReturnDate(){
		if(currentDate.isAfter(DateTime(currentDate.year,04,01)) && currentDate.isBefore(DateTime(currentDate.year,06,30)))
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
			  children: <Widget>[
			    Text('TDS return for 1st Quarter',textAlign: TextAlign.start,),
				  SizedBox(height: 8,),
				  Text('Due Date :31st August ${currentDate.year}',textAlign: TextAlign.start,),
				  SizedBox(height: 10),
				  Text('Tap to pay',style: TextStyle(
					  fontStyle: FontStyle.italic,
					  fontSize: 8,
				  ),),
			  ],
			);
			
		
		else if(currentDate.isAfter(DateTime(currentDate.year,06,01)) && currentDate.isBefore(DateTime(currentDate.year,09,30)))
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
			  children: <Widget>[
			    Text('TDS return for 2nd Quarter',textAlign: TextAlign.start,),
				  SizedBox(height: 8,),
				  Text('Due Date :31st October ${currentDate.year}',textAlign: TextAlign.start,),
				  SizedBox(height: 10),
				  Text('Tap to pay',style: TextStyle(
					  fontStyle: FontStyle.italic,
					  fontSize: 8,
				  ),),
			  ],
			);
		
		else if(currentDate.isAfter(DateTime(currentDate.year,10,01)) && currentDate.isBefore(DateTime(currentDate.year,12,30)))
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
			  children: <Widget>[
			    Text('TDS return for 3rd Quarter',textAlign: TextAlign.start,),
				  SizedBox(height: 8,),
				  Text('Due Date :31st January ${currentDate.year}',textAlign: TextAlign.start,),
				  SizedBox(height: 10),
				  Text('Tap to pay',style: TextStyle(
					  fontStyle: FontStyle.italic,
					  fontSize: 8,
				  ),),
			  ],
			);
			
		
		else
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
			  children: <Widget>[
			    Text('TDS return for 4th Quarter',textAlign: TextAlign.start,),
				  SizedBox(height: 8,),
		      Text('Due Date :31st May ${currentDate.year}',textAlign: TextAlign.start,),
				  SizedBox(height: 10),
				  Text('Tap to pay',style: TextStyle(
					  fontStyle: FontStyle.italic,
					  fontSize: 8,
				  ),),
			  ],
			);
			
	}
	
	
	@override
  void initState() {
		super.initState();
		currentMonth();
  }
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text('Upcoming Compliances of ${widget.client.name}'),
		    actions: <Widget>[
		    	GestureDetector(
				    onTap: (){
				    	launch("https://api.whatsapp.com/send?phone=919331333692&text=Hi%20Need%20help%20regarding%20TDS");
				    },
				    child: Text("Help?"),
			    )
		    ],
	    ),
	    
      body: SingleChildScrollView(
	      child: Container(
		      padding: EdgeInsets.all(24),
		      child: loadingMonth? Container(
			      child: Center(
				      child: CircularProgressIndicator(
					      valueColor: AlwaysStoppedAnimation<Color>
						      (Colors.white70),
				      ),
			      ),
		      ) :Column(
			        children: <Widget>[
			        	SizedBox(height: 30,),
			    	  GestureDetector(
					      onTap: (){
					      	Navigator.push(context,MaterialPageRoute(
							      builder: (context) => TDSPayment(
								      client : widget.client
							      ),
						      ));
					      },
					    
					      child: Container(
						      padding: EdgeInsets.all(8),
						      decoration: BoxDecoration(
							      borderRadius: BorderRadius.circular(5),
							      color: buttonColor
						      ),
						      child: Column(
							      crossAxisAlignment: CrossAxisAlignment.stretch,
						        children: <Widget>[
						          Text('TDS payment for ${DateFormat.MMM().format(currentDate)} at 7th ,${DateFormat.MMM().format(nextMonth())}'),
							        SizedBox(height: 10),
							        Text('Tap to pay',style: TextStyle(
								        fontStyle: FontStyle.italic,
								        fontSize: 8,
							        ),),
						        ],
						      ),
						    
					      ),
				      ),
				    
				      SizedBox(height: 30,),
				
				      GestureDetector(
					      onTap: (){
					      	Navigator.push(context,
								      MaterialPageRoute(
									      builder: (context) => TDSQuarterly(
										      client:widget.client,
									      )
								      )
						      );
					      },
					
					      child: Container(
						      padding: EdgeInsets.all(8),
						      decoration: BoxDecoration(
							      borderRadius: BorderRadius.circular(5),
							      color: buttonColor
						      ),
						      child: tdsReturnDate(),
						    ),
				      )
			      ],
		      ),
	      ),
      ),
    );
  }
}

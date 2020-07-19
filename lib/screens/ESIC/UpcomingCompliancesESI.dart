import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/screens/ESIC/MonthlyContribution.dart';
import 'package:unified_reminder/services/UpComingComplianceDatabaseHelper.dart';
import 'package:unified_reminder/styles/colors.dart';


class UpcomingCompliancesES extends StatefulWidget {
	
	final Client client;

  const UpcomingCompliancesES({Key key, this.client}) : super(key: key);
	
  @override
  _UpcomingCompliancesESState createState() => _UpcomingCompliancesESState();
}



class _UpcomingCompliancesESState extends State<UpcomingCompliancesES> {
	
	DateTime currentDate = DateTime.now();
	
	String monthlyDueDate = ' ';
	
	
	Future<String> checkAdmin() async{
		DateTime dateTime = DateTime(currentDate.year , currentDate.month + 1 , 21);
		monthlyDueDate = await UpComingComplianceDatabaseHelper().monthlyESI(DateFormat('MMMM').format(dateTime));
		print(monthlyDueDate);
		if(monthlyDueDate == '0'){
			setState(() {
				monthlyDueDate = monthlyESI();
			});
		}
		else{
			print(monthlyDueDate);
//			monthlyDueDate.replaceAll(" ", '');
			dateTime = DateTime(currentDate.year , currentDate.month + 1 , int.parse(monthlyDueDate));
			setState(() {
			  monthlyDueDate = DateFormat('dd MMMM').format(dateTime);
			});
		}
	}
	
	String monthlyESI() {
		DateTime dateTime = DateTime(currentDate.year , currentDate.month + 1 , 21);
		String dueDate = DateFormat('dd MMMM').format(dateTime);
		return dueDate;
	}
	
	
	
	String fillingReturn() {
		int month = currentDate.month;
		
		if(month >= 4 && month<=9){
			return '11 November';
		}
		
		else{
			return '11 May';
		}
	}
	
	
	
	@override
  void initState() {
    super.initState();
    checkAdmin() ;
  }
	
	
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
	    appBar :AppBar(
		    title: Text('Upcoming Compliances'),
	    ),
	    
	    body: SingleChildScrollView(
		    child: Container(
			    padding: EdgeInsets.all(24),
			    child: Column(
				    crossAxisAlignment: CrossAxisAlignment.stretch,
				    children: <Widget>[
				    	
				    	SizedBox(height: 50,),
				    	
				    	GestureDetector(
						    onTap: (){
						    	Navigator.push(context, MaterialPageRoute(
								    builder: (context)=>  MonthlyContributionESIC(
									    client: widget.client,
								    )
							    ));
						    },
				    	  child: Container(
						    padding: EdgeInsets.all(10),
						    decoration: BoxDecoration(
								    borderRadius: BorderRadius.circular(5),
								    color: buttonColor
						    ),
						    
						    child: Column(
							    crossAxisAlignment: CrossAxisAlignment.stretch,
							    children: <Widget>[
							    	Row(
							    	  children: <Widget>[
							    	    Text('Due Date of current month :  ',style: TextStyle(
									        fontSize: 15,
								        ),),
									      
									      Text('$monthlyDueDate', style: TextStyle(
										      fontSize: 15,
										      fontWeight: FontWeight.bold,
									      ),),
							    	  ],
							    	),
								    SizedBox(height: 10,),
								    Text('Tap to add Payment Record',style: TextStyle(
									    fontSize: 8,
									    fontStyle: FontStyle.italic,
								    ),),
							    ],
						    )
					    ),
				    	),
					    
					    SizedBox(height: 30,),
					
					    Container(
							    padding: EdgeInsets.all(10),
							    decoration: BoxDecoration(
									    borderRadius: BorderRadius.circular(5),
									    color: buttonColor
							    ),
							    child: Column(
								    crossAxisAlignment: CrossAxisAlignment.stretch,
								    children: <Widget>[
									    Row(
										    children: <Widget>[
											    Text('Due Date of filling of Return :  ',style: TextStyle(
												    fontSize: 15,
											    ),),
											
											    Text(fillingReturn(), style: TextStyle(
												    fontSize: 15,
												    fontWeight: FontWeight.bold,
											    ),softWrap: true,),
										    ],
									    ),
									    SizedBox(height: 10,),
									    Text('Tap to add return filling record ',style: TextStyle(
										    fontSize: 8,
										    fontStyle: FontStyle.italic,
									    ),),
								    ],
							    )
					    ),
					    
					    
					    
				    ],
			    ),
		    ),
	    ),
    );
  }
}

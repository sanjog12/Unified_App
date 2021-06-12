

import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/MutualFundObject.dart';
// import 'package:unified_reminder/models/MutualFundRecordObject.dart';

class HistoryForMF{
	final String  key,amount,type,frequency,totalInvestment,keyDate,id,sipFrequency;
	final MutualFundObject mutualFundObject;
	final MutualFundDetailObject mutualFundDetailObject,todayNAV;
	
	HistoryForMF({this.todayNAV,
		this.id,
		this.sipFrequency,
		this.key,
		this.keyDate,
		this.totalInvestment,
		this.type,
		this.frequency,
		this.amount,
		this.mutualFundObject,
		this.mutualFundDetailObject});
}
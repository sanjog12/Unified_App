

import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/MutualFundObject.dart';
import 'package:unified_reminder/models/MutualFundRecordObject.dart';

class HistoryForMF{
	final String  key,amount,type,frequency,totalInvestment,keyDate;
	final MutualFundObject mutualFundObject;
	final MutualFundDetailObject mutualFundDetailObject,todayNAV;
	
	HistoryForMF({this.todayNAV,
		this.key,
		this.keyDate,
		this.totalInvestment,
		this.type,
		this.frequency,
		this.amount,
		this.mutualFundObject,
		this.mutualFundDetailObject});
}
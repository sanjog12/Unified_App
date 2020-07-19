import 'package:intl/intl.dart';

class DateChange{
	
	static int day ,month , year;
	
	static String addMonthToDate(String date , int i) {
		List<String> dateTemp = date.split('-');
		day = int.parse(dateTemp[0]);
		month = int.parse(dateTemp[1]) + i;
		year = int.parse(dateTemp[2]);
		DateTime date2 = DateTime(year, month , day);
		String d1 = date2.toString();
		List<String> d2 = d1.split(' ');
		String d3 = d2[0];
		List<String> d4 = d3.split('-');
		String finalDate = '${d4[2]}-${d4[1]}-${d4[0]}';
		return finalDate;
	}
	
	static String addDayToDate(String date, int i){
		List<String> dateTemp = date.split('-');
		day = int.parse(dateTemp[0]) + i;
		month = int.parse(dateTemp[1]);
		year = int.parse(dateTemp[2]);
		DateTime date2 = DateTime(year, month , day);
		String d1 = date2.toString();
		List<String> d2 = d1.split(' ');
		String d3 = d2[0];
		List<String> d4 = d3.split('-');
		String finalDate = '${d4[2]}-${d4[1]}-${d4[0]}';
		return finalDate;

	}
	
	
}
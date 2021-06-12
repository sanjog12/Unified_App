
class DateChange{
	
	static int day ,month , year;
	
	static String addMonthToDate(String date , int monthToBeAdded) {
		List<String> dateTemp = date.split('-');
		day = int.parse(dateTemp[0]);
		month = int.parse(dateTemp[1]) + monthToBeAdded;
		year = int.parse(dateTemp[2]);
		List<String> dateString = DateTime(year, month , day).toString().split(' ')[0].split('-');
		String finalDate = '${dateString[2]}-${dateString[1]}-${dateString[0]}';
		return finalDate;
	}
	
	static String addDayToDate(String date, int daysToBeAdded){
		List<String> dateTemp = date.split('-');
		day = int.parse(dateTemp[0]) + daysToBeAdded;
		month = int.parse(dateTemp[1]);
		year = int.parse(dateTemp[2]);
		List<String> dateString = DateTime(year, month , day).toString().split(' ')[0].split('-');
		String finalDate = '${dateString[2]}-${dateString[1]}-${dateString[0]}';
		return finalDate;

	}
	
	
}
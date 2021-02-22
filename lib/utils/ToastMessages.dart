import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

recordDeletedToast() {
	return Fluttertoast.showToast(
			msg: "Deleted Successfully",
			toastLength: Toast.LENGTH_SHORT,
			gravity: ToastGravity.BOTTOM,
			backgroundColor: Color(0xff666666),
			textColor: Colors.white,
			fontSize: 16.0);
}

recordEditToast() {
	return Fluttertoast.showToast(
			msg: "Details Updated",
			toastLength: Toast.LENGTH_SHORT,
			gravity: ToastGravity.BOTTOM,
			backgroundColor: Color(0xff666666),
			textColor: Colors.white,
			fontSize: 16.0);
}

flutterToast({String message}){
	return Fluttertoast.showToast(
			msg: message,
			toastLength: Toast.LENGTH_SHORT,
			gravity: ToastGravity.BOTTOM,
			backgroundColor: Color(0xff666666),
			textColor: Colors.white,
			fontSize: 16.0);
}

ShowToastMessage(BuildContext context,{String title, String content}) async{
	return showDialog(
		context: context,
		builder: (context){
			return AlertDialog(
				title: Text(title),
				content: Text(content),
				
			);
		}
	);
}
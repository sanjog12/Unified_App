import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:random_string/random_string.dart';
import 'package:unified_reminder/models/client.dart';
import 'package:unified_reminder/services/SharedPrefs.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices{
	
	
	FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
	AndroidInitializationSettings androidInitializationSettings;
	IOSInitializationSettings iosInitializationSettings;
	InitializationSettings initializationSettings;
	
	int getRandomInt() {
		int a = int.parse(randomNumeric(6));
		return a;
	}
	
	void initializeSetting() async{
		tz.initializeTimeZones();
		androidInitializationSettings = AndroidInitializationSettings("new_logo");
		// AndroidNotificationSound();
		iosInitializationSettings = IOSInitializationSettings();
		initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
		// await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
	}
	
	
	// void showNotification(String titleString, String bodyString) async{
	// 	await _notification(titleString,bodyString);
	// }
	//
	//
	// Future<void> _notification(String titleString, String bodyString) async{
	// 	AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
	// 		'Channel _ID',
	// 		'Channel title',
	// 		'channel body',
	// 		priority: Priority.high,
	// 		importance: Importance.max,
	// 		ticker: 'test',
	//
	// 	);
	//
	// 	IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
	//
	// 	NotificationDetails notificationDetails = NotificationDetails();
	// 	await flutterLocalNotificationsPlugin.show(0, titleString, bodyString, notificationDetails);
	// }
	
	
	
	Future<void> reminderNotificationService(String notificationId ,String titleString, String bodyString,DateTime scheduleTime) async{
		
		FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
		firebaseDatabase
				.reference()
				.child('ScheduledNotifications')
		    .child(scheduleTime.year.toString())
		    .child(scheduleTime.month.toString())
				.push()
				.set({
			'notificationID' : notificationId,
			'titleString' : titleString,
			'bodyString' : bodyString,
			'time' : scheduleTime.toString(),
			'uid' : FirebaseAuth.instance.currentUser.uid,
		});
	}
	
	Future<void> deleteNotification(String id) async{
		// await flutterLocalNotificationsPlugin.cancel(id);
	}
	
	Future<void> notificationRecord(Client client,String id,DateTime time) async{
		final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
		DatabaseReference dbf;
		String uid = await SharedPrefs.getStringPreference('uid');
		String a1 = time.toString().split(" ")[0];
		List<String> a2 = a1.split('-');
		String date = "${a2[2]}-${a2[1]}-${a2[0]}";
		dbf = firebaseDatabase.reference();
		dbf
				.child("NotificationWork")
		    .child(uid)
		    .child(client.email)
		    .child(id)
				.set(date);
	}
	
}
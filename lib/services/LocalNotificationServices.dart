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
		androidInitializationSettings = AndroidInitializationSettings("logo");
		iosInitializationSettings = IOSInitializationSettings();
		initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
		await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
	}
	
	
	void showNotification(String titleString, String bodyString) async{
		await _notification(titleString,bodyString);
	}
	
	
	void setReminderNotification({int id ,String titleString, String bodyString, DateTime scheduleTime}) async{
		await reminderNotificationService(id: id,titleString: titleString, bodyString: bodyString,scheduleTime: scheduleTime);
	}
	
	
	
	Future<void> _notification(String titleString, String bodyString) async{
		AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
			'Channel _ID',
			'Channel title',
			'channel body',
			priority: Priority.high,
			importance: Importance.max,
			ticker: 'test',
			
		);
		
		IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
		
		NotificationDetails notificationDetails = NotificationDetails();
		await flutterLocalNotificationsPlugin.show(0, titleString, bodyString, notificationDetails);
	}
	
	
	
	Future<void> reminderNotificationService({int id ,String titleString, String bodyString,DateTime scheduleTime}) async{
		
		AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
			'Channel _ID',
			'Channel title',
			'channel body',
			priority: Priority.high,
			importance: Importance.max,
			ticker: 'test',
			enableLights: true,
		);
		
		tz.TZDateTime time = tz.TZDateTime.from(
			scheduleTime,
			tz.local,
		);
		
		_notification("Test", "test body");
		NotificationDetails notificationDetails = NotificationDetails();
		await flutterLocalNotificationsPlugin.zonedSchedule(id, titleString, bodyString, time, notificationDetails,
				androidAllowWhileIdle: true,uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime );
	}
	
	Future<void> onSelectNotification(String payLoad) async{
		
		if(payLoad != null){
			print(payLoad);
		}
	}
	
	Future<void> deleteNotification(int id) async{
		await flutterLocalNotificationsPlugin.cancel(id);
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
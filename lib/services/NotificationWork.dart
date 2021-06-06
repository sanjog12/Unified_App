import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/main.dart';



class NotificationServices{
	
	
	
	
	static firebaseMessagingFCM() async{
		
		final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
		DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
		DatabaseReference dbf;
		FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
		String uid = FirebaseAuth.instance.currentUser.uid;
		
		await firebaseMessaging.setForegroundNotificationPresentationOptions(
			alert: true,
			badge: true,
			sound: true,
		);
		
		firebaseMessaging.setAutoInitEnabled(false);
		
		
		NotificationSettings settings = await firebaseMessaging.requestPermission(sound: true, criticalAlert: true,alert: true,
			announcement: false,
			badge: true,
			carPlay: false,
			provisional: false,);
		if (settings.authorizationStatus == AuthorizationStatus.authorized) {
			print('User granted permission');
		} else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
			print('User granted provisional permission');
		} else {
			print('User declined or has not accepted permission');
		}
		
		
		await firebaseMessaging.getToken().then(( String value) async{
			if(uid != "null") {
				AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
				print(androidDeviceInfo.androidId.substring(0,10));
				dbf = firebaseDatabase.reference();
				dbf
						.child("FCMTokens")
						.child(uid)
						.child("-${androidDeviceInfo.androidId.substring(0,10)}")
						.set(value);
			}
		});
		
		firebaseMessaging.onTokenRefresh.forEach((element) {

		});
		
		FirebaseMessaging.instance.unsubscribeFromTopic('general');
		
		FirebaseMessaging.instance.onTokenRefresh.forEach((String element) async{
			AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
			print(androidDeviceInfo.androidId.substring(0,10));
			dbf = firebaseDatabase.reference();
			dbf
					.child("FCMTokens")
					.child(uid).child("-${androidDeviceInfo.androidId.substring(0,10)}")
					.set(element);
		});
		
		FirebaseMessaging.onMessage.first.then((element){
			return showGeneralDialog(
					barrierColor: Colors.black.withOpacity(0.5),
					transitionBuilder: (context, a1, a2, widget) {
						final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
						return Transform(
							transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
							child: AlertDialog(
								title: Column(
									children: [
										Text(element.data['title']),
										Divider(color: Colors.blue,thickness: 1,),
									],
								),
								content: Text(element.data['body']),
								actions: [
									TextButton(
											onPressed: (){
												Navigator.pop(context);
											},
											child: Text("OK")),
									element.data["daysRemaining"].toString() == "3"
											?TextButton(
										onPressed: (){
										
										},
										child: Text("Remind on Due Date"),
									):Container(),
								],
							),
						);
					},
					transitionDuration: Duration(milliseconds: 200),
					context: navigatorKey.currentContext,
					pageBuilder: (context, animation1, animation2) {});
		});
	}
	
	
	
	
	
	
	
	
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
	
	
}




Future<void> backGroundNotificationHandler(RemoteMessage message) async{
	
	await Firebase.initializeApp();
	AwesomeNotifications().createNotification(
		content: NotificationContent(
			id: 10,
			channelKey: 'basic_channel',
			title: message.data['title'],
			body: message.data['body'],
			color: Colors.blue,
		
		),
		actionButtons: message.data["daysRemaining"].toString() == "3"
		?([
			NotificationActionButton(
				key: "cancel notification",
				label: "Ok",
				enabled: true,
				buttonType: ActionButtonType.Default,
			),
		])
	:([
			NotificationActionButton(
				key: "cancel notification",
				label: "Ok",
				enabled: true,
				buttonType: ActionButtonType.Default,
			),
			NotificationActionButton(
				key: "remind button pressed",
				label: "Remind on Due Date",
				enabled: true,
				buttonType: ActionButtonType.Default,
			)
		
		]),
	);
}
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
		DatabaseReference dbf;
		FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
		
		await firebaseMessaging.setForegroundNotificationPresentationOptions(
			alert: true,
			badge: true,
			sound: true,
		);
		
		
		
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
		
		
		await firebaseMessaging.getToken().then(( String value){
			String uid = FirebaseAuth.instance.currentUser.uid?? "null";
			if(uid != "null") {
				dbf = firebaseDatabase.reference();
				dbf
						.child("FCMTokens")
						.child(uid)
						.set({value.substring(0, 10): value});
			}
		});
		
		FirebaseMessaging.instance.unsubscribeFromTopic('general');
		
		FirebaseMessaging.onMessage.forEach((element) {
			print("got text");
			return showDialog(context: navigatorKey.currentContext,
					builder: (context) => AlertDialog(
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
							):null,
						],
					)
			);
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
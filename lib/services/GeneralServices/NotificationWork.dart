import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:unified_reminder/main.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';

class NotificationServices {
  static firebaseMessagingFCM() async {
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

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      sound: true,
      criticalAlert: true,
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    await firebaseMessaging.getToken().then((String value) async {
      if (uid != "null") {
        AndroidDeviceInfo androidDeviceInfo =
            await deviceInfoPlugin.androidInfo;
        
        dbf = firebaseDatabase.reference();
        dbf
            .child("FCMTokens")
            .child(uid)
            .child("-${androidDeviceInfo.androidId.substring(0, 10)}")
            .set(value);
      }
    });

    FirebaseMessaging.instance.unsubscribeFromTopic('general');

    FirebaseMessaging.instance.onTokenRefresh.forEach((String element) async {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      print(androidDeviceInfo.androidId.substring(0, 10));
      dbf = firebaseDatabase.reference();
      dbf
          .child("FCMTokens")
          .child(uid)
          .child("-${androidDeviceInfo.androidId.substring(0, 10)}")
          .set(element);
    });

    FirebaseMessaging.onMessage.first.then((element) async{
      List<String> list = await SharedPrefs.getListStringPreference('notification');
      list.add( DateFormat.yMd().add_jm().format(DateTime.now()) + ',' + element.data['body'].toString() );
      SharedPrefs.setListStringPreference('notification', list);
      return showDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          context: navigatorKey.currentContext,
          builder: (context) {
            return AlertDialog(
              title: Column(
                children: [
                  Text(element.data['title']),
                  Divider(
                    color: Colors.blue,
                    thickness: 1,
                  ),
                ],
              ),
              content: Text(element.data['body']),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK")),
                element.data["daysRemaining"].toString() == "3"
                    ? TextButton(
                        onPressed: () {},
                        child: Text("Remind on Due Date"),
                      )
                    : Container(),
              ],
            );
          });
    });
  }

  Future<void> reminderNotificationService(String notificationId,
      String titleString, String bodyString, DateTime scheduleTime) async {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    if(scheduleTime.isAfter(DateTime.now())) {
      firebaseDatabase.reference().child('ScheduledNotifications').push().set({
        'notificationID': notificationId,
        'titleString': titleString,
        'bodyString': bodyString,
        'time': scheduleTime.toString(),
        'uid': FirebaseAuth.instance.currentUser.uid,
      });
    }
  }

  Future<void> deleteNotification(String id) async {
    await FirebaseDatabase.instance
        .reference()
        .child('ScheduledNotifications')
        .orderByChild("notificationID")
        .equalTo(id)
        .once()
        .then((value) async{
      Map<dynamic, dynamic> map = await value.value;
      map.forEach((key, value) async{
        if(key != null) {
          await FirebaseDatabase.instance
              .reference()
              .child("ScheduledNotifications/$key")
              .remove();
        }
      });
    });
  }

  Future<void> modifyNotification(
    String id,
    String date,
  ) async {}
}

Future<void> backGroundNotificationHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  SharedPrefs.setStringPreference('newNotification', 'true');
  List<String> list = await SharedPrefs.getListStringPreference('notification');
  // list.add( DateFormat.yMd().add_jm().format(DateTime.now()) + ',' + message.data['body'].toString() );
  // SharedPrefs.setListStringPreference('notification', list);
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: int.parse(randomNumeric(3)),
      channelKey: 'grouped',
      title: message.data['title'],
      body: message.data['body'],
      color: Colors.blue,
    ),
    actionButtons: [
      NotificationActionButton(
        key: "cancel notification",
        label: "Ok",
        enabled: true,
        buttonType: ActionButtonType.Default,
      ),]
  );
}

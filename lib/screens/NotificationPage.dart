import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/services/GeneralServices/SharedPrefs.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  GlobalKey<AnimatedListState> _myListKey = GlobalKey<AnimatedListState>();
  List<String> notifier = [];

  Future<void> getNotification() async {
    notifier = await SharedPrefs.getListStringPreference('notification');
    print(notifier);
    if (notifier == []) {
      notifier.add("  , NOTHING TO SHOW");
    }
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    getNotification().whenComplete(() {
      for (int i = 0; i < notifier.length; i++) {
        _myListKey.currentState.insertItem(i);
        Future.delayed(Duration(milliseconds: 100));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        actions: [
          TextButton(
            onPressed: () {
              SharedPrefs.removePreference("notification");
              for(int i =0; i< notifier.length; i++){
                _myListKey.currentState.removeItem(i, (context, animation) => SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset(0, 0),
                  ).animate(animation),
                  child: Card(
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                    ),
                  ),
                ));
              }
            },
            child: Text(
              "Clear All Notification",
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(top: 50, left: 5, right: 5),
          child: notifier == []
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.announcement_outlined,
                        size: 40,
                        color: Colors.red,
                      ),
                      Text("Nothing to show")
                    ],
                  ),
                )
              : AnimatedList(
                  key: _myListKey,
                  initialItemCount: notifier.length,
                  itemBuilder:
                      (BuildContext context, int index, Animation animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset(0, 0),
                      ).animate(animation),
                      child: Card(
                        borderOnForeground: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Text(
                                notifier[index].toString().split(',')[0] + "  ",
                                style: TextStyle(color: Colors.blue),
                              ),
                              Text(
                                notifier[index].toString().split(',')[1],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
    );
  }
}

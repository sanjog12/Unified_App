import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/models/userbasic.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:unified_reminder/styles/styles.dart';

class ProUserProfileScreen extends StatefulWidget {
  final UserBasic userBasic;

  const ProUserProfileScreen({Key key, this.userBasic}) : super(key: key);
  @override
  _ProUserProfileScreenState createState() => _ProUserProfileScreenState();
}

class _ProUserProfileScreenState extends State<ProUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(15),
                decoration: fieldsDecoration,
                child: Text(
                  widget.userBasic.fullName != null ?widget.userBasic.fullName:"Google user",
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              ),
              
              SizedBox(height: 20),
  
              Container(
                padding: EdgeInsets.all(15),
                decoration: fieldsDecoration,
                child: Text(
                  widget.userBasic.phoneNumber != null ? widget.userBasic.phoneNumber:"Google user",
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              ),
              
              SizedBox(height: 20),
  
              Container(
                padding: EdgeInsets.all(15),
                decoration: fieldsDecoration,
                child: Text(
                  widget.userBasic.email,
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

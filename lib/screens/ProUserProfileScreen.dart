import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProUserProfileScreen extends StatefulWidget {
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
        ),
      ),
    );
  }
}

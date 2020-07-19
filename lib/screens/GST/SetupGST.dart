import 'package:flutter/material.dart';

class SetupGST extends StatelessWidget {
  final Map arguments;
  SetupGST({this.arguments});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("GST Setup For ${arguments['client']['name']}")),
    );
  }
}

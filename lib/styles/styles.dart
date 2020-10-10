import 'package:flutter/material.dart';
import 'package:unified_reminder/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';

InputDecoration buildCustomInput({String hintText}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: 0.0,
      horizontal: 16.0,
    ),
    fillColor: textboxColor,
    hintText: hintText,
    labelStyle: TextStyle(
      color: Colors.white,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.0,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    filled: true,
  );
}

InputDecoration dropDownDecoration() {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: 0.0,
      horizontal: 8.0,
    ),
    fillColor: textboxColor,
    labelStyle: TextStyle(
      color: Colors.white,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.0,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    filled: true,
  );
}

BoxDecoration fieldsDecoration = BoxDecoration(
  color: textboxColor,
  border: Border.all(
    width: 0.0,
    style: BorderStyle.none,
  ),
  borderRadius: BorderRadius.circular(8.0),
);


BoxDecoration roundedCornerButton = BoxDecoration(
  color: buttonColor,
  borderRadius: BorderRadius.circular(10),
);

Widget helpButtonActionBar(String url){
  return Center(
    child: GestureDetector(
      onTap: (){
        launch(url);
      },
      child: Text("Help    ",style: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 12,
      ),),
    ),
  );
}

Widget helpButtonBelow(String url){
  return GestureDetector(
    child: Text("Need Help? Click for expert advices",style: TextStyle(
      fontSize: 12,
      fontStyle: FontStyle.italic,
    ),),
    onTap: (){
      launch(url);
    },
  );
}
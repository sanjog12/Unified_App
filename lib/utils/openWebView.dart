import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unified_reminder/screens/WebView.dart';

void openWebView(String label, String link, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebViewPage(
        label: label,
        link: link,
      ),
    ),
  );
}

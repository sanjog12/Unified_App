
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String label, link;

  const WebViewPage({this.label, this.link});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Container(
        child:WebView(
          initialUrl: 'https://flutter.dev',
        ),
      ),
    );
  }
}

import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebView extends StatelessWidget {
  final String label, link;

  const WebView({this.label, this.link});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Container(
        child: EasyWebView(
          onLoaded: (){},
          src: link,
          isHtml: false, // Use Html syntax
          isMarkdown: false, // Use markdown syntax
        ),
      ),
    );
  }
}

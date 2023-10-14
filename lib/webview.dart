import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'constants.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF0F0F0),
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        centerTitle: true,
        title: Text(
            'Full Article',
          style: kTextStyle.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

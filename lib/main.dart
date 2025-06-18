import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const RadioKpopApp());

class RadioKpopApp extends StatelessWidget {
  const RadioKpopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RadioHomePage(),
    );
  }
}

class RadioHomePage extends StatelessWidget {
  const RadioHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'assets/index.html',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

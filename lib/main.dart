import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import './screens/Home.dart';

void main() => runApp(new App());

String selectedUrl = "https://flutter.io";

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Geeky News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.orange
      ),
      routes: {
        "/": (_) => HomeScreen(),
      },
    );
  }
}

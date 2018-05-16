import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './screens/Home.dart';

void main() => runApp(new App());

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
      home: Home(),
    );
  }
}

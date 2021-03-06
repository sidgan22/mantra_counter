import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mantracounter/screens/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japam Counter',

      theme: ThemeData(

      ),
      home: MyHomePage(title: 'Gayatri Japam Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, Home);
  }
  void Home()
  {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=> HomePage()));
  }
  @override
  void initState() {
    // TODO: implement initState
    startTime();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset('lib/assets/logo.jpg')
    );
  }
}

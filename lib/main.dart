import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared preferences demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
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
  int _counter = 0;
  String eta="";
  String sttime;
  DateTime startTime;
  DateTime timeNow;
  DateTime etafinal=DateTime.now();
  var timeDiff;
  var t;
  var avgTime=0.0000;
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sttime = DateTime.now().hour.toString()+':'+DateTime.now().minute.toString();
      startTime = DateTime.now();
      prefs.setString('starttime', sttime);
      _counter = (prefs.getInt('counter') ?? 0);
      etafinal=DateTime.now();

      if(prefs.getInt('counter')==0)
      {
        _loadStartTime();
      }
    });
  }
  _resetValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      startTime = DateTime.now();
      sttime = DateTime.now().hour.toString()+':'+DateTime.now().minute.toString();
      prefs.setString('starttime', sttime);
      _counter = (prefs.getInt('counter') ?? 0) *0 ;
      etafinal=DateTime.now();
      avgTime=0;
      prefs.setInt('counter', _counter);
    });
  }
  //Incrementing counter after click
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      _counter = (prefs.getInt('counter') ?? 0) + 1;
      timeNow = DateTime.now();
      timeDiff = timeNow.difference(startTime).inSeconds.floor();
      avgTime = timeDiff/_counter;
      t = (avgTime*1008).floor();
      print(t);
      etafinal = startTime.add(Duration(seconds:t));
      prefs.setInt('counter', _counter);
    });

  }
  _decrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var cnt = prefs.getInt('counter');
      if(cnt>0)

      {
        _counter = (prefs.getInt('counter') ?? 0) - 1;
        timeNow = DateTime.now();
        timeDiff = timeNow.difference(startTime).inSeconds;
        avgTime = timeDiff/_counter;


        t = (avgTime*1008).floor();
        print(t);
        etafinal = startTime.add(Duration(seconds:t));
        prefs.setInt('counter', _counter);

      }
    });
  }
  _loadStartTime() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sttime = (prefs.getString('starttime') ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    var ht = (MediaQuery.of(context).size/3).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child:RaisedButton(
                color: Colors.orange,
                onPressed: _resetValue,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                  Center(child: Text('RESET',style:Theme.of(context).textTheme.headline6,),),
                ),
              ) ,
            ),
            Expanded(
              flex: 1,
              child: RaisedButton(
                color: Colors.amberAccent,
                onPressed: _decrementCounter,
                child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width,
                    child:Icon(Icons.remove)
                ),
              ),
            ),
//            Divider(),
//            SizedBox(height: MediaQuery.of(context).size.height/6,),
            Expanded(
              flex: 3,
              child: Center(child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Start time: $sttime'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text('ETA: ${etafinal.hour}:${etafinal.minute} Avg.Time : ${avgTime.toStringAsPrecision(3)}')
                ],
              )),
            ),
            Expanded(
              flex: 3,
              child: RaisedButton(
                color: Colors.amberAccent,
                onPressed: _incrementCounter,
                child: Container(
                    height: 220.0,
                    width: MediaQuery.of(context).size.width,
                    child:Icon(Icons.add)
                ),
              ) ,
            )
//            SizedBox(height: MediaQuery.of(context).size.height/8,),

          ],
        ),
      ),
    );
  }
}

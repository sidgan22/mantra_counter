import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      _counter = 0 ;
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
  TextEditingController skipController,targetController;
  FocusNode skFocus=FocusNode(),tgFocus=FocusNode();
  @override
  Widget build(BuildContext context) {
    var ht = (MediaQuery.of(context).size/3).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gayathri Japam Count'),
      ),
      drawer:Drawer(
        child: Container(),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child:
                Row(
                  children: <Widget>[
                    Text('Skip By: '),
                    Container(
                      width:20,
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        onChanged: skipBy(),
                        focusNode: skFocus,
                        controller: skipController,
                      ),
                    ),
                    Text('Target: ')
                  ],
                )
            ),
            Expanded(
              flex: 1,
              child:RaisedButton(
                color: Colors.orange,
                onPressed: _resetValue,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                  Center(child: Text('START/RESET',style:Theme.of(context).textTheme.headline6,),),
                ),
              ) ,
            ),

            Expanded(
              flex: 1,
              child: Padding(

                padding: EdgeInsets.only(top:20.0),
                child: RaisedButton(
                  shape:  RoundedRectangleBorder(borderRadius:BorderRadius.circular(250.0)),
                  color: Colors.amberAccent,
                  onPressed: _decrementCounter,
                  child: Container(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width,
                      child:Icon(Icons.remove,size: 50.0,)
                  ),
                ),
              ),
            ),
//            SizedBox(height: MediaQuery.of(context).size.height/6,),
            Expanded(
              flex: 3,
              child: Center(child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Start time: $sttime | Target: 1008'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text('ETC: ${etafinal.hour}:${etafinal.minute} | Avg.Time : ${avgTime.toStringAsPrecision(3)}s')
                ],
              )),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(bottom:20.0),
                child: RaisedButton(
                    shape:  RoundedRectangleBorder(borderRadius:BorderRadius.circular(250.0)),
                  color: Colors.amberAccent,
                  onPressed: _incrementCounter,
                  child: Container(
                      margin: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child:Center(child: Icon(Icons.add,size: 50,))
                  ),
                ),
              ) ,
            )
//            SizedBox(height: MediaQuery.of(context).size.height/8,),

          ],
        ),
      ),
    );
  }

  skipBy() {

   }

}

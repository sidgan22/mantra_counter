import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
final gkey = GlobalKey<ScaffoldState>();
class _HomePageState extends State<HomePage> {
  int _counter = 0;

  String sttime;
  DateTime startTime;
  DateTime timeNow;
  DateTime etafinal=DateTime.now();
  var timeDiff;
  int skValue=1;
  int tgValue=1008;
  var t;
  var avgTime=0.0000;
  @override
  void initState() {
    super.initState();
    _loadCounter();
    setState(() {
      targetController.text='1008';
      skipController.text='1';
    });
  }
  TextEditingController skipController=TextEditingController();
  TextEditingController targetController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    var ht = (MediaQuery.of(context).size/3).toString();
    var txt = Theme.of(context).textTheme;

    return Scaffold(
      key: gkey,
      appBar: AppBar(
        backgroundColor: Color(0xff5D7635),
        title: Text('Japam Counter'),
        centerTitle: true,
//        actions: <Widget>[
//          FlatButton.icon(onPressed: (){}, icon: Icon(Icons.settings,color: Colors.white,),label: Text(''),)
//        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffD3CCE3), Color(0xffE9E4F0)])

        ),
//            height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:10.0,left:10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Skip By: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: txt.subtitle1.fontSize,),),
                  Container(
                    width: 30.0,
                    child:TextField(
                      inputFormatters: [LengthLimitingTextInputFormatter(3),WhitelistingTextInputFormatter.digitsOnly,],
                      maxLengthEnforced: true,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: txt.bodyText1.fontSize,),
                      keyboardType: TextInputType.number,
                      controller: skipController,

                      onSubmitted: (val){
                        if(int.parse(skipController.text)<=0 || int.parse(skipController.text)>tgValue ) {
                          setState(() {
                            skipController.text = '1';
                            skValue = 1;
                          });
                        }
                      },
                        onChanged: (val){
                        setState(() {
                          skValue=int.parse(skipController.text);
                        });},

//                      InputDecoration(
//                          focusedBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Colors.green))),
                    ),
                  ),

                  Text('Target: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: txt.subtitle1.fontSize,)),
                  Container(
                      width: 50.0,
                      child: TextField(
                        inputFormatters: [LengthLimitingTextInputFormatter(4),WhitelistingTextInputFormatter.digitsOnly,],
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: txt.bodyText1.fontSize,),
                        controller: targetController,
                        autofocus: false,
                        onSubmitted: (val){if(int.parse(targetController.text)<=0){
                          setState(() {
                            targetController.text='1';
                            tgValue=1;
                          });}

                        },

                        onChanged: (val){setState(() {
                          tgValue=int.parse(targetController.text);
                          _resetValue();
                        });},
                        keyboardType: TextInputType.number,
                      ),),

                  FlatButton.icon(onPressed: _resetValue, icon: Icon(Icons.refresh,), label: Text('REFRESH',style: txt.bodyText1,),color: Colors.green,),


                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top:20.0),
                child: RaisedButton(
                  shape:  RoundedRectangleBorder(borderRadius:BorderRadius.circular(250.0)),
                  color: Color(0xffDD9C5C),
                  onPressed: _decrementCounter,
                  child: Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.remove,size: 50.0,),
                          Text(skValue.toString(),style: TextStyle(fontSize: 30),)
                        ],
                      )
                  ),
                ),
              ),
            ),
//            SizedBox(height: MediaQuery.of(context).size.height/6,),
            Expanded(
              flex: 2,
              child: Center(
                  child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Start time: $sttime \t\t | \t\t  Target: $tgValue',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,)),
                  Text(
                    '$_counter',
//                      style: Theme.of(context).textTheme.headline1,
                      style: TextStyle(fontWeight: FontWeight.w200,fontSize: Theme.of(context).textTheme.headline1.fontSize,)
                  ),
                  Text('ETC: ${etafinal.hour}:${DateFormat('mm').format(etafinal)} \t\t | \t\t Avg.Time : ${avgTime.toStringAsPrecision(2)} s',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,))
                ],
              )),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(bottom:20.0),
                child: RaisedButton(
                    shape:  RoundedRectangleBorder(borderRadius:BorderRadius.circular(250.0)),
                  color: Color(0xffDD9C5C),
                  onPressed:_incrementCounter,
                  child: Container(
                      margin: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      child:Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add,size: 50,),
                          Text(skValue.toString(),style: TextStyle(fontSize: 30),)
                        ],
                      ))
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

//Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sttime =DateTime.now().hour.toString()+':'+DateFormat('mm').format(DateTime.now()).toString();
      startTime = DateTime.now();
//      prefs.setString('starttime', sttime);
//      _counter = (prefs.getInt('counter') ?? 0);
      _counter = 0;
      etafinal=DateTime.now();

//      if(prefs.getInt('counter')==0)
//      {
//        _loadStartTime();
//      }
    });
  }
  _resetValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      startTime = DateTime.now();
      sttime = DateTime.now().hour.toString()+':'+DateFormat('mm').format(DateTime.now()).toString();
      prefs.setString('starttime', sttime);
      _counter = 0 ;
      etafinal=DateTime.now();
      avgTime=0;
      prefs.setInt('counter', _counter);
    });
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Completed"),
          content: new Text("Average time: $avgTime s\nStart time: ${DateFormat('kk:mm').format(startTime)}\nEnd time: ${DateFormat('kk:mm').format(etafinal)}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },


            ),
            FlatButton(
              child: new Text("Reset time"),
              onPressed: () {
                _resetValue();
                Navigator.of(context).pop();
              },),
          ],
        );
      },
    );
  }
  //Incrementing counter after click
   _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      if(_counter+skValue<=tgValue)
        {
          _counter += skValue;
//          _counter = (prefs.getInt('counter') ?? 0) + skValue;
          timeNow = DateTime.now();
          timeDiff = timeNow.difference(startTime).inSeconds.floor();
          avgTime = timeDiff/_counter;
          t = (avgTime*tgValue).floor();
          print(t);
          etafinal = startTime.add(Duration(seconds:t));
//          prefs.setInt('counter', _counter);
          if(_counter==tgValue)
            {
              _showDialog();
            }
        }
      else

      {
        setState(() {
          _counter=tgValue;
        });

        etafinal=DateTime.now();
        _showDialog();
      }


      });

  }
  _decrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(_counter-skValue>=0)

      {
        _counter -= skValue;
//        _counter = (prefs.getInt('counter') ?? 0) - skValue;
        timeNow = DateTime.now();
        timeDiff = timeNow.difference(startTime).inSeconds;
        avgTime = timeDiff/_counter;


        t = (avgTime*1008).floor();
        etafinal = startTime.add(Duration(seconds:t));
//        prefs.setInt('counter', _counter);

      }
    });
  }
  _loadStartTime() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sttime = (prefs.getString('starttime') ?? "");
    });
  }

}

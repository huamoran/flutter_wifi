import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wifi/flutter_wifi.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Wifi',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _wifiName = 'click button to get wifi ssid.';
  String _moran = 'click button to get moran.';
  int level = 0;
  String _ip = 'click button to get ip.';
  List<WifiResult> ssidList = [];
  String ssid = '', password = '';
  String _ssid='';
  bool _enable = false;
  TextEditingController _ssidCtl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wifi'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: ssidList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return itemSSID(index);
          },
        ),
      ),
    );
  }

  Widget itemSSID(index) {
    if (index == 0) {
      return Column(
        children: [
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text('wifi status'),
                onPressed: () async {
                  bool l = await Wifi.isEnable;
                  setState(() {
                    _enable = l;
                  });
                },
              ),
              Text(_enable ? 'on' : 'off'),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text('enable wifi'),
                onPressed: ()async{
                  bool l = await Wifi.enableWifi(true);
                  setState(() {
                    _enable = l;
                  });
                },
              ),
              Text(_enable ? 'on' : 'off'),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text('disable wifi'),
                onPressed: ()async{
                  bool l = await Wifi.enableWifi(false);
                  setState(() {
                    _enable = l;
                  });
                },
              ),
              Text(_enable ? 'on' : 'off'),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text('wiwi list'),
                onPressed: (){
                  loadData();
                },
              ),
              Offstage(
                offstage: level == 0,
                child: Image.asset(
                    level == 0 ? 'images/wifi1.png' : 'images/wifi$level.png',
                    width: 28,
                    height: 21),
              ),
              Text(_moran),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text('ssid'),
                onPressed: _getWifiName,
              ),
              Offstage(
                offstage: level == 0,
                child: Image.asset(
                    level == 0 ? 'images/wifi1.png' : 'images/wifi$level.png',
                    width: 28,
                    height: 21),
              ),
              Text(_wifiName),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text('ip'),
                onPressed: _getIP,
              ),
              Text(_ip),
            ],
          ),
          TextField(
            controller: _ssidCtl,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.wifi),
              hintText: 'Your wifi ssid',
              labelText: 'ssid',
            ),
            keyboardType: TextInputType.text,

            onChanged: (value) {
              ssid = value;
            },
          ),
          TextField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.lock_outline),
              hintText: 'Your wifi password',
              labelText: 'password',
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              password = value;
            },
          ),
          ElevatedButton(
            child: Text('connection'),
            onPressed: connection,
          ),

        ],
      );
    } else {
      return Column(children: <Widget>[
        ListTile(
          leading: Image.asset('images/wifi${ssidList[index - 1].level}.png',
              width: 28, height: 21),
          title: Text(
            ssidList[index - 1].ssid,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
            ),
          ),
          dense: true,
          onTap: (){

            setState((){
              _ssid = ssidList[index - 1].ssid;
              ssid = _ssid;
              _ssidCtl.text = _ssid;
            });

          },
        ),
        Divider(),
      ]);
    }
  }

  void loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
        print('$ssidList');
      });
    });
  }

  Future<Null> _getWifiName() async {
    int l = await Wifi.level;
    String wifiName = await Wifi.ssid;
    setState(() {
      level = l;
      _wifiName = wifiName;
    });
  }

  Future<Null> _getMoran() async {
    int l = await Wifi.level;
    String wifiName = await Wifi.moran;
    setState(() {
      level = l;
      _moran = wifiName;
    });
  }

  Future<Null> _getIP() async {
    String ip = await Wifi.ip;
    setState(() {
      _ip = ip;
    });
  }

  Future<Null> connection() async {
    // var v = await Wifi.connection(ssid, password);
    // print(v);

    Wifi.connection(ssid, password).then((v) {
      print(v);
    });
  }
}

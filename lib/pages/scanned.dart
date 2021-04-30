import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Scanned extends StatefulWidget {
  Scanned({Key key}) : super(key: key);

  @override
  _ScannedState createState() => _ScannedState();
}

class _ScannedState extends State<Scanned> {
  Map data = {};
  Map qrdata = {};
  DateTime currentBackPressTime;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String saving = 'Saving..';

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press Back again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<dynamic> _makeAttendance() async {
    Map attendance = {};
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    attendance['academicid'] = localStorage.getString('studentId');
    attendance['qrdata'] = qrdata;
    attendance['scantime'] = data['scantime'].toString();
    print('returning attendance: ' + json.encode(attendance));
    return json.encode(attendance);
  }

  Future<void> _saveAttendance() async {
    print('init saveattendance');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var attendances = localStorage.getString('attendances');
    print('attendances: ' + attendances.toString());
    if (attendances == null) {
      var attendanceArray = [];
      attendanceArray.add(await _makeAttendance());
      localStorage.setString('attendances', json.encode(attendanceArray));
      print('saved attendanceArray: ' + localStorage.getString('attendances'));
      setState(() {
        saving = 'Saved';
      });
    } else {
      var attendanceArray = json.decode(localStorage.getString('attendances'));
      print('attendance not null. found: ' + attendanceArray.toString());
      var currentAttendance = await _makeAttendance();
      bool found = false;
      attendanceArray.forEach((attendance) {
        print('found att: ' + attendance);
        var decodedAtt = json.decode(attendance);
        print('decoded att: ' + decodedAtt.toString());
        print(currentAttendance);
        if (decodedAtt['qrdata']['lid'].toString() ==
            json.decode(currentAttendance)['qrdata']['lid'].toString()) {
          Fluttertoast.showToast(msg: 'Already scanned for this lecture');
          setState(() {
            saving = 'Already Saved';
          });
          found = true;
        }
      });
      if (!found) {
        attendanceArray.add(currentAttendance);
        localStorage.setString('attendances', json.encode(attendanceArray));
        print(
            'saved attendanceArray: ' + localStorage.getString('attendances'));
        setState(() {
          saving = 'Saved';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _saveAttendance();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    qrdata = json.decode(stringToBase64.decode(data['qrcode']));
    print(data);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Attendance Preview"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Attendance scanned for:',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              SizedBox(height: 20),
              ListTile(
                tileColor: Colors.blueAccent,
                leading: Icon(Icons.check, color: Colors.white, size: 35),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                // isThreeLine: true,
                // visualDensity: VisualDensity(horizontal: 2, vertical: 3),
                dense: false,
                title: Text(qrdata['sn'] + ' - ' + qrdata['ct'].toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Date: ' +
                        qrdata['date'] +
                        '\n' +
                        'Scan time: ' +
                        DateFormat('h:m:s a').format(data['scantime']),
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                trailing: Text(saving, style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/dashboard', (route) => false,
                        arguments: {'activePage': 'dashboard'});
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Go back home',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ))),
        )
      ],
    );
  }
}

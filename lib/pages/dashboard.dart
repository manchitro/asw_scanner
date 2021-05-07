import 'dart:convert';

import 'package:asw_scanner/components/customBottomNav.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:asw_scanner/network_utils/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map data = {};
  Network api = new Network();
  var attendances = [];

  _getAttendances() async {
    print('getting attendances');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.getString('attendances') != null) {
      var attendanceArray = json.decode(localStorage.getString('attendances'));
      print('attendance is: ' + attendanceArray.toString());
      setState(() {
        attendances = attendanceArray;
      });
    } else {
      print('attendance is null');
      //   setState(() {
      //     attendances = [];
      //   });
    }
  }

  _autoLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  void initState() {
    super.initState();

    _getAttendances();
  }

  @override
  Widget build(BuildContext context) {
    //context data
    data = ModalRoute.of(context).settings.arguments;
    print(data);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(children: <Widget>[
        (Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text('Unsubmitted Attendances',
                            style:
                                TextStyle(color: Colors.white, fontSize: 23)),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.white))),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: attendances.length == 0
                    ? Text(
                        'You have no Unsubmitted attendances\nGo to History to see past submissions',
                        style: TextStyle(color: Colors.white))
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: attendances.length,
                        itemBuilder: (context, index) {
                          print('building attendances list with: ' +
                              json
                                  .decode(attendances[index])['lectureid']
                                  .toString());
                          var attData = json.decode(attendances[index]);
                          return SavedAttendance(attData: attData);
                        },
                      ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text('Your Sections',
                            style:
                                TextStyle(color: Colors.white, fontSize: 23)),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.white))),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: FutureBuilder(
                  // future: get(Uri.https(
                  //     'jsonplaceholder.typicode.com', 'todos/1')),
                  future: api.getData('api/v1/student/sections'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // if (snapshot.hasError) {
                      //   return Text('error');
                      // }
                      if (snapshot.data == null) {
                        return Text('Could not connect to server',
                            style: TextStyle(color: Colors.white));
                      } else {
                        var data = json.decode(snapshot.data);
                        if (data['success'] == true) {
                          if (data['sections'] != null) {
                            // return Text(
                            //     'Sections: ' + data['sections'][0][0]['sectionname'].toString(),
                            //     style: TextStyle(color: Colors.white));
                            return Column(
                              children: [
                                Text(
                                    data['sections'].length > 0
                                        ? 'You are enrolled in these sections. If you don\'t see a section that you should be in, please contact your faculty'
                                        : 'You are not enrolled in any sections currently. If you think there is a mistake, please contact your faculty',
                                    style: TextStyle(color: Colors.white)),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: data['sections'].length,
                                    itemBuilder: (context, index) {
                                      var sectionname = data['sections'][index]
                                          [0]['sectionname'];
                                      var sectiontimes = data['sections'][index]
                                          [0]['sectiontimes'];
                                      String sectiontimestxt = "";
                                      if (sectiontimes.length == 1) {
                                        sectiontimestxt = '[' +
                                            sectiontimes[0]['classtype'] +
                                            '] ' +
                                            ' ' +
                                            sectiontimes[0]['starttime'] +
                                            ' - ' +
                                            sectiontimes[0]['endtime'] +
                                            ' at ' +
                                            sectiontimes[0]['room'];
                                      } else if (sectiontimes.length == 2) {
                                        sectiontimestxt = '[' +
                                            sectiontimes[0]['classtype'] +
                                            '] ' +
                                            ' ' +
                                            sectiontimes[0]['starttime'] +
                                            ' - ' +
                                            sectiontimes[0]['endtime'] +
                                            ' at ' +
                                            sectiontimes[0]['room'] +
                                            '\n' +
                                            '[' +
                                            sectiontimes[1]['classtype'] +
                                            '] ' +
                                            ' ' +
                                            sectiontimes[1]['starttime'] +
                                            ' - ' +
                                            sectiontimes[1]['endtime'] +
                                            ' at ' +
                                            sectiontimes[1]['room'];
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          tileColor: Colors.blueAccent,
                                          leading: Icon(Icons.group,
                                              color: Colors.white, size: 35),
                                          title: Text(sectionname,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          subtitle: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(sectiontimestxt,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            );
                          } else {
                            return Center(
                                child: Text('Something went wrong.',
                                    style: TextStyle(color: Colors.white)));
                          }
                        } else {
                          if (data['tokenExpired'] == true) {
                            Fluttertoast.showToast(
                                toastLength: Toast.LENGTH_LONG,
                                msg:
                                    'Your session has expired. Please login again');

                            _autoLogout();
                          }
                          return Text('Error occured: ' + data['error'],
                              style: TextStyle(color: Colors.red));
                        }
                      }
                    } else {
                      return Center(
                          child: SpinKitFadingCircle(color: Colors.white));
                    }
                  },
                ),
              ),
              SizedBox(height: 90)
            ],
          ),
        )),
        CustomBottomNav(
          activePage: data['activePage'],
        )
      ]),
      // bottomNavigationBar: CustomBottomNav(),
    );
  }
}

class SavedAttendance extends StatefulWidget {
  SavedAttendance({
    Key key,
    @required this.attData,
  }) : super(key: key);

  final attData;

  @override
  _SavedAttendanceState createState() => _SavedAttendanceState();
}

class _SavedAttendanceState extends State<SavedAttendance> {
  dynamic attData = {};
  bool uploading = false;
  bool uploaded = false;
  Network api = new Network();

  @override
  void initState() {
    attData = widget.attData;
    super.initState();
  }

  _uploadAtt() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('has connection');
      var response =
          await api.authData({"attData": attData}, 'api/v1/student/submit');
      print('reponse: $response');
      if (response == null) {
        Fluttertoast.showToast(
            msg: 'Could not connect to ASW Server',
            toastLength: Toast.LENGTH_LONG);
        setState(() {
          uploading = false;
        });
        return;
      }
      try {
        var data = jsonDecode(response);
        if (data['success']) {
          Fluttertoast.showToast(
              msg: 'Success: ' + data['attendance'].toString());
          setState(() {
            uploading = false;
            uploaded = true;
          });
          print('updating attendance data in storage');
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          if (localStorage.getString('attendances') != null) {
            var attendanceArray =
                json.decode(localStorage.getString('attendances'));
            print('attendance is: ' + attendanceArray.toString());
            int index = 0;
            for (int i = 0; i < attendanceArray.length; i++) {
              var storedAtt = json.decode(attendanceArray[i]);
              if (storedAtt['qrdata']['lid'].toString() ==
                  attData['qrdata']['lid'].toString()) {
                print('found match: ' + attData['qrdata']['lid'].toString());
                break;
              }
              index++;
            }
            attendanceArray.removeAt(index);
            localStorage.setString('attendances', json.encode(attendanceArray));
            print(
                'after removing attendance is: ' + attendanceArray.toString());
          } else {
            print('attendance is null');
          }
        } else {
          Fluttertoast.showToast(msg: 'Failed:' + data);
        }
      } on Exception catch (e) {
        Fluttertoast.showToast(
            msg: 'Something went wrong: $e', toastLength: Toast.LENGTH_LONG);
      }
      setState(() {
        uploading = false;
      });
    } else {
      print('none');
      setState(() {
        uploading = false;
      });
      Fluttertoast.showToast(
          msg: 'Please make sure you have Internet first',
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.blueAccent,
      leading: Icon(Icons.check, color: Colors.white, size: 35),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      // isThreeLine: true,
      // visualDensity: VisualDensity(horizontal: 2, vertical: 3),
      dense: false,
      title: Text(widget.attData['qrdata']['sn'].toString(),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      subtitle: Text(
          'Lecture Date: ' +
              widget.attData['qrdata']['date'] +
              '\n' +
              'Scan time: ' +
              DateFormat('hh:mm:ss a')
                  .format(DateTime.parse(widget.attData['scantime'])),
          style: TextStyle(color: Colors.white, fontSize: 15)),
      trailing: IconButton(
          icon: uploaded
              ? Icon(Icons.cloud_done)
              : !uploading
                  ? Icon(Icons.cloud_upload, color: Colors.white)
                  : FittedBox(
                      fit: BoxFit.fill,
                      child: SpinKitFadingCircle(color: Colors.white)),
          onPressed: () async {
            print("upload");
            if (uploaded) return;
            if (!uploading) {
              setState(() {
                uploading = true;
              });

              await _uploadAtt();
            } else {
              setState(() {
                uploading = false;
              });
            }
          }),
    );
  }
}

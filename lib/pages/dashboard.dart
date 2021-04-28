import 'dart:convert';

import 'package:asw_scanner/components/customBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:asw_scanner/network_utils/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map data = {};
  Network api = new Network();

  @override
  void initState() {
    super.initState();
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
                        child: Text('Attendances',
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
                  future: api.authData({}, 'api/v1/student/sections'),
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
                        if (data['success'] == "true") {
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
                                          subtitle: Text(
                                              '[' +
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
                                                  sectiontimes[1]['room'],
                                              style: TextStyle(
                                                  color: Colors.white)),
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
                          if (data['message'] != null) {
                            return Text(data['message'],
                                style: TextStyle(color: Colors.white));
                          } else {
                            return Text('error' + snapshot.data.toString(),
                                style: TextStyle(color: Colors.white));
                          }
                        }
                      }
                    } else {
                      return Center(
                          child: SpinKitFadingCircle(color: Colors.white));
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: FutureBuilder(
                  // future: get(Uri.https(
                  //     'jsonplaceholder.typicode.com', 'todos/1')),
                  future: api.authData({}, 'api/v1/student/sections'),
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
                        if (data['success'] == "true") {
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
                                          subtitle: Text(
                                              '[' +
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
                                                  sectiontimes[1]['room'],
                                              style: TextStyle(
                                                  color: Colors.white)),
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
                          if (data['message'] != null) {
                            return Text(data['message'],
                                style: TextStyle(color: Colors.white));
                          } else {
                            return Text('error' + snapshot.data.toString(),
                                style: TextStyle(color: Colors.white));
                          }
                        }
                      }
                    } else {
                      return Center(
                          child: SpinKitFadingCircle(color: Colors.white));
                    }
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
                  future: api.authData({}, 'api/v1/student/sections'),
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
                        if (data['success'] == "true") {
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
                                          subtitle: Text(
                                              '[' +
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
                                                  sectiontimes[1]['room'],
                                              style: TextStyle(
                                                  color: Colors.white)),
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
                          if (data['message'] != null) {
                            return Text(data['message'],
                                style: TextStyle(color: Colors.white));
                          } else {
                            return Text('error' + snapshot.data.toString(),
                                style: TextStyle(color: Colors.white));
                          }
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

import 'dart:convert';

import 'package:asw_scanner/components/customBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder(
                        // future: get(Uri.https(
                        //     'jsonplaceholder.typicode.com', 'todos/1')),
                        future: api.getData('api/v1/test'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text('error');
                            }
                            if (snapshot.data == null) {
                              return Text('Could not connect to server',
                                  style: TextStyle(color: Colors.white));
                            } else {
                              var data = json.decode(snapshot.data);
                              if (data['success'] == "true") {
                                return Text('data' + snapshot.data.toString(),
                                    style: TextStyle(color: Colors.white));
                              } else {
                                return Text('error' + snapshot.data.toString(),
                                    style: TextStyle(color: Colors.white));
                              }
                            }
                          } else {
                            return Center(
                                child:
                                    SpinKitFadingCircle(color: Colors.white));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
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

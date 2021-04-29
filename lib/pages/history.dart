import 'dart:convert';

import 'package:asw_scanner/components/customBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:asw_scanner/network_utils/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Map data = {};
  Network api = new Network();

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print(data);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('History'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text('Scan Histroy',
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
                  future: api.getData('api/v1/student/history'),
                  builder: (context, snapshot) {
                    print(snapshot.data);
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
                          return Text(data.toString(),
                              style: TextStyle(color: Colors.white));
                        } else {
                          if (data['error'] != null) {
                            return Text(data['error'],
                                style: TextStyle(color: Colors.red));
                          } else {
                            return Text(snapshot.data,
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

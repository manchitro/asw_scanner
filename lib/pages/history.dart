import 'package:asw_scanner/components/customBottomNav.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Map data = {};
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[
                    Text('History', style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ],
          ),
        )),
        CustomBottomNav(activePage: data['activePage'],)
      ]),
      // bottomNavigationBar: CustomBottomNav(),
    );
  }
}
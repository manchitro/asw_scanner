import 'package:asw_scanner/components/customBottomNav.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map data = {};
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print(data);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Profile'),
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
                    Text('Profile', style: TextStyle(color: Colors.white))
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
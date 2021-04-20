import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isAuth = false;
  String fullName = "";
  String studentId = "";

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    studentId = localStorage.getString('studentId');
    fullName = localStorage.getString('fullName');
    if (studentId != null && fullName != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();

    Future.delayed(Duration(milliseconds: 2000), () {
      if (isAuth) {
        Navigator.pushReplacementNamed(context, '/dashboard', arguments:{
          'studentId': studentId,
          'fullName': fullName,
          'activePage': 'dashboard'
        });
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: SizedBox()),
          Expanded(
            child: Column(children: <Widget>[
              Image.asset('assets/favicon.png'),
              Text('Attendance Scanning Wizard',
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, fontFamily: 'Nunito')),
              SizedBox(height: 20),
              SpinKitFadingCircle(color: Colors.white, size: 40),
            ]),
          ),
          SizedBox(height: 60),
          Text('ASW Scanner v0.1.0 alpha',
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Nunito'))
        ],
      )),
    );
  }
}

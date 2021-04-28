import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:asw_scanner/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var uid;
  var password;
  String fullName = "";
  String studentId = "";

  String message = "";

  Network api = new Network();

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var response = await api.authData({
      'academicid': uid,
      'password': password,
    }, 'api/v1/student/login');
    print(response);
    if (response == null) {
      setState(() {
        message = "Could not connect to ASW Server";
      });
    } else {
      var data = json.decode(response);
      if (data['login'] == true) {
        setState(() {
          message = 'Login successful';
        });
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', data['token']);
        localStorage.setString('fullName', data['name']);
        localStorage.setString('studentId', uid);
        setState(() {
          fullName = localStorage.getString('fullName');
          studentId = localStorage.getString('studentId');
        });
        Navigator.pushReplacementNamed(context, '/dashboard', arguments:{
          'studentId': studentId,
          'fullName': fullName,
          'activePage': 'dashboard'
        });
      } else {
        setState(() {
          message = data['error'];
        });
      }
    }

    // Navigator.pushReplacementNamed(context, '/loginweb',
    //     arguments: {'uid': uid});

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('ASW Scanner'),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          child: Stack(children: <Widget>[
            Positioned(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: <Widget>[
                        Text('Login',
                            style: TextStyle(
                                fontSize: 35, color: Colors.blueAccent[200])),
                        SizedBox(width: 9),
                        Text('enter your VUES ID to continue',
                            style: TextStyle(color: Colors.grey[200]))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.blueAccent,
                      height: 30,
                    ),
                  ),
                  Card(
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'VUES ID',
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(Icons.person,
                                        color: Colors.blueAccent[200])),
                                validator: (uidValue) {
                                  if (uidValue.isEmpty) {
                                    return 'Please enter VUES ID';
                                  }
                                  uid = uidValue;
                                  return null;
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(color: Colors.grey[500]),
                              ),
                              TextFormField(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.blueAccent[200],
                                  ),
                                ),
                                validator: (passwordValue) {
                                  if (passwordValue.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  password = passwordValue;
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextButton(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          child: _isLoading
                                              ? SpinKitFadingCircle(
                                                  size: 22, color: Colors.white)
                                              : Text('Continue',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17))),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _login();
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blueAccent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ])),
                  ),
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(message, style: TextStyle(color: Colors.red)))
                ],
              ),
            )),
          ]),
        ));
  }
}

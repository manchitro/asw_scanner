import 'dart:async';
import 'dart:convert';

import 'package:asw_scanner/network_utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var uid;
  var password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // print(uid);
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // localStorage.setString('uid', uid);
    Navigator.pushReplacementNamed(context, '/loginweb',
        arguments: {'uid': uid});

    setState(() {
      _isLoading = false;
    });
  }

  _launchURL() async {
    const url = 'https://portal.aiub.edu/ForgotPassword';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                        Text('enter you VUES ID to continue',
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
                ],
              ),
            )),
          ]),
        ));
  }
}

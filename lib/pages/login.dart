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
    var data = {'uid': uid, 'password': password};

    var res = await Network().authData(data, '/api/login');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      _showMsg(body['message']);
    }

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
                        SizedBox(width: 10),
                        Text('with your VUES ID and password',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  OutlinedButton(
                                    child: Text('Forgot your password?',
                                        style: TextStyle(
                                            color: Colors.blueAccent[200],
                                            // fontStyle: FontStyle.italic,
                                            fontSize: 15)),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: Text('Forgot Password?',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          content: Text(
                                              'To reset your VUES password, you need to visit AIUB Portal',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          actions: [
                                            TextButton(
                                              child: Text('Visit Portal'),
                                              onPressed: () {
                                                _launchURL();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Okay'),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop("Discard");
                                              },
                                            )
                                          ],
                                          backgroundColor: Colors.grey[900],
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextButton(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          child: _isLoading
                                              ? SpinKitFadingCircle(
                                                  size: 22, color: Colors.white)
                                              : Text('Login',
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
            ))
          ]),
        ));
  }
}

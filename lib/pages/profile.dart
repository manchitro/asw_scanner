import 'dart:convert';

import 'package:asw_scanner/components/customBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:asw_scanner/network_utils/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = false;
  Map data = {};
  Network api = new Network();
  final _formKey = GlobalKey<FormState>();
  var firstname;
  var lastname;
  var email;

  @override
  void initState() {
    super.initState();
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text('Your Profile',
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
                  horizontal: 0,
                ),
                child: FutureBuilder(
                  // future: get(Uri.https(
                  //     'jsonplaceholder.typicode.com', 'todos/1')),
                  future: api.authData({}, 'api/v1/student/profile'),
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
                          return Container(
                            child: Card(
                              color: Colors.black,
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextFormField(
                                          initialValue: data['student'][0]
                                              ['firstname'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          cursorColor: Color(0xFF9b9b9b),
                                          keyboardType: TextInputType.text,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText: 'First Name',
                                            labelStyle: TextStyle(
                                                color:
                                                    Colors.blueAccent.shade200,
                                                fontSize: 17),
                                            fillColor: Colors.white,
                                          ),
                                          validator: (firstNameValue) {
                                            if (firstNameValue.isEmpty) {
                                              return 'Please enter VUES ID';
                                            }
                                            firstname = firstNameValue;
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          initialValue: data['student'][0]
                                              ['lastname'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          cursorColor: Color(0xFF9b9b9b),
                                          keyboardType: TextInputType.text,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText: 'Last Name',
                                            labelStyle: TextStyle(
                                                color:
                                                    Colors.blueAccent.shade200,
                                                fontSize: 17),
                                          ),
                                          validator: (lastNameValue) {
                                            if (lastNameValue.isEmpty) {
                                              return 'Please enter your last name';
                                            }
                                            lastname = lastNameValue;
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          initialValue: data['student'][0]
                                              ['academicid'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          cursorColor: Color(0xFF9b9b9b),
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText: 'Academic ID',
                                            labelStyle: TextStyle(
                                                color:
                                                    Colors.blueAccent.shade200,
                                                fontSize: 17),
                                          ),
                                          readOnly: true,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 20),
                                              child: TextButton(
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    child: _isLoading
                                                        ? SpinKitFadingCircle(
                                                            size: 22,
                                                            color: Colors.white)
                                                        : Text('Save',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17))),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    print('form submitted');
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Colors.blueAccent),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ])),
                            ),
                          );
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

                    return Center(
                        child: Text('Something went wrong.',
                            style: TextStyle(color: Colors.white)));
                  },
                ),
              )
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

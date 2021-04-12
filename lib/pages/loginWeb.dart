import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LoginWeb extends StatefulWidget {
  @override
  _LoginWebState createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
  Map data = {};

  String message = "";

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

    loginWebview(uid, password);

    setState(() {
      _isLoading = false;
    });
  }

  void loginWebview(String username, String password) {
    _controller.evaluateJavascript(
        source: 'document.getElementById("username").value = "' +
            username +
            '";' +
            'document.getElementById("password").value = "' +
            password +
            '";' +
            'document.getElementById("loginForm").submit();');
  }

  _launchURL() async {
    const url = 'https://portal.aiub.edu/ForgotPassword';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  readHTML() async {
    String html = await _controller.evaluateJavascript(
        source: "window.document.getElementsByTagName('html')[0].outerHTML;");
    if (html.contains('Welcome') &&
        html.contains('Academic') &&
        html.contains('Grade Reports')) {
      String smallTag = (await _controller.evaluateJavascript(
          source:
              'document.getElementsByClassName(\'navbar-link\')[0].innerHTML'));
      String fullName = smallTag.substring(7, smallTag.length - 8);
      print(fullName);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('fullName', fullName);
      localStorage.setString('studentId', data['uid']);
      Navigator.pushReplacementNamed(context, '/dashboard',
          arguments: {'fullName': fullName, 'studentId': uid});
    }
    // print(html);
  }

  InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print(data);

    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        title: Text('ASW Scanner'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(message,
                    style: TextStyle(color: Colors.black, fontSize: 17)),
              )),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Back'),
              ),
            ),
            Expanded(
              flex: 8,
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: Uri.parse('https://portal.aiub.edu')),
                // javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    message += "Loading...\n";
                  });
                },
                onLoadError: (controller, url, code, message) {
                  setState(() {
                    message +=
                        "Could not load AIUB portal login page. An error occurred";
                  });
                },
                onLoadHttpError: (controller, url, code, message) {
                  setState(() {
                    message +=
                        "Could not load AIUB portal login page. Please make sure you have internet";
                  });
                },
                onLoadStop: (controller, url) async {
                  // setState(() {
                  //   message += "Loading complete\n";
                  // });
                  _controller.evaluateJavascript(
                      source: 'document.getElementById("username").value = "' +
                          data['uid'] +
                          '"');
                  setState(() {
                    message =
                        "We have loaded a webpage for you to login through and autofilled your user name: " +
                            data['uid'] +
                            "\nPlease enter your password and complete login. After a successful login has been detected, you will be redirected to your ASW dashboard.";
                  });

                  // readHTML();
                  String html = await _controller.evaluateJavascript(
                      source:
                          "window.document.getElementsByTagName('html')[0].outerHTML;");
                  if (html == null) {
                    setState(() {
                      message =
                          "Could not load AIUB portal login page. Make sure you have internet";
                    });
                  } else {
                    readHTML();
                  }
                },
                // gestureNavigationEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

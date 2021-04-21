import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LoginWeb extends StatefulWidget {
  @override
  _LoginWebState createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
  Map data = {};

  String message = "";

  var uid;
  var password;

  @override
  void initState() {
    super.initState();
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

  gotoProfile() async {
    await _controller.evaluateJavascript(
        source:
            'window.location.href = "https://portal.aiub.edu/Student/Home/Profile"');
  }

  readHTML() async {
    String html = await _controller.evaluateJavascript(
        source: "window.document.getElementsByTagName('html')[0].outerHTML;");
    // print(await _controller.getUrl().toString());
    if (html.contains('CGPA')) {
      String smallTag = (await _controller.evaluateJavascript(
          source:
              'document.getElementsByClassName(\'navbar-link\')[0].innerHTML'));
      String fullName = smallTag.substring(7, smallTag.length - 8);
      String studentId = (await _controller.evaluateJavascript(
          source:
              'document.getElementsByTagName(\'table\')[0].rows[0].cells[1].innerHTML.trim();'));
      print(fullName + " " + studentId);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('fullName', fullName);
      localStorage.setString('studentId', data['uid']);
      var now = DateTime.now().toString();
      localStorage.setString('lastLogin', now);
      _controller.clearCache();
      print("put studentId: " + localStorage.getString('studentId'));
      Navigator.pushReplacementNamed(context, '/dashboard', arguments: {
        'fullName': fullName,
        'studentId': studentId,
        'lastLogin': now,
        'activePage': 'dashboard'
      });
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
                    style: TextStyle(color: Colors.black, fontSize: 15)),
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
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        'https://portal.aiub.edu/Student/Home/Profile')),
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
                    message = "We have loaded a webpage for you to login through and autofilled your user name: " +
                        data['uid'] +
                        "\nPlease enter your password and complete login. After a successful login has been detected, you will be redirected to your ASW dashboard." +
                        '\nIf you have entered a wrong username, use the Back button.';
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
                    print('current url: ' + url.toString());
                    if (url.toString() == 'https://portal.aiub.edu/Student') {
                      print('going to profile');
                      gotoProfile();
                      print('and reading html');
                      readHTML();
                    } else if (url.toString().contains('Profile')) {
                      readHTML();
                    }
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

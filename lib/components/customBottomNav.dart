import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNav extends StatefulWidget {
  final String activePage;

  CustomBottomNav({Key key, @required this.activePage}) : super(key: key);

  @override
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout?'),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                    'Are you sure you want to log out? You will need internet connection to log back in!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 17)),
              onPressed: () {
                print('Cancel');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes',
                  style: TextStyle(color: Colors.redAccent, fontSize: 17)),
              onPressed: () async {
                print('logout');
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: size.width,
        height: 80,
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: Size(size.width, 80),
              painter: BNBCustomPainer(),
            ),
            Center(
              heightFactor: 0.6,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/scanner');
                },
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 30,
                ),
                // elevation: 0.1
              ),
            ),
            Container(
              width: size.width,
              height: 80,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        print('home');
                        // Navigator.pushNamedAndRemoveUntil(controller, '/')
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/dashboard',
                          (_) => false,
                          arguments: {'activePage': 'dashboard'},
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          Text('Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Container(
                              height: widget.activePage == 'dashboard' ? 2 : 0,
                              // width: size.width * .1,
                              width: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('History');
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/history', (_) => false,
                            arguments: {'activePage': 'history'});
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                          Text('History',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Container(
                              height: widget.activePage == 'history' ? 2 : 0,
                              // width: size.width * .1,
                              width: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * .2,
                    ),
                    InkWell(
                      onTap: () {
                        print('Profile');
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/profile',
                          (_) => false,
                          arguments: {'activePage': 'profile'},
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          Text('Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Container(
                              height: widget.activePage == 'profile' ? 2 : 0,
                              // width: size.width * .1,
                              width: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('1');
                        _showLogoutDialog();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.logout,
                            color: Colors.pinkAccent[400],
                          ),
                          Text('Logout',
                              style: TextStyle(
                                color: Colors.pinkAccent[400],
                                fontWeight: FontWeight.bold,
                              ))
                        ],
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;
    Path path = new Path()..moveTo(0, 0);
    // path.quadraticBezierTo(size.width * .2, 0, size.width * .35, 0);
    path.lineTo(size.width * .35, 0);
    path.quadraticBezierTo(size.width * .4, 0, size.width * .4, 20);
    path.arcToPoint(Offset(size.width * .6, 20),
        radius: Radius.circular(10), clockwise: false);
    path.quadraticBezierTo(size.width * .6, 0, size.width * .65, 0);
    // path.quadraticBezierTo(size.width * .8, 0, size.width, 20);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path.shift(Offset(0, -8)), Colors.black, 50, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
}

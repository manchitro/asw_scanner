import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'aswlive.ferdoused.com';
  // final String _url = '192.168.43.71:8000';
  // final String _url = '192.168.31.144:8000';
  // final String _url = '192.168.31.114:8000';
  Dio dio = new Dio();
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;
  var studentId;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('token')) {
      token = localStorage.getString('token');
    } else {
      token = "";
    }
  }

  Future<dynamic> authData(data, apiUrl) async {
    // Uri uri = new Uri.https(_url, apiUrl);
    Uri uri = new Uri.https(_url, apiUrl);
    print('url: $_url');
    print('URI: $uri');
    print('Data: $data');
    await _getToken();
    try {
      var response = await http
          .post(uri, body: jsonEncode(data), headers: _setHeaders())
          .timeout(Duration(seconds: 10))
          // .then(print);
          .catchError(print);
      return response.body;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<dynamic> getData(apiUrl) async {
    print(apiUrl);
    // Uri uri = new Uri.https(_url, apiUrl);
    Uri uri = new Uri.https(_url, apiUrl);
    await _getToken();
    try {
      var response = await http
          .get(uri, headers: _setHeaders())
          .timeout(Duration(seconds: 10))
          // .then(print);
          .catchError(print);
      return response.body;
    } catch (e) {
      print(e);
    }
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}

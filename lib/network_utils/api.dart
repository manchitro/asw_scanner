import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = '192.168.31.114:8000';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;
  var studentId;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
  }

  _getStudentId() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    studentId = localStorage.getString('studentId');
    print(studentId);
  }

  authData(data, apiUrl) async {
    Uri uri = new Uri.http(_url, apiUrl);
    await _getStudentId();
    data['academicid'] = studentId;
    print('URI: $uri');
    print('Data: $data');
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
    Uri uri = new Uri.http(_url, apiUrl);
    // await _getToken();
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

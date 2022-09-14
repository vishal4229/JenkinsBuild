// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

String server_url = "";
Future<int> makePostRequest1(String username, String pass) async {
  final uri = Uri.parse('${server_url}creds/login/');
  final headers = {
    'Content-Type': 'application/json',
    "Access-Control-Allow-Origin": "*"
  };
  Map<String, dynamic> body = {'username': username, 'password': pass};
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  int statusCode = response.statusCode;
  String responseBody = response.body;
  final Map responsePrase = json.decode(responseBody);
  final prefs = await SharedPreferences.getInstance();
  // set value
  String save_username =
      (responsePrase['username'] == Null || responsePrase['username'] == null)
          ? ''
          : responsePrase['username'];
  String save_build_token = (responsePrase['build_token'] == Null ||
          responsePrase['build_token'] == null)
      ? ''
      : responsePrase['build_token'];
  if (statusCode == 200) {
    await prefs.setString('username', responsePrase['username']);
    await prefs.setString('jenkins_username', save_username);
    await prefs.setString('build_token', save_build_token);
  }
  return statusCode;
}

Future<int> makePostRequest(String username, String pass,
    String jenkinsUsername, String buildToken) async {
  final uri = Uri.parse('${server_url}creds/create_user/');
  final headers = {
    'Content-Type': 'application/json',
    "Access-Control-Allow-Origin": "*"
  };
  Map<String, dynamic> body = {
    'username': username,
    'password': pass,
    'jenkins_username': jenkinsUsername,
    'build_token': buildToken
  };
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  int statusCode = response.statusCode;
  String responseBody = response.body;
  return statusCode;
}

Future<dynamic> makePostRequest3(dataList) async {
  final uri = Uri.parse('${server_url}creds/start_build/');
  final headers = {
    'Content-Type': 'application/json',
    "Access-Control-Allow-Origin": "*"
  };
  Map<dynamic, dynamic> b = {};
  int statusCode = 0;
  final prefs = await SharedPreferences.getInstance();
  final jenkins_username = prefs.getString('jenkins_username') ?? '';
  final build_token = prefs.getString('build_token') ?? '';
  // if (jenkins_username != '' && build_token != '') {
  Map<String, dynamic> body = {
    'username': jenkins_username,
    'build_token': build_token,
    'build_data': dataList.toString(),
  };
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  statusCode = response.statusCode;
  String responseBody = response.body;
  // }
  if (statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    b = jsonDecode(response.body);
    print(b);
  }
  b['statusCode'] = response.statusCode;
  return b;
}

Future<dynamic> makegetRequest() async {
  final uri = Uri.parse('${server_url}creds/build_info/');
  Map<dynamic, dynamic> b = {};
  final headers = {
    'Content-Type': 'application/json',
    "Access-Control-Allow-Origin": "*"
  };
  final prefs = await SharedPreferences.getInstance();
  final jenkins_username = prefs.getString('jenkins_username') ?? '';
  final build_token = prefs.getString('build_token') ?? '';
  // if (jenkins_username != '' && build_token != '') {
  Map<String, dynamic> body = {
    'username': jenkins_username,
  };
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');
  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    b = jsonDecode(response.body);
    print(b);
  }
  b['statusCode'] = response.statusCode;
  return b;
}

Future<dynamic> getserverUrl() async {
  final uri = Uri.parse('https://api.npoint.io/c330164656dc623928a5');
  Map<dynamic, dynamic> b = {};
  List<String> l1 = [];
  Response response = await get(uri);
  // l1 = response.body;

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    b = jsonDecode(response.body.replaceAll('[', "").replaceAll(']', ""));
    // print(b['server_url']);
  }
  server_url = b['server_url'];
  final firebaseMessaging = FirebaseMessaging.instance;
    final token =
        firebaseMessaging.getToken().then((value) => saveToken(value));
}

Future<dynamic> saveToken(token) async {
  print('${server_url}creds/create_token/');
  final uri = Uri.parse('${server_url}creds/create_token/');
  Map<dynamic, dynamic> b = {};
  final headers = {
    'Content-Type': 'application/json',
    "Access-Control-Allow-Origin": "*"
  };
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username') ?? '';
  // if (jenkins_username != '' && build_token != '') {
  Map<String, dynamic> body = {'username': username, 'token': token};
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');
  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );
}

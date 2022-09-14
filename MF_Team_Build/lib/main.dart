import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:mf_team_build/updateChecker.dart';

import 'SuccessPage.dart';
import 'buildInfo.dart';
import 'login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'MFTeam';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title), centerTitle: true),
        body: const updateChecker(),
      ),
    );
  }
}


// Future<int> makePostRequest() async {
//   final uri = Uri.parse('http://6638-183-87-32-7.ngrok.io/creds/login/');
//   final headers = {
//     'Content-Type': 'application/json',
//     "Access-Control-Allow-Origin": "*"
//   };
//   Map<String, dynamic> body = {'username': 'vishal1', 'password': '1234'};
//   String jsonBody = json.encode(body);
//   final encoding = Encoding.getByName('utf-8');

//   Response response = await get(
//     uri,
//     headers: headers,
//     // body: jsonBody,
//     // encoding: encoding,
//   );

//   int statusCode = response.statusCode;
//   String responseBody = response.body;
//   return statusCode;
// }

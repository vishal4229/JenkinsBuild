import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mf_team_build/updateChecker.dart';

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
        body: const UpdateChecker(),
      ),
    );
  }
}

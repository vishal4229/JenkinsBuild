// ignore_for_file: camel_case_types, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mf_team_build/connectserver.dart';
import 'package:mf_team_build/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  var _username = 'kl';
  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    getserverUrl();
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Hello User';
    setState(() {
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            const Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
            CircleAvatar(
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset('web/icons/usericon.png'),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(135, 20, 135, 0),
              child: Text(
                _username,
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 8, 1, 0),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                    height: 300,
                    padding: const EdgeInsets.fromLTRB(140, 20, 130, 0),
                    child: RawMaterialButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('username');
                        await prefs.remove('jenkins_username');
                        await prefs.remove('build_token');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => loginStatels(),
                          ),
                          (route) => false,
                        );
                      },
                      elevation: 10.0,
                      fillColor: Colors.green,
                      child: Icon(
                        Icons.logout,
                        size: 25.0,
                      ),
                      padding: EdgeInsets.all(2.0),
                      shape: CircleBorder(),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

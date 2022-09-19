// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mf_team_build/commonwidget.dart';
import 'package:mf_team_build/login_page.dart';

import 'connectserver.dart';

class SecondPageSt extends StatelessWidget {
  const SecondPageSt({Key? key}) : super(key: key);

  static const String _title = 'MFTeam';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title), centerTitle: true),
        body: const SecondPage(),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController jenkinsController = TextEditingController();
  TextEditingController buildTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                formContainer(nameController, 'User Name'),
                formPassContainer(passwordController, 'Password'),
                formContainer(jenkinsController, 'Jenkins username'),
                formContainer(buildTokenController, 'Build Token'),
                Container(
                  padding: const EdgeInsetsDirectional.all(10),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Signup'),
                      onPressed: () async {
                        int statusCode;
                        statusCode = await signupRequest(
                            nameController.text,
                            passwordController.text,
                            jenkinsController.text,
                            buildTokenController.text);
                        if (statusCode == 200) {
                          snackbar(context, 'User Created Sucess, Please Login',
                              Colors.green);
                        } else {
                          snackbar(
                              context, 'Unable to Create User', Colors.red);
                        }
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already have an Account'),
                    TextButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginStateLs()),
                        );
                      },
                    )
                  ],
                ),
              ],
            )));
  }
}

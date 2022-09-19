// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mf_team_build/commonwidget.dart';
import 'package:mf_team_build/signup.dart';
import 'SuccessPage.dart';
import 'connectserver.dart';

class LoginStateLs extends StatelessWidget {
  const LoginStateLs({Key? key}) : super(key: key);
  static const String _title = 'MFTeam';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title), centerTitle: true),
        body: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            const Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 0)),
            CircleAvatar(
              radius: 35.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset('web/icons/jenkins.png'),
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            formContainer(nameController, 'User Name'),
            formPassContainer(passwordController, 'Password'),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    int statusCode;
                    statusCode = await loginRequest(
                        nameController.text, passwordController.text);
                    if (statusCode == 200) {
                      snackbar(context, 'Login Success', Colors.green);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SucessPage()),
                      );
                    } else {
                      snackbar(context, 'Login Failed', Colors.red);
                    }
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondPageSt()),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

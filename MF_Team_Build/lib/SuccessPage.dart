// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mf_team_build/commonwidget.dart';
import 'package:mf_team_build/profilePage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mf_team_build/trackingPage.dart';

import 'connectserver.dart';

class SucessPage extends StatefulWidget {
  const SucessPage({Key? key}) : super(key: key);

  @override
  State<SucessPage> createState() => _SucessPageState();
}

class _SucessPageState extends State<SucessPage> {
  bool valueall = false;
  bool valuefirst = false;
  bool valuesecond = false;
  bool valuethird = false;
  bool valuefourth = false;
  bool serverqa = false;
  bool servern2p = false;
  Map<dynamic, dynamic> b = {};

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SucessPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrackingPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const profilePage()),
        );
        break;
    }
  }

  String createbuildData(b) {
    List<dynamic> startedBuild = [];
    List<dynamic> alreadygoingBuild = [];
    String d = '[Started Build] - ';
    String v = '[Already Ongoing Build] - ';
    startedBuild = b['started_build'];
    alreadygoingBuild = b['already_going'];
    for (var i = 0; i < startedBuild.length; i++) {
      if (startedBuild[i] == 1) {
        d += 'MF-application ';
      }
      if (startedBuild[i] == 2) {
        d += 'MF-cronicle ';
      }
      if (startedBuild[i] == 3) {
        d += 'MF-admin ';
      }
      if (startedBuild[i] == 4) {
        d += 'MF-consumer ';
      }
    }
    for (var i = 0; i < alreadygoingBuild.length; i++) {
      if (alreadygoingBuild[i] == 1) {
        v += 'MF-application ';
      }
      if (alreadygoingBuild[i] == 2) {
        v += 'MF-cronicle ';
      }
      if (alreadygoingBuild[i] == 3) {
        v += 'MF-admin ';
      }
      if (alreadygoingBuild[i] == 4) {
        v += 'MF-consumer ';
      }
    }
    return '$d\n\n$v';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Build Application',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            centerTitle: true),
        body: Container(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                child: Column(children: const [
                  Text(
                    'Checkbox For Required Build',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
              Card(
                  elevation: 20,
                  shadowColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  color: Colors.deepPurpleAccent,
                  child: Column(children: [
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    const Text(
                      'Select Server',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.fromLTRB(90, 10, 10, 40)),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('QA',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          value: serverqa,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                serverqa = value;
                                servern2p = false;
                              }
                            });
                          },
                        ),
                        const Text('N2P',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          value: servern2p,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                servern2p = value;
                                serverqa = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ])),
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
              Card(
                elevation: 20,
                shadowColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                color: Colors.deepPurpleAccent,
                child: Column(
                  children: [
                    CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      secondary: const Icon(
                        Icons.task_outlined,
                        color: Color.fromARGB(255, 4, 255, 4),
                      ),
                      title: const Text('All-Build',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      subtitle: const Text(
                        'All service Build',
                        style: TextStyle(
                            color: Color.fromARGB(255, 191, 189, 189)),
                      ),
                      value: valueall,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            valueall = value;
                            valuefirst = false;
                            valuesecond = false;
                            valuethird = false;
                            valuefourth = false;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      secondary: const Icon(
                        Icons.task_outlined,
                        color: Color.fromARGB(255, 4, 255, 4),
                      ),
                      title: const Text('MF-Application',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      subtitle: const Text('Application Build',
                          style: TextStyle(
                              color: Color.fromARGB(255, 191, 189, 189))),
                      value: valuefirst,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            valuefirst = value;
                            valueall = false;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      secondary: const Icon(
                        Icons.task_outlined,
                        color: Color.fromARGB(255, 4, 255, 4),
                      ),
                      title: const Text('MF-Cronicle',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      subtitle: const Text('Cronicle Build',
                          style: TextStyle(
                              color: Color.fromARGB(255, 191, 189, 189))),
                      value: valuesecond,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            valuesecond = value;
                            valueall = false;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      secondary: const Icon(
                        Icons.task_outlined,
                        color: Color.fromARGB(255, 4, 255, 4),
                      ),
                      title: const Text('MF-Admin',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      subtitle: const Text('Admin Build',
                          style: TextStyle(
                              color: Color.fromARGB(255, 191, 189, 189))),
                      value: valuethird,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            valuethird = value;
                            valueall = false;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      checkColor: Colors.white,
                      activeColor: Colors.green,
                      secondary: const Icon(
                        Icons.task_outlined,
                        color: Color.fromARGB(255, 4, 255, 4),
                      ),
                      title: const Text('MF-Consumer',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      subtitle: const Text('Consumer Build',
                          style: TextStyle(
                              color: Color.fromARGB(255, 191, 189, 189))),
                      value: valuefourth,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            valuefourth = value;
                            valueall = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                  height: 60,
                  width: 200,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Start Build',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      createloadingwidget(b, context);
                      b = await startBuildRequest([
                        valueall,
                        valuefirst,
                        valuesecond,
                        valuethird,
                        valuefourth,
                        serverqa,
                        servern2p
                      ]);
                      if (b['statusCode'] == 200) {
                        Navigator.of(context).pop();
                        dailogbox(context, 'Current Build Status',
                            createbuildData(b), Colors.green);
                      } else {
                        Navigator.of(context).pop();
                        dailogbox(context, 'Error',
                            'Error getting data from server', Colors.red);
                      }
                    },
                  )),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.track_changes,
                color: Colors.red,
              ),
              label: 'Track',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.red,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

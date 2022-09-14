// ignore_for_file: unnecessary_new, list_remove_unrelated_type

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mf_team_build/connectserver.dart';

class trackingPage extends StatefulWidget {
  const trackingPage({Key? key}) : super(key: key);

  @override
  State<trackingPage> createState() => _trackingPageState();
}

class buildInfos {
  dynamic server = '';
  dynamic user = '';
  dynamic buildtime = '';
  dynamic result = '';
  buildInfos(
      {required this.server,
      required this.user,
      required this.buildtime,
      required this.result});
  buildInfos.fromList(List<String> listOfserver) {
    this.server = listOfserver[0];
    this.user = listOfserver[1];
    this.buildtime = listOfserver[2];
    this.result = listOfserver[3];
  }
}

class _trackingPageState extends State<trackingPage> {
  List<Widget> _cardList = [];
  List<Widget> _cardList2 = [];
  Map<dynamic, dynamic> b = {};
  // double _progressValue = 0;
  // double _progressValue1 = 0;
  double _progressValueAP1 = 0.0;
  double _progressValueAP2 = 0;
  double _progressValueCR1 = 0;
  double _progressValueCR2 = 0;
  double _progressValueAD1 = 0;
  double _progressValueAD2 = 0;
  double _progressValueCN1 = 0;
  double _progressValueCn2 = 0;

  List<dynamic> mfapplication = [];
  List<dynamic> mfadmin = [];
  List<dynamic> mfcronicle = [];
  List<dynamic> mfconsumer = [];
  buildInfos ap1 = new buildInfos.fromList(['', '', '', '']);
  buildInfos ap2 = new buildInfos.fromList(['', '', '', '']);
  buildInfos cr1 = new buildInfos.fromList(['', '', '', '']);
  buildInfos cr2 = new buildInfos.fromList(['', '', '', '']);
  buildInfos cn1 = new buildInfos.fromList(['', '', '', '']);
  buildInfos cn2 = new buildInfos.fromList(['', '', '', '']);
  buildInfos ad1 = new buildInfos.fromList(['', '', '', '']);
  buildInfos ad2 = new buildInfos.fromList(['', '', '', '']);
  bool visible = true;
  int buildestimate = 0;
  bool alreadyExecuted = false;
  bool alreadyExecuted1 = false;
  int cnt = 0;
  Timer t2 = Timer(Duration(milliseconds: 500), () {
    // SOMETHING
  });
  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    // _cardList.add(_card1('QA', 'MF-Application', 'vishal', '1234'));
    // _cardList.add(_card1('DEV', 'MF-Application', 'vishal1', '1234'));
    super.initState();
    Future.delayed(Duration.zero, () {
      buildInfo();
    });
  }

  void callBuild(buildestimate, progress, jobName, object1, cnt) async {
    var oneSec = Duration(seconds: buildestimate.round());
    new Timer.periodic(oneSec, (Timer t) {
      if (!mounted) return;
      setState(() {
        print(progress);
        print(object1.result);
        if (progress.toStringAsFixed(2) == '0.99' && object1.result == 'None') {
          setState(() {
            progress += 0;
          });
        } else if (object1.result == 'SUCCESS' || object1.result == 'FAILURE') {
          setState(() {
            _cardList.removeAt(cnt);
            _cardList2.add(_card2(object1.server, jobName, object1.user,
                object1.buildtime, object1.result));
          });
          t.cancel();
          return;
        } else {
          progress += 0.01;
          _cardList[cnt] = _card1(object1.server, jobName, object1.user,
              object1.buildtime, progress);
        }
      });
    });
  }

  void callBuild1(buildestimate, progress, jobName, object1, cnt) async {
    var oneSec = Duration(seconds: buildestimate.round());
    new Timer.periodic(oneSec, (Timer t) {
      if (!mounted) return;
      setState(() {
        if (progress.toStringAsFixed(1) == '0.99' && object1.result == 'None') {
          setState(() {
            progress += 0;
          });
        }
        if (object1.result == 'SUCCESS' || object1.result == 'FAILURE') {
          setState(() {
            _cardList.removeAt(cnt);
            _cardList2.add(_card2(object1.server, jobName, object1.user,
                object1.buildtime, object1.result));
          });
          t.cancel();
          return;
        } else {
          progress += 0.01;
          _cardList[cnt] = _card1(object1.server, jobName, object1.user,
              object1.buildtime, progress);
        }
      });
    });
  }

  void build1() async {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    if (!alreadyExecuted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                return b['statusCode'] == 200 || b['statusCode'] == 400;
              },
              child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Color.fromARGB(255, 1, 200, 255), size: 70)));
        },
      );
    }
    b = await makegetRequest();
    if (b['statusCode'] == 200) {
      if (!alreadyExecuted) {
        alreadyExecuted1 = true;
        Navigator.of(context).pop();
      }
      // print(b);
      if (!mounted) return;
      setState(() {
        b = b;
        mfapplication = b['mfapplication'];
        mfadmin = b['mfadmin'];
        mfcronicle = b['mfcronicle'];
        mfconsumer = b['mfconsumer'];
        for (int i = 0; i < mfapplication.length; i++) {
          ap1.server = mfapplication[i]['server'];
          ap1.result = mfapplication[i]['build_result'];
          ap1.user = mfapplication[i]['user'];
          ap1.buildtime = mfapplication[i]['build_time'];
          if (i == 0 && mfapplication[0]['is_building']) {
            if (!alreadyExecuted) {
              _progressValueAP1 = mfapplication[0]['percent_value'] / 100;
              _cardList.add(_card1(
                  mfapplication[0]['server'],
                  'MF-application',
                  mfapplication[0]['user'],
                  mfapplication[0]['build_time'],
                  _progressValueAP1));
              callBuild(mfapplication[0]['build_estimate'], _progressValueAP1,
                  'MF-application', ap1, cnt);
              cnt++;
            }
          } else if (!alreadyExecuted) {
            _cardList2.add(_card2(
                mfapplication[0]['server'],
                'MF-application',
                mfapplication[0]['user'],
                mfapplication[0]['build_time'],
                mfapplication[0]['build_result']));
          }
          if (i == 1 && mfapplication[1]['is_building']) {
            ap2.server = mfapplication[i]['server'];
            ap2.result = mfapplication[i]['build_result'];
            ap2.user = mfapplication[i]['user'];
            ap2.buildtime = mfapplication[i]['build_time'];
            if (!alreadyExecuted) {
              _progressValueAP2 = mfapplication[1]['percent_value'] / 100;
              _cardList.add(_card1(
                  mfapplication[1]['server'],
                  'MF-application',
                  mfapplication[1]['user'],
                  mfapplication[1]['build_time'],
                  _progressValueAP2));
              callBuild(mfapplication[1]['build_estimate'], _progressValueAP2,
                  'MF-application', ap2, cnt);
              cnt++;
            }
          }
        }
        for (int i = 0; i < mfadmin.length; i++) {
          if (i == 0 && mfadmin[0]['is_building']) {
            ad1.server = mfadmin[i]['server'];
            ad1.result = mfadmin[i]['build_result'];
            ad1.user = mfadmin[i]['user'];
            ad1.buildtime = mfadmin[i]['build_time'];
            if (!alreadyExecuted) {
              _progressValueAD1 = mfadmin[0]['percent_value'] / 100;
              _cardList.add(_card1(
                  mfadmin[0]['server'],
                  'MF-Admin',
                  mfadmin[0]['user'],
                  mfadmin[0]['build_time'],
                  _progressValueAD1));
              callBuild(mfadmin[0]['build_estimate'], _progressValueAD1,
                  'MF-Admin', ad1, cnt);
              cnt++;
            }
          } else if (!alreadyExecuted) {
            _cardList2.add(_card2(
                mfadmin[0]['server'],
                'MF-Admin',
                mfadmin[0]['user'],
                mfadmin[0]['build_time'],
                mfadmin[0]['build_result']));
          }
          if (i == 1 && mfadmin[1]['is_building']) {
            ad2.server = mfadmin[i]['server'];
            ad2.result = mfadmin[i]['build_result'];
            ad2.user = mfadmin[i]['user'];
            ad2.buildtime = mfadmin[i]['build_time'];
            if (!alreadyExecuted) {
              _progressValueAD2 = mfadmin[1]['percent_value'] / 100;
              _cardList.add(_card1(
                  mfadmin[1]['server'],
                  'MF-Admin',
                  mfadmin[1]['user'],
                  mfadmin[1]['build_time'],
                  _progressValueAD2));
              callBuild(mfadmin[1]['build_estimate'], _progressValueAD2,
                  'MF-Admin', ad2, cnt);
              cnt++;
            }
          }
        }

        for (int i = 0; i < mfcronicle.length; i++) {
          cr1.server = mfcronicle[i]['server'];
          cr1.result = mfcronicle[i]['build_result'];
          cr1.user = mfcronicle[i]['user'];
          cr1.buildtime = mfcronicle[i]['build_time'];
          if (i == 0 && mfcronicle[0]['is_building']) {
            if (!alreadyExecuted) {
              _progressValueCR1 = mfcronicle[0]['percent_value'] / 100;
              _cardList.add(_card1(
                  mfcronicle[0]['server'],
                  'MF-Cronicle',
                  mfcronicle[0]['user'],
                  mfcronicle[0]['build_time'],
                  _progressValueCR1));
              callBuild(mfcronicle[0]['build_estimate'], _progressValueAP1,
                  'MF-Cronicle', cr1, cnt);
              cnt++;
            }
          } else if (!alreadyExecuted) {
            _cardList2.add(_card2(
                mfcronicle[0]['server'],
                'MF-Cronicle',
                mfcronicle[0]['user'],
                mfcronicle[0]['build_time'],
                mfcronicle[0]['build_result']));
          }
          if (i == 1 && mfcronicle[1]['is_building']) {
            cr2.server = mfcronicle[i]['server'];
            cr2.result = mfcronicle[i]['build_result'];
            cr2.user = mfcronicle[i]['user'];
            cr2.buildtime = mfcronicle[i]['build_time'];
            if (!alreadyExecuted) {
              _progressValueCR2 = mfcronicle[1]['percent_value'] / 100;
              _cardList.add(_card1(
                  mfcronicle[1]['server'],
                  'MF-Cronicle',
                  mfcronicle[1]['user'],
                  mfcronicle[1]['build_time'],
                  _progressValueCR2));
              callBuild(mfcronicle[1]['build_estimate'], _progressValueCR2,
                  'MF-Cronicle', cr2, cnt);
              cnt++;
            }
          }
        }
        for (int i = 0; i < mfconsumer.length; i++) {
          cn1.server = mfconsumer[i]['server'];
          cn1.result = mfconsumer[i]['build_result'];
          cn1.user = mfconsumer[i]['user'];
          cn1.buildtime = mfconsumer[i]['build_time'];
          if (i == 0 && mfconsumer[0]['is_building']) {
            if (!alreadyExecuted) {
              _progressValueCN1 = mfconsumer[0]['percent_value'] / 100;
              _cardList.add(_card1(
                  mfconsumer[0]['server'],
                  'MF-Consumer',
                  mfconsumer[0]['user'],
                  mfconsumer[0]['build_time'],
                  _progressValueCN1));
              callBuild(mfconsumer[0]['build_estimate'], _progressValueCN1,
                  'MF-Consumer', cn1, cnt);
              cnt++;
            }
            cn1.server = mfconsumer[i]['server'];
            cn1.result = mfconsumer[i]['build_result'];
            cn1.user = mfconsumer[i]['user'];
            cn1.buildtime = mfconsumer[i]['build_time'];
          } else if (!alreadyExecuted) {
            _cardList2.add(_card2(
                mfconsumer[0]['server'],
                'MF-Consumer',
                mfconsumer[0]['user'],
                mfconsumer[0]['build_time'],
                mfconsumer[0]['build_result']));
          }
          if (i == 1 && mfconsumer[1]['is_building']) {
            cn2.server = mfconsumer[i]['server'];
            cn2.result = mfconsumer[i]['build_result'];
            cn2.user = mfconsumer[i]['user'];
            cn2.buildtime = mfconsumer[i]['build_time'];
            if (!alreadyExecuted) {
              _progressValueCn2 = mfconsumer[1]['percent_value'] / 100;
              _cardList.add(_card1(
                  mfconsumer[1]['server'],
                  'MF-Consumer',
                  mfconsumer[1]['user'],
                  mfconsumer[1]['build_time'],
                  _progressValueCn2));
              callBuild(mfconsumer[0]['build_estimate'], _progressValueCn2,
                  'MF-application', cn2, cnt);
              cnt++;
            }
            cn2.server = mfconsumer[i]['server'];
            cn2.result = mfconsumer[i]['build_result'];
            cn2.user = mfconsumer[i]['user'];
            cn2.buildtime = mfconsumer[i]['build_time'];
          }
        }
        if (!alreadyExecuted) {
          alreadyExecuted = true;
        }
      });
    } else if (!alreadyExecuted) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Error getting data from server',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                actions: [
                  okButton,
                ],
              ));
      t2.cancel();
    }
  }

  void buildInfo() async {
    build1();
    int timer = 20;
    var oneSec = Duration(seconds: timer);
    // new Timer.periodic(oneSec, (t) async {
    //   build1();
    // });
    t2 = Timer.periodic(oneSec, (t2) async {
      build1();
    });
  }

  @override
  void dispose() {
    t2.cancel();
    super.dispose();
  }

  Widget _card1(
      String server, String jobName, String author, String time, progress) {
    return Card(
      elevation: 20,
      shadowColor: Colors.pink,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Server Name:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$server',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Job Name:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$jobName',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            // const Padding(padding: EdgeInsets.fromLTRB(10, 3, 0, 3)),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text('Progress:   ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                Transform.translate(
                  offset: const Offset(0, 3.5),
                  child: SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        minHeight: 10,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 32, 247, 32),
                        ),
                        value: progress,
                      )),
                ),
                Transform.translate(
                  offset: const Offset(3, 3.5),
                  child: Text('${(progress * 100).round()}%',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.purple)),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Started By:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$author',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Time And Date:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$time',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          ]),
    );
  }

  Widget _card2(String server, String jobName, String author, String time,
      String status) {
    return Card(
      elevation: 20,
      shadowColor: Colors.pink,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Server Name:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$server',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Job Name:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$jobName',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            // Padding(padding: EdgeInsets.fromLTRB(10, 5, 0, 0)),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text('Progress:',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$status',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Started By:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$author',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: const Text('Time And Date:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                Transform.translate(
                    offset: const Offset(0, 3),
                    child: Text(
                      '$time',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
              ],
            ),

            const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Build Status",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Card(
            elevation: 20,
            shadowColor: Colors.purple,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                ExpansionTile(
                  leading: const Icon(
                    Icons.event,
                    color: Colors.green,
                  ),
                  collapsedBackgroundColor: Colors.lightBlueAccent,
                  collapsedTextColor: Colors.black,
                  title: const Text('Active Build',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    ListView(
                      shrinkWrap: true,
                      children: <Widget>[(Column(children: _cardList))],
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(2)),
                ExpansionTile(
                  leading: const Icon(
                    Icons.event,
                    color: Colors.red,
                  ),
                  collapsedBackgroundColor: Colors.lightBlueAccent,
                  collapsedTextColor: Colors.black,
                  title: const Text('Last Build',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    ListView(
                      shrinkWrap: true,
                      children: <Widget>[(Column(children: _cardList2))],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => trackingPage()),
          );
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

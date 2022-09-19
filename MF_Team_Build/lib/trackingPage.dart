// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mf_team_build/commonwidget.dart';
import 'package:mf_team_build/connectserver.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class BuildCardData {
  dynamic server = '';
  dynamic user = '';
  dynamic buildtime = '';
  dynamic result = '';
  BuildCardData(
      {required this.server,
      required this.user,
      required this.buildtime,
      required this.result});
  BuildCardData.fromList(List<String> listOfserver) {
    server = listOfserver[0];
    user = listOfserver[1];
    buildtime = listOfserver[2];
    result = listOfserver[3];
  }
}

class _TrackingPageState extends State<TrackingPage> {
  late Map<int, dynamic> _cardList = {};
  late List<Widget> _cardList2 = [];
  late Map<dynamic, dynamic> responseJson = {};
  late double progressValuemfapplicationData = 0.0;
  late double progressValuemfapplicationData2 = 0;
  late double progressValuemfcronicleData = 0;
  late double progressValuemfcronicleData2 = 0;
  late double progressValuemfadminData = 0;
  late double progressValuemfadminData2 = 0;
  late double progressValuemfconsumerData = 0;
  late double progressValuemfconsumerData2 = 0;

  late List<dynamic> mfapplication = [];
  late List<dynamic> mfadmin = [];
  late List<dynamic> mfcronicle = [];
  late List<dynamic> mfconsumer = [];
  late BuildCardData mfapplicationData =
      BuildCardData.fromList(['', '', '', '']);
  late BuildCardData mfapplicationData2 =
      BuildCardData.fromList(['', '', '', '']);
  late BuildCardData mfcronicleData = BuildCardData.fromList(['', '', '', '']);
  late BuildCardData mfcronicleData2 = BuildCardData.fromList(['', '', '', '']);
  late BuildCardData mfconsumerData = BuildCardData.fromList(['', '', '', '']);
  late BuildCardData mfadminData = BuildCardData.fromList(['', '', '', '']);
  late BuildCardData mfconsumerData2 = BuildCardData.fromList(['', '', '', '']);
  late BuildCardData mfadminData2 = BuildCardData.fromList(['', '', '', '']);
  late bool visible = true;
  bool alreadyExecuted = false;
  bool alreadyExecuted1 = false;
  int cnt = -1;
  late Timer t2 = Timer(const Duration(milliseconds: 500), () {
    // SOMETHING
  });
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      startBuildData();
    });
  }

  void createActiveCard(buildestimate, progress, jobName, object1, cnt) async {
    var oneSec = Duration(seconds: buildestimate.round());
    Timer.periodic(oneSec, (Timer t) {
      if (!mounted) return;
      setState(() {
        if (progress.toStringAsFixed(2) == '0.99' && object1.result == 'None') {
          setState(() {
            progress += 0;
          });
        } else if (object1.result == 'SUCCESS' || object1.result == 'FAILURE') {
          _cardList.remove(cnt);
          // _cardList[cnt] = empty();
          _cardList2.add(_card2(object1.server, jobName, object1.user,
              object1.buildtime, object1.result));
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

  void buildcarddata() async {
    if (!alreadyExecuted) {
      createloadingwidget(
        responseJson,
        context,
      );
    }
    responseJson = await buildDataRequest();
    if (responseJson['statusCode'] == 200) {
      if (!alreadyExecuted) {
        alreadyExecuted1 = true;
        Navigator.of(context).pop();
      }
      if (!mounted) return;
      setState(() {
        mfapplication = responseJson['mfapplication'];
        mfadmin = responseJson['mfadmin'];
        mfcronicle = responseJson['mfcronicle'];
        mfconsumer = responseJson['mfconsumer'];
        buildData(
            "MF-Application",
            mfapplicationData,
            mfapplicationData2,
            mfapplication,
            progressValuemfapplicationData,
            progressValuemfapplicationData2,
            cnt);
        buildData("MF-Admin", mfadminData, mfadminData2, mfadmin,
            progressValuemfadminData, progressValuemfadminData2, cnt);
        buildData("MF-Cronicle", mfcronicleData, mfcronicleData2, mfcronicle,
            progressValuemfcronicleData, progressValuemfcronicleData2, cnt);
        buildData("MF-Consumer", mfconsumerData, mfconsumerData2, mfconsumer,
            progressValuemfconsumerData, progressValuemfconsumerData2, cnt);
        if (!alreadyExecuted) {
          alreadyExecuted = true;
        }
      });
    } else if (!alreadyExecuted) {
      // ignore: use_build_context_synchronously
      errordialogbox(okButton(context));
      t2.cancel();
    }
  }

  void errordialogbox(Widget okButton) {
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
  }

  void buildData(name, buildcardobj1, buildcardobj2, mfbuildData,
      progressvalue1, progressvalue2, cnt) {
    for (int i = 0; i < mfbuildData.length; i++) {
      if (i == 0) {
        buildcardobj1.server = mfbuildData[i]['server'];
        buildcardobj1.result = mfbuildData[i]['build_result'];
        buildcardobj1.user = mfbuildData[i]['user'];
        buildcardobj1.buildtime = mfbuildData[i]['build_time'];
        ongoingBuild(i, mfbuildData, buildcardobj1, progressvalue1, name, cnt);
      }
      if (!alreadyExecuted && mfbuildData[i]['is_building'] == false) {
        _cardList2.add(_card2(
            mfbuildData[i]['server'],
            name,
            mfbuildData[i]['user'],
            mfbuildData[i]['build_time'],
            mfbuildData[i]['build_result']));
      }
      if (i == 1) {
        buildcardobj2.server = mfbuildData[i]['server'];
        buildcardobj2.result = mfbuildData[i]['build_result'];
        buildcardobj2.user = mfbuildData[i]['user'];
        buildcardobj2.buildtime = mfbuildData[i]['build_time'];
        ongoingBuild(i, mfbuildData, buildcardobj2, progressvalue2, name, cnt);
      }
    }
  }

  void ongoingBuild(int i, mfbuildData, buildcardobj, progressval, name, cnt) {
    if (mfbuildData[i]['is_building']) {
      if (!alreadyExecuted) {
        this.cnt++;
        progressval = mfbuildData[i]['percent_value'] / 100;
        _cardList.addAll({
          this.cnt: _card1(mfbuildData[i]['server'], name,
              mfbuildData[i]['user'], mfbuildData[i]['build_time'], progressval)
        });
        createActiveCard(mfbuildData[i]['build_estimate'], progressval, name,
            buildcardobj, this.cnt);
      }
    }
  }

  void startBuildData() async {
    buildcarddata();
    int timer = 20;
    var oneSec = Duration(seconds: timer);
    t2 = Timer.periodic(oneSec, (t2) async {
      buildcarddata();
    });
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
            cardtext('Server Name:', server),
            cardtext('Job Name:', jobName),
            linearprogressbar('Progress:   ', progress),
            cardtext('Started By:', author),
            cardtext('Time And Date:', time),
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
            cardtext('Server Name:', server),
            cardtext('Job Name:', jobName),
            cardtext('Progress:', status),
            cardtext('Started By:', author),
            cardtext('Time And Date:', time),
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
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _cardList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        int key = _cardList.keys.elementAt(index);
                        return (Column(children: <Widget>[_cardList[key]]));
                      },
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
                    (Column(children: _cardList2)),
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
            MaterialPageRoute(builder: (context) => const TrackingPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    t2.cancel();
    super.dispose();
  }
}

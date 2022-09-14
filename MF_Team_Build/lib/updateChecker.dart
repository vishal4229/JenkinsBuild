// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autoupdate/flutter_autoupdate.dart';
import 'package:mf_team_build/login_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:version/version.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'SuccessPage.dart';
import 'connectserver.dart';

String update1 = 'Checking for Update...';
PackageInfo _packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
  buildSignature: 'Unknown',
);

class updateChecker extends StatefulWidget {
  const updateChecker({Key? key}) : super(key: key);

  @override
  State<updateChecker> createState() => _updateCheckerState();
}

class _updateCheckerState extends State<updateChecker> {
  String json_server_url = "https://api.npoint.io/c330164656dc623928a5";
  UpdateResult? _result;
  DownloadProgress? _download;
  var _startTime = DateTime.now().millisecondsSinceEpoch;
  var _bytesPerSec = 0;

  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    getserverUrl();
    _initPackageInfo();
    // checkCachelogin();
    initPlatformState();
    super.initState();
  }

  void checkCachelogin() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    if (username != '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SucessPage()),
      );
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }

    UpdateResult? result;
    if (!mounted) return;
    var versionUrl;
    versionUrl = json_server_url;
    var manager = UpdateManager(versionUrl: versionUrl);
    try {
      result = await manager.fetchUpdates();
      setState(() {
        _result = result;
      });
      print(_packageInfo.version);
      print(result?.latestVersion);
      if (Version.parse(_packageInfo.version) < result?.latestVersion) {
        setState(() {
          update1 = 'Downloading Update...';
        });
        var controller = await result?.initializeUpdate();
        controller?.stream.listen((event) async {
          setState(() {
            if (DateTime.now().millisecondsSinceEpoch - _startTime >= 1000) {
              _startTime = DateTime.now().millisecondsSinceEpoch;
              _bytesPerSec = event.receivedBytes - _bytesPerSec;
            }
            _download = event;
          });
          if (event.completed) {
            print("Downloaded completed");
            setState(() {
              update1 = 'Downloading completed"';
            });
            await controller.close();
            await result?.runUpdate(event.path, autoExit: true);
          }
        });
      } else {
        checkCachelogin();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => loginStatels()),
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      scrollable: false,
      title: Text(update1),
    );
  }
}

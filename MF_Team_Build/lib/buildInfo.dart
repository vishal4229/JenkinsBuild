// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// import 'trackingUtility.dart';

// void main() async {
//   await init();
// }

// Future init() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String notificationTitle = 'No Title';
//   String notificationBody = 'No Body';
//   String notificationData = 'No Data';

//   @override
//   void initState() {
//     main();
//     final firebaseMessaging = FCM();
//     firebaseMessaging.setNotifications();

//     firebaseMessaging.streamCtlr.stream.listen(_changeData);
//     firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
//     firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

//     super.initState();
//   }

//   _changeData(String msg) => setState(() => notificationData = msg);
//   _changeBody(String msg) => setState(() => notificationBody = msg);
//   _changeTitle(String msg) => setState(() => notificationTitle = msg);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               notificationTitle,
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             Text(
//               notificationBody,
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             Text(
//               notificationData,
//               style: Theme.of(context).textTheme.headline6,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

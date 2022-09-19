import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Future createloadingwidget(responseJson, context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async {
            return responseJson['statusCode'] == 200 ||
                responseJson['statusCode'] == 400;
          },
          child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: const Color.fromARGB(255, 1, 200, 255), size: 70)));
    },
  );
}

Widget cardtext(consttext, variable) {
  return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
        child: Text(consttext,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
      Transform.translate(
          offset: const Offset(0, 3),
          child: Text(
            variable,
            style: const TextStyle(
              fontSize: 16,
            ),
          )),
    ],
  );
}

Widget linearprogressbar(consttext, progress) {
  return Row(
    // mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
        child: Text(consttext,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
  );
}

void snackbar(BuildContext context, constText, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: const EdgeInsets.all(8),
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: Text(
            constText,
          ),
        ),
      )));
}

Widget formContainer(controller, labelText) {
  return Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
    ),
  );
}

Widget formPassContainer(controller, lableText) {
  return Container(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    child: TextField(
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: lableText,
      ),
    ),
  );
}

Widget okButton(context) {
  return TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Future dailogbox(context, titleText, constText, color) {
  return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(titleText, style: const TextStyle(color: Colors.red)),
            content: Text(
              constText,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            actions: [
              okButton(context),
            ],
          ));
}

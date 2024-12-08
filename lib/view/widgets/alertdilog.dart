import 'package:flutter/material.dart';

void testAlert(
    BuildContext context,
    String title,
    String messagecontet,
    void Function()? NOonPressed,
    String textbtnNO,
    void Function()? OKonPressed,
    String textbtnOk) {
  var alert = AlertDialog(
    title: Text(
      title,
      style: const TextStyle(fontSize: 24),
    ),
    content: Text(
      messagecontet,
      style: const TextStyle(fontSize: 18),
    ),
    actions: <Widget>[
      ElevatedButton(
        onPressed: NOonPressed,
        child: Text(
          textbtnNO,
          style: const TextStyle(color: Colors.deepPurple),
        ),
      ),
      ElevatedButton(
        onPressed: OKonPressed,
        child: Text(
          textbtnOk,
          style: const TextStyle(color: Colors.deepPurple),
        ),
      )
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

void checkAlert(BuildContext context, String title, String message) {
  var alert = AlertDialog(
    title: Text(title),
    content: Text(message),
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

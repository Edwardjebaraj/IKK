import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title1, String title2) {
  // set up the button
  Widget okButton =
      FlatButton(child: Text("OK"), onPressed: () => Navigator.pop(context));

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title1),
    content: Text(title2),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

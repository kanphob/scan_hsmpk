
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future passWordHistory(BuildContext context) async {
  String teamName = '';
  return showDialog(
    context: context,
    barrierDismissible: false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('กรุณากรอกรหัสผ่านของคุณ'),
        content: new Row(
          children: [
            new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(

                  ),
                  onChanged: (value) {
                    teamName = value;
                  },
                ))
          ],
        ),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: (){
              if(teamName == 'bigboss'){
                print('object');
              } else {
                _show();
              }
            },
          ),
        ],
      );
    },
  );
}
_show(){
  Fluttertoast.showToast(
      msg: "This is Center Short Toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/screen/historyOrder_screen.dart';
import 'package:scan_hsmpk/util/utility.dart';

Future passWordHistory(BuildContext context) async {
  String teamName = '';
  return showDialog(
    context: context,
    barrierDismissible: false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Util.mainBlue,
        title: Text('กรุณากรอกรหัสผ่านของคุณ',style: Util.txtStyleHeaderDialog,),
        content:Row(
          children: [
             Expanded(
                child:  TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                    icon: FaIcon(FontAwesomeIcons.key,color: Util.halfOrange,),
                    hintText: 'Password',
                  ),
                  onChanged: (value) {
                    teamName = value;
                  },
                ))
          ],
        ),
        actions: [
          FlatButton(
            color: Util.mainOrange,
            child: Text('ยืนยัน',
              style: Util.txtStyleNormal,
            ),
            onPressed: (){
              if(teamName == '0442'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryOrder(),));
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
      msg: "คุณไม่มีสิทธิ์ใช้งานเมนูนี้ค่ะ",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Util.mainOrange,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
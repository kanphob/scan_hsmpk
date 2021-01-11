import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/dialog/dialog_exit_app.dart';
import 'package:scan_hsmpk/funtion/txtbox.dart';
import 'package:scan_hsmpk/util/utility.dart';
class CheckPasswordDialog extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CheckPasswordDialog({Key key, this.scaffoldKey}) : super(key: key);
  @override
  _CheckPasswordDialogState createState() => _CheckPasswordDialogState();
}

class _CheckPasswordDialogState extends State<CheckPasswordDialog> {

  TextEditingController txtPass = TextEditingController();

  _checkPass(){
    if(txtPass.text == 'HSMPK0442'){
      Navigator.pop(context);
      _showScaffold('รหัสเข้าใช้งานถูกต้อง');
    }else{
      _errorPass();
    }
  }

  void _showScaffold(String message) {
    widget.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          margin: EdgeInsets.all(10),
          backgroundColor: Util.mainBlue,
          content: Text(message),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
      ),
    );
  }

    _errorPass(){
      return showDialog(
        context: context,
        builder: (context) {
          return errorDialog();
        },
      );
    }

  @override
  void dispose() {
    txtPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (context) => DialogExitApp(),
      ),
      child: AlertDialog(
        title: Text('ยินดีต้อนรับ',
          style: Util.txtStyleHeaderDialog,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height / 4.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'กรุณาระบุรหัสเพื่อเข้าใช้งาน',
                    style: Util.txtStyleNormal,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: txtPass,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      // isDense: true,
                      hintText: 'HSXXK04XX',
                      hintStyle: Util.txtStyleHint,
                    ),
                    style: Util.txtStyleNormal,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (val){
                      setState(() {
                        String valUp;
                        valUp = val.toUpperCase();
                        txtPass.text = valUp;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  FlatButton.icon(
                      icon: FaIcon(FontAwesomeIcons.signInAlt,color: Util.mainBlue,),
                      label: Text('ยืนยัน',style: TextStyle(color: Util.mainBlue),),
                      color: Util.mainOrange,
                      onPressed: (){
                        _checkPass();
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Util.mainBlue,
      ),
    );
  }

  Widget errorDialog(){
    return AlertDialog(
      title: Text(Util.sBanner,
        style: Util.txtStyleHeaderDialog,
      ),
      content: Text(
        'คุณกรอกรหัสผ่านไม่ถูกต้อง',
        style: TextStyle(
          color: Util.mainRed,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Util.mainBlue,
      actions: <Widget>[
        FlatButton.icon(
            icon: Icon(Icons.close,color: Colors.grey,),
            label: Text('ปิด',style: TextStyle(color: Colors.grey),),
            color: Util.mainGray,
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ],
    );
  }

}

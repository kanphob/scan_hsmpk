import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/funtion/txtbox.dart';
import 'package:scan_hsmpk/screen/inputorder_screen.dart';
import 'package:scan_hsmpk/util/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
class StartScreen extends StatelessWidget {
  final SizedBox w50 = SizedBox(width: 50,);
  final SizedBox h50 = SizedBox(height: 50,);
  TextEditingController txtPerID = TextEditingController();
  _onSave() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('sPerID',txtPerID.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.yellow[800],
                  Colors.yellow[700],
                  Colors.yellow[600],
                  Colors.yellow[400],
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 300,),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text('Scan-HSMPK',
                            style: TextStyle(fontSize: 50,color: Colors.white,fontFamily: 'Millionaire',),
                            textAlign: TextAlign.center,
                          ),
                      )
                    ],
                  ),
                  h50,
                  Row(
                    children: <Widget>[
                      w50,
                      Expanded(
                        flex: 1,
                          child: FaIcon(FontAwesomeIcons.users,
                          size: 30,
                            color: Util.mainWhite,
                          ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        flex: 9,
                        child: TxtBox(hintText:'ระบุรหัสประจำตัวพนักงาน',textAlign: TextAlign.center,ctrl: txtPerID,),
                      ),
                      w50,
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child:
                    RaisedButton(
                      child: Text('เข้าสู่ระบบ',style: Util.txtStyleNormal,),
                      onPressed: (){
                        _onSave();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InputOrderScreen(),));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/funtion/historydialog.dart';
import 'package:scan_hsmpk/screen/start_screen.dart';
import 'package:scan_hsmpk/util/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/utility.dart';
class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String sVersionApp = 'HSMPK v.Beta 2.1';
  String sPerId = " ";

  _getData() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final String sId = myPrefs.getString('sPerID');
    sPerId = sId;
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Util.mainBlue,
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/sidebarpic.jpg'),
                  matchTextDirection: true,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver),
                ),
              ),
              accountName: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FaIcon(FontAwesomeIcons.userAlt,color: Util.mainWhite,),
                      SizedBox(width: 10,),
                      Text(
                        sPerId,
                        style: Util.txtStyleNormal,
                      ),
                    ],
                  ),
              currentAccountPicture: CircleAvatar(
                child: Image.asset('assets/images/uAvatar1.png'),
                backgroundColor: Util.mainOrange ,
              ),
              // otherAccountsPictures: <Widget>[
              //   CircleAvatar(
              //     child: Text("N"),
              //     foregroundColor: Colors.white,
              //     backgroundColor: Colors.orange,
              //   ),
              //   CircleAvatar(
              //     child: Icon(Icons.add),
              //     foregroundColor: Colors.white,
              //     backgroundColor: Colors.grey,
              //   )
              // ],
            ),
            // Container(
            //   child:ListTile(
            //     leading: FaIcon(FontAwesomeIcons.home,color: Util.mainOrange,),
            //     title: Text('หน้าหลัก',style: Util.txtStyleSidebar,),
            //     onTap: (){
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => InputOrderScreen(),));
            //     },
            //   ),
            // ),
            // Divider(
            //   color: Util.halfOrange,
            //   height: 0,
            // ),
            Container(
              child:ListTile(
                leading: FaIcon(FontAwesomeIcons.history,color: Util.mainOrange,),
                title: Text('ประวัติ',style: Util.txtStyleSidebar,),
                onTap: (){
                  passWordHistory(context);
                },
              ),
            ),
            Divider(
              color: Util.halfOrange,
              height: 0,
            ),
            Container(
              child:ListTile(
                leading: FaIcon(FontAwesomeIcons.usersCog,color: Util.mainOrange,),
                title: Text('แก้ไขรหัสพนักงาน และ เลือกสาขา',style: Util.txtStyleSidebar,),
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen(),));
                },
              ),
            ),
            Divider(
              color: Util.halfOrange,
              height: 0,
            ),
            SizedBox(height: 10,),
            Container(
              child:ListTile(
                leading: FaIcon(FontAwesomeIcons.codeBranch,color: Util.mainOrange,),
                title: Text(sVersionApp,style: Util.txtStyleSidebar,),
              ),
            ),
            Divider(
              color: Util.halfOrange,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}


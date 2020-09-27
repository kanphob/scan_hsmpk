
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/funtion/historydialog.dart';
import 'package:scan_hsmpk/screen/inputorder_screen.dart';
import 'package:scan_hsmpk/screen/start_screen.dart';
import 'package:scan_hsmpk/util/utility.dart';

import '../util/utility.dart';
// ignore: must_be_immutable
class SideBar extends StatelessWidget {
  String sVersionApp = 'HSMPK v.Beta 1.1';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Util.mainBlue,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Util.halfOrange,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/sidebarpic.jpg'),
                ),
              ),
            ),
            Container(
              child:ListTile(
                leading: FaIcon(FontAwesomeIcons.home,color: Util.mainOrange,),
                title: Text('หน้าหลัก',style: Util.txtStyleSidebar,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InputOrderScreen(),));
                },
              ),
            ),
            Divider(
              color: Util.halfOrange,
              height: 0,
            ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StartScreen(),));
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
            // Divider(
            //   color: Util.halfOrange,
            //   height: 0,
            // ),
          ],
        ),
      )
    );
  }

}

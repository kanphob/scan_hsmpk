
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/funtion/historydialog.dart';
import 'package:scan_hsmpk/screen/inputorder_screen.dart';
import 'package:scan_hsmpk/util/utility.dart';

import '../util/utility.dart';
import '../util/utility.dart';
import '../util/utility.dart';
class SideBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Util.mainBlue,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
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
            Container(
              child:ListTile(
                leading: FaIcon(FontAwesomeIcons.history,color: Util.mainOrange,),
                title: Text('ประวัติ',style: Util.txtStyleSidebar,),
                onTap: (){
                  passWordHistory(context);
                },
              ),
            ),
          ],
        ),
      )
    );
  }

}

import 'package:flutter/material.dart';
import 'package:scan_hsmpk/util/utility.dart';
class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text('data'),
              ),
            ],
          ),
        ],
      )
    );
  }
}

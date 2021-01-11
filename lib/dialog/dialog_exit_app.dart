import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_hsmpk/util/utility.dart';

class DialogExitApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      title: Text(Util.sBanner,),
      titleTextStyle: Util.txtStyleHeaderDialog,
      backgroundColor: Util.mainGray,
      shape: Util.shapeR1,
      content: Container(
        height: MediaQuery.of(context).size.height / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height /9,
              decoration: BoxDecoration(
                color: Util.mainWhite,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'คุณต้องการออกจาก Application',
                textAlign: TextAlign.center,
                style: Util.txtStyleExit,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text('ใช่',
                    style: Util.txtStyleSidebar,
                  ),
                  shape: Util.shapeR1,
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                RaisedButton(
                  child: Text('ไม่',
                    style: Util.txtStyleSidebar,
                  ),
                  shape: Util.shapeR1,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

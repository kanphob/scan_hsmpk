import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/funtion/txtbox.dart';
import 'package:scan_hsmpk/menu/sidebar.dart';
import 'package:scan_hsmpk/util/utility.dart';
class HistoryOrder extends StatefulWidget {
  @override
  _HistoryOrderState createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  TextEditingController txtPerID = TextEditingController();
  var finalDate;
  DateTime dateTime;

  void _callDatePicker() async {
    var order = await getDate();
    setState(() {
      finalDate = order;
    });
  }


  @override
  void initState() {
    dateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (context) => willPop(),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: SideBar(),
          appBar: appBar(),
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
                  _inputPerId(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              'HistoryOrder',
              style: TextStyle(fontFamily: 'Millionaire', fontSize: 25),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // FaIcon(FontAwesomeIcons.user),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputPerId(){
    return Card(
      margin: EdgeInsets.only(top: 10,left: 10,right: 10),
      elevation: 10,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      color: Util.mainBlue,
      child: Padding(
        padding: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Util.w50,
                Expanded(
                  flex: 1,
                  child: FaIcon(FontAwesomeIcons.users,
                    size: 30,
                    color: Util.mainOrange,
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  flex: 9,
                  child: TxtBox(hintText:'ระบุรหัสประจำตัวพนักงาน',textAlign: TextAlign.center,ctrl: txtPerID,),
                ),
                Util.w50,
              ],
            ),
            Row(
              children: <Widget>[
                Util.w50,
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5,bottom: 5),
                    decoration: BoxDecoration(
                      color: Util.mainWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.calendar,color: Util.mainBlue,),
                      title: Text("${dateTime.day} - ${dateTime.month} - ${dateTime.year}",style: Util.txtStyleRecord,),
                      trailing: FaIcon(FontAwesomeIcons.arrowAltCircleLeft,color: Util.mainBlue,),
                      onTap: (){
                        choseDate();
                      },
                    ),
                  ),
                ),
                Util.w50,
              ],
            ),
            Row(
              children: <Widget>[
                Util.w50,
                Expanded(
                    child: 
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Text('ยืนยัน',
                        style: Util.txtStyleNormal,
                        ),
                        onPressed: (){
                        }
                    )
                ),
                Util.w50,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget willPop() {
    return AlertDialog(
      elevation: 5,
      title: Text('คุณต้องการออกจากแอบพลิเคชั่น'),
      titleTextStyle: TextStyle(fontSize: 20,color: Colors.black),
      actions: <Widget>[
        RaisedButton(
          child: Text('ใช่'),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
        RaisedButton(
          child: Text('ไม่'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  Future<void>choseDate()async{
    DateTime choseDateTime = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
    );
    if(choseDateTime != null){
      setState(() {
        dateTime = choseDateTime;
      });
    }

  }

}

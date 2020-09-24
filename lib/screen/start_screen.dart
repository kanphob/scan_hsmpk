import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/funtion/txtbox.dart';
import 'package:scan_hsmpk/model/modelProduct.dart';
import 'package:scan_hsmpk/screen/inputorder_screen.dart';
import 'package:scan_hsmpk/util/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/utility.dart';
import '../util/utility.dart';
import '../util/utility.dart';
import '../util/utility.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  TextEditingController txtPerID = TextEditingController();
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;
  bool _validate = false;

  _onSave() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString('sPerID',txtPerID.text);
    String sResult = myPrefs.getString('sPerID');
    if(sResult == txtPerID.text) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => InputOrderScreen(),));
    }
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name,
          ),
        ),
      );
    }
    return items;
  }
  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
  }
  @override
  void dispose() {
    txtPerID.dispose();
    super.dispose();
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
                        style: TextStyle(fontSize: 50,color: Colors.white,fontFamily: 'Millionaire',
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(5.0, 5.0),
                              blurRadius: 5.0,
                              color: Colors.black,
                            ),
                          ]
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                Util.h50,
                Row(
                  children: <Widget>[
                    Util.w50,
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
                      child: TxtBox(hintText:'ระบุรหัสประจำตัวพนักงาน',textAlign: TextAlign.center,ctrl: txtPerID,
                      errorTxt: _validate ? 'กรุณากรอกข้อมูลส่วนนี้' : null,
                      ),
                    ),
                    Util.w50,
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Util.w50,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Util.mainBlue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                         padding: Util.padding5,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: _selectedCompany,
                              items: _dropdownMenuItems,
                              onChanged: onChangeDropdownItem,
                              isExpanded: true,
                              dropdownColor: Util.mainBlue,
                              elevation: 5,
                              style: Util.txtStyleNormal,
                              icon: FaIcon(FontAwesomeIcons.warehouse,color: Util.mainWhite,),
                            ),
                        ),
                      ),
                    ),
                    Util.w50,
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child:
                  RaisedButton(
                    child: Text('เข้าสู่ระบบ',style: Util.txtStyleNormal,),
                    onPressed: () async {
                      if(txtPerID.text.isEmpty){
                        _validate = true;
                        setState(() {});
                        } else {
                        _validate = false;
                        await _onSave();
                      }

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

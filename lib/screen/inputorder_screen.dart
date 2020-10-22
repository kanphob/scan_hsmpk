import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:scan_hsmpk/funtion/gb.dart';
import 'package:share/share.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scan_hsmpk/database.dart';
import 'package:scan_hsmpk/funtion/txtbox.dart';
import 'package:scan_hsmpk/menu/sidebar.dart';
import 'package:scan_hsmpk/model/modelProduct.dart';
import 'package:scan_hsmpk/model/modelnotify.dart';
import 'package:scan_hsmpk/util/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:soundpool/soundpool.dart';

class InputOrderScreen extends StatefulWidget {
  @override
  _InputOrderScreenState createState() => _InputOrderScreenState();
}

class _InputOrderScreenState extends State<InputOrderScreen> {
  bool submitOrder = false;
  TextEditingController amountTxtController = TextEditingController();
  TextEditingController amountTempTxtController = TextEditingController();
  String sPerId = ' ';
  String sBarcode = "";
  List<ModelNotify> lOrder = [];
  ModelProduct modelProduct = ModelProduct();
  Firestore firebaseStore = Firestore.instance;
  DataRepository repository = DataRepository();
  final DateFormat formatterDate = DateFormat('yyyy-MM-dd');
  final DateFormat formatterTime = DateFormat('HH:mm');
  final DateFormat formatterDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
  String sSaveTime = "";
  int iMaxQuantityItem = 1;
  Future<int> _soundId;
  Future<int> _cheeringId;
  double _volume = 1.0;
  double _rate = 1.0;
  int _alarmSoundStreamId;

  _getData() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final String sId = myPrefs.getString('sPerID');
    sPerId = sId;
    amountTxtController.text = iMaxQuantityItem.toString();
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    _soundId = _loadSound();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _dialogQuantitySet();
    });
    super.initState();
  }

  Future<int> _loadSound() async {
    var asset = await rootBundle.load("assets/sounds/beep.wav");
    return await Globals.soundPool.load(asset);
  }

  Future<void> _playSound() async {
    var _alarmSound = await _soundId;
    _alarmSoundStreamId = await Globals.soundPool.play(_alarmSound);
  }

  Future<bool> _saveData() async {
    if (lOrder.length > 0) {
      DateTime dtCurrentDate = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute);
      for (int i = 0; i < lOrder.length; i++) {
        lOrder[i].setTotalItem = lOrder.length.toString();
        lOrder[i].setDate = formatterDate.format(dtCurrentDate);
        lOrder[i].setTime = formatterTime.format(dtCurrentDate);
        sSaveTime = formatterTime.format(dtCurrentDate);
        lOrder[i].sFullDateTime = dtCurrentDate.toString();
        lOrder[i].setTotalItem = lOrder.length.toString();
        lOrder[i].sIndex = (i + 1).toString();
        await repository.addProduct(lOrder[i]);
      }
      return true;
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              backgroundColor: Util.mainBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                "คุณยังไม่ได้ทำการเพิ่มสินค้า",
                style: Util.txtStyleNormal,
              ),
            );
          });
      return false;
    }
  }

  Future<int> sendMsg(String title) async {
    final uri = 'https://notify-api.line.me/api/notify';

    http.Response response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer cqJfwRExjZfR9aAZPTFJuAu0wmKNYvh0kO2iwLRIQcE",
      },
      body: {
        "message": title,
      },
    );
  }

  Future getAccessToken() async {
    try {
      final result = await LineSDK.instance.currentAccessToken;
      return result.value;
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void startLineLogin() async {
    try {
      final result = await LineSDK.instance.login(scopes: ["profile"]);
      print(result.toString());
      var accesstoken = await getAccessToken();
      var displayname = result.userProfile.displayName;
      var statusmessage = result.userProfile.statusMessage;
      var imgUrl = result.userProfile.pictureUrl;
      var userId = result.userProfile.userId;

      print("AccessToken> " + accesstoken);
      print("DisplayName> " + displayname);
      print("StatusMessage> " + statusmessage);
      print("ProfileURL> " + imgUrl);
      print("userId> " + userId);
    } on PlatformException catch (e) {
      print(e);
      switch (e.code.toString()) {
        case "CANCEL":
          print("User Cancel the login");
          break;
        case "AUTHENTICATION_AGENT_ERROR":
          print("User decline the login");
          break;
        default:
          print("Unknown but failed to login");
          break;
      }
    }
  }

  Future _signInLine() async {
    try {
      final result = await LineSDK.instance.login();
      // user id -> result.userProfile.userId
      // user name -> result.userProfile.displayName
      // user avatar -> result.userProfile.pictureUrl
      return result;
    } on PlatformException catch (e) {
      print("ไม่สามารเปิดใช้งานได้");
    }
  }

  _confirmSaveData() async {
    String sResult = await showDialog(
      context: context,
      builder: (_) {
        return _dialogConfirm();
      },
    );
  }

  _confirmDeleteData(String sBarcode) {
    return showDialog(
      context: context,
      builder: (_) {
        return _dialogDelete(sBarcode);
      },
    );
  }

  _limitOrder() {
    return showDialog(
      context: context,
      builder: (context) {
        return _limitOrderDialog();
      },
    );
  }

  _editOrder(String sText) {
    return showDialog(
      context: context,
      builder: (_) {
        return _dialogEditOrder(sText);
      },
    );
  }

  _saveAndPushDataToLine() async {
    String sName = "";
    String sTotalCount = "";
    List<String> listBarcode = new List();
    bool bSaveSuccess = await _saveData();
    if (bSaveSuccess) {
      await firebaseStore
          .collection("products")
          .orderBy('index')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.where((element) {
          if (element.data['time'] == sSaveTime) {
            return true;
          } else {
            return false;
          }
        }).forEach((result) {
          sName = result.data['name'];
          sTotalCount = result.data['total'];
          listBarcode.add(result.data['barcode']);
        });
      });

      String decodeListBarcode = "";
      for (int i = 0; i < listBarcode.length; i++) {
        if (i == 0) {
          decodeListBarcode += (listBarcode[i]);
        } else {
          decodeListBarcode += ("\n" + listBarcode[i]);
        }
      }

      String sResultTxt =
          "รหัสพนักงาน: $sName\nจำนวนออเดอร์: $sTotalCount ชิ้น\n$decodeListBarcode";

      lOrder.clear();
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              backgroundColor: Util.mainBlue,
              title: Text(
                "บันทึกสำเร็จ! ระบบจะส่งข้อความแจ้งเตือนไปในอีกสักครู่",
                style: Util.txtStyleNormal,
              ),
            );
          });
      await sendMsg(sResultTxt);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context, 'success');
      });
    }
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
                  submitOrder
                      ? Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: _inputUnitOrder(),
                  )
                      : Container(),
                  span(
                    height: 10,
                  ),
                  submitOrder
                      ? Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 20),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Util.mainBlue)),
                        child: showData(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade500,
                          borderRadius: BorderRadius.circular(15),
                          border:
                          Border.all(color: Colors.orange.shade600),
                        ),
                        child: FlatButton.icon(
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          label: Text(
                            "บันทึก และ ส่งข้อมูล",
                            style: Util.txtStyleNormal,
                          ),
                          onPressed: () async {
                            DateTime dtCurrentDate = DateTime(
                                DateTime
                                    .now()
                                    .year,
                                DateTime
                                    .now()
                                    .month,
                                DateTime
                                    .now()
                                    .day,
                                DateTime
                                    .now()
                                    .hour,
                                DateTime
                                    .now()
                                    .minute);
                            if (lOrder.length > 0) {
                              // _confirmSaveData();
                              var excel = Excel.createExcel();

                              final directory = await getExternalStorageDirectory();


                              Sheet sheetObject = excel['Sheet1'];


                              List<String> dataList = [
                                "#",
                                "Name",
                                "Barcode",
                                "Date",
                                "Time"
                              ];

                              sheetObject.insertRowIterables(dataList, 0);

                              for (int i = 0; i < lOrder.length; i++) {
                                String sName = lOrder[i].getName;
                                String sBarcode = lOrder[i].getBarcode;
                                String sDate = formatterDate.format(
                                    dtCurrentDate);
                                String sTime = formatterTime.format(
                                    dtCurrentDate);

                                List<String> dataList = [
                                  (i + 1).toString(),
                                  sName,
                                  sBarcode,
                                  sDate,
                                  sTime
                                ];

                                sheetObject.insertRowIterables(
                                    dataList, i + 1);
                              }

                              CellStyle cellStyle = CellStyle(
                                  fontFamily: getFontFamily(
                                      FontFamily.Calibri),
                                  horizontalAlign: HorizontalAlign
                                      .Center);

                              cellStyle.underline =
                                  Underline.Single; // or Underline.Double
                              for (int i = 0; i < 5; i++) {
                                var cell = sheetObject.cell(
                                    CellIndex.indexByColumnRow(
                                        columnIndex: i, rowIndex: 0));
                                cell.cellStyle = cellStyle;
                              }

                              excel.encode().then((onValue) async {
                                File file = File(directory.path +
                                    '/Report ${formatterDateTime.format(
                                        dtCurrentDate)}.xls')
                                  ..createSync(recursive: true)
                                  ..writeAsBytes(onValue);
                                print(file.path);

                                Share.shareFiles([
                                  '${directory
                                      .path}/Report ${formatterDateTime
                                      .format(dtCurrentDate)}.xls'
                                ], text: 'รายงาน ${formatterDateTime
                                    .format(dtCurrentDate)}');


                                // Uint8List bytes = file.readAsBytesSync();
                                // var fileShare = ByteData.view(bytes.buffer);
                                // await Share.files(
                                //     'Report ${formatterDateTime.format(dtCurrentDate)}',
                                //     {
                                //       'Report ${formatterDateTime.format(dtCurrentDate)}.xls': fileShare.buffer.asUint8List(),
                                //     },
                                //     '*/*',
                                //     text: 'รายงาน ${formatterDateTime.format(dtCurrentDate)}');


                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(
                                          "กรุณาเพิ่มรายการอย่างน้อย 1 รายการก่อนทำการบันทึก"),
                                      actions: <Widget>[
                                        FlatButton.icon(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey,
                                            ),
                                            label: Text(
                                              "ปิด",
                                              style: TextStyle(
                                                  color: Colors.grey),
                                            ))
                                      ],
                                    );
                                  });
                            }
                          },
                        ),
                      ),
                    ],
                  )
                      : Container()
                ],
              ),
            ),
          ),
          floatingActionButton: submitOrder ? plusOrder() : Container(),
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
            child: GestureDetector(
              child: Text(
                'Scan-HSMPK',
                style: TextStyle(fontFamily: 'Millionaire', fontSize: 25),
              ),
              onTap: () {},
            ),
          ),
          // Expanded(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: <Widget>[
          //       FaIcon(FontAwesomeIcons.user),
          //       span(width: 10),
          //       Text(
          //         sPerId,
          //         style: Util.txtStyleNormal,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _inputUnitOrder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            span(width: 30),
            Expanded(
                flex: 2,
                child: Text(
                  'จำนวนพัสดุ',
                  style: Util.txtStyleNormal,
                )),
            Expanded(
              flex: 1,
              child: RaisedButton(
                  padding: EdgeInsets.all(1),
                  child: FaIcon(
                    FontAwesomeIcons.minus,
                    color: Util.mainWhite,
                  ),
                  color: Util.mainRed,
                  onPressed: () {
                    if (iMaxQuantityItem > 1) {
                      iMaxQuantityItem -= 1;
                    }
                    setState(() {
                      amountTxtController.text = iMaxQuantityItem.toString();
                    });
                  }),
            ),
            span(width: 5),
            Expanded(
              flex: 2,
              child: TxtBox(
                bReadOnly: true,
                ctrl: amountTxtController,
                textAlign: TextAlign.center,
                kbType: TextInputType.number,
                onTap: () {
                  _editOrder(amountTxtController.text);
                },
              ),
            ),
            span(width: 5),
            Expanded(
              flex: 1,
              child: RaisedButton(
                  padding: EdgeInsets.all(1),
                  child: FaIcon(
                    FontAwesomeIcons.plus,
                    color: Util.mainWhite,
                  ),
                  color: Util.mainGreen,
                  onPressed: () {
                    iMaxQuantityItem += 1;
                    setState(() {
                      amountTxtController.text = iMaxQuantityItem.toString();
                    });
                  }),
            ),
            span(width: 10),
            Expanded(
              flex: 1,
              child: Text(
                'ชิ้น',
                style: Util.txtStyleNormal,
              ),
            ),
            span(width: 30),
          ],
        ),
        submitOrder
            ? Container()
            : Row(
          children: <Widget>[
            span(width: 50),
            Expanded(
              child: RaisedButton(
                  child: Text(
                    'ยืนยัน',
                    style: Util.txtStyleNormal,
                  ),
                  onPressed: () {
                    submitOrder = true;
                    setState(() {});
                  }),
            ),
            span(width: 50),
          ],
        ),
      ],
    );
  }

  Widget showData() {
    return Container(
      decoration: BoxDecoration(
        color: Util.mainWhite,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              'No.',
              style: Util.txtStyleField,
            ),
            title: Text(
              'Barcode',
              style: Util.txtStyleField,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(
              height: 1,
              color: Colors.orange,
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: lOrder.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    _listOrder(lOrder[index], index),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        height: 0,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                );
              }),
          ListTile(
            trailing: Text(
              'จำนวนทั้งหมด ' + lOrder.length.toString() + ' ชิ้น.',
              style: Util.txtStyleField,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listOrder(ModelNotify md, int index) {
    return ListTile(
      leading: Text(
        (index + 1).toString(),
        style: Util.txtStyleRecord,
      ),
      title: Text(
        md.getBarcode,
        style: Util.txtStyleRecord,
      ),
      trailing: GestureDetector(
        child: FaIcon(
          FontAwesomeIcons.minusCircle,
          color: Util.mainRed,
        ),
        onTap: () {
          _confirmDeleteData(md.getBarcode);
        },
      ),
    );
  }

  Widget plusOrder() {
    return FloatingActionButton(
      child: FaIcon(FontAwesomeIcons.plus),
      onPressed: () async {
        int iLimitOrder = 0;
        if (amountTxtController.text != null ||
            amountTxtController.text != '') {
          iLimitOrder = int.parse(amountTxtController.text);
        }
        if (lOrder.length == iLimitOrder) {
          _limitOrder();
        } else {
          // scan();
          startBarcodeScanStream();
        }
      },
    );
  }

  Widget willPop() {
    return AlertDialog(
      elevation: 5,
      title: Text('คุณต้องการออกจากแอบพลิเคชั่น'),
      titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
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

  Widget _dialogQuantitySet() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("กรุณาระบุจำนวนพัสดุ"),
            contentPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    span(width: 10),
                    Expanded(
                        flex: 2,
                        child: Text(
                          'จำนวน',
                          style: TextStyle(color: Colors.orange, fontSize: 18),
                        )),
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                          padding: EdgeInsets.all(1),
                          child: FaIcon(
                            FontAwesomeIcons.minus,
                            color: Util.mainWhite,
                          ),
                          color: Util.mainRed,
                          onPressed: () {
                            if (iMaxQuantityItem > 1) {
                              iMaxQuantityItem -= 1;
                            }
                            setState(() {
                              amountTxtController.text =
                                  iMaxQuantityItem.toString();
                            });
                          }),
                    ),
                    span(width: 10),
                    Expanded(
                      flex: 2,
                      child: TxtBox(
                        bReadOnly: true,
                        ctrl: amountTxtController,
                        textAlign: TextAlign.center,
                        kbType: TextInputType.number,
                        onTap: () {
                          _editOrder(amountTxtController.text);
                        },
                      ),
                    ),
                    span(width: 10),
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                          padding: EdgeInsets.all(1),
                          child: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Util.mainWhite,
                          ),
                          color: Util.mainGreen,
                          onPressed: () {
                            iMaxQuantityItem += 1;
                            setState(() {
                              amountTxtController.text =
                                  iMaxQuantityItem.toString();
                            });
                          }),
                    ),
                    span(width: 10),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'ชิ้น',
                        style: TextStyle(color: Colors.orange, fontSize: 18),
                      ),
                    ),
                    span(width: 10),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              RaisedButton(
                  child: Text(
                    'ยืนยัน',
                    style: Util.txtStyleNormal,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    submitOrder = true;
                    setState(() {});
                  }),
            ],
          );
        });
  }

  Widget _dialogConfirm() {
    return AlertDialog(
      content: Text(
        'คุณแน่ใจหรือไม่ว่าข้อมูลครบถ้วนแล้ว ถ้าแน่ใจกดปุ่ม "ยืนยัน" เพื่อส่งข้อมูล',
        style: Util.txtStyleNormal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Util.mainBlue,
      actions: <Widget>[
        RaisedButton(
            color: Util.mainGreen,
            child: Text(
              'ยืนยัน',
              style: Util.txtStyleNormal,
            ),
            onPressed: () async {
              Navigator.pop(context);
              String sResult = await _saveAndPushDataToLine();
              if (sResult == 'success') {
                setState(() {});
              }
            }),
        RaisedButton(
            color: Util.mainRed,
            child: Text(
              'ยกเลิก',
              style: Util.txtStyleNormal,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }

  Widget _dialogDelete(String sBarcode) {
    return AlertDialog(
      content: Text(
        'คุณแน่ใจหรือไม่ว่าต้องการลบสินค้ารหัส $sBarcode ถ้าแน่ใจกดปุ่ม "ยืนยัน" เพื่อลบข้อมูล',
        style: Util.txtStyleNormal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Util.mainBlue,
      actions: <Widget>[
        RaisedButton(
            color: Util.mainGreen,
            child: Text(
              'ยืนยัน',
              style: Util.txtStyleNormal,
            ),
            onPressed: () async {
              lOrder.removeWhere((item) => item.getBarcode == sBarcode);

              Navigator.pop(context);
              setState(() {});
            }),
        RaisedButton(
            color: Util.mainRed,
            child: Text(
              'ยกเลิก',
              style: Util.txtStyleNormal,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }

  Widget _limitOrderDialog() {
    return AlertDialog(
      content: Text(
        'จำนวนพัสดุของคุณครบจำนวนแล้ว',
        style: Util.txtStyleNormal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Util.mainBlue,
      // actions: <Widget>[
      //   RaisedButton(
      //       color: Util.mainGreen,
      //       child: Text('ยืนยัน',style: Util.txtStyleNormal,),
      //       onPressed: () async {
      //       }
      //   ),
      //   RaisedButton(
      //       color: Util.mainRed,
      //       child: Text('ยกเลิก',style: Util.txtStyleNormal,),
      //       onPressed: (){
      //         Navigator.pop(context);
      //       }
      //   ),
      // ],
    );
  }

  Widget _dialogEditOrder(String sText) {
    return AlertDialog(
      title: Text(
        'แก้ไขจำนวนพัสดุ',
        style: Util.txtStyleHeaderDialog2,
      ),
      content: TxtBox(
        bAutoFocus: true,
        inputFormatter: [WhitelistingTextInputFormatter.digitsOnly],
        ctrl: amountTempTxtController,
        textAlign: TextAlign.center,
        kbType: TextInputType.number,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Util.mainBlue,
      actions: <Widget>[
        RaisedButton(
            color: Util.mainGreen,
            child: Text(
              'ยืนยัน',
              style: Util.txtStyleNormal,
            ),
            onPressed: () async {
              amountTxtController.text = amountTempTxtController.text;
              iMaxQuantityItem = int.parse(amountTxtController.text);
              Navigator.pop(context);
            }),
        RaisedButton(
            color: Util.mainRed,
            child: Text(
              'ยกเลิก',
              style: Util.txtStyleNormal,
            ),
            onPressed: () {
              amountTxtController.text = sText;
              Navigator.pop(context);
            }),
      ],
    );
  }

  Widget span({
    double width,
    double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  startBarcodeScanStream() async {
    String sBarcode = "";
    StreamSubscription<dynamic> sD = FlutterBarcodeScanner
        .getBarcodeStreamReceiver(
        "#ff6666", "ปิด", true, ScanMode.BARCODE).listen((barcode) {
      // if(barcode != sBarcode){
      sBarcode = barcode;
      // if(sBarcode.contains("TH")) {


      if (lOrder.length > 0) {
        bool bHaveData = false;
        for (int i = 0; i < lOrder.length; i++) {
          String sBarcode = lOrder[i].getBarcode;
          if (sBarcode == barcode) {
            bHaveData = true;
          }
        }
        if (!bHaveData) {
          if (sBarcode.contains("TH")) {
            ModelNotify md = ModelNotify();
            md.setBarcode = sBarcode;
            md.setCount = "1";
            md.setName = sPerId;
            lOrder.add(md);
            _playSound();
          }
        }
      } else {
        if (sBarcode.contains("TH")) {
          ModelNotify md = ModelNotify();
          md.setBarcode = sBarcode;
          md.setCount = "1";
          md.setName = sPerId;
          lOrder.add(md);
          _playSound();
        }
      }
    }
    );
    int iLimitOrder = 0;
    if (amountTxtController.text != null ||
        amountTxtController.text != '') {
      iLimitOrder = int.parse(amountTxtController.text);
      if (lOrder.length == iLimitOrder) {
        sD.cancel();
      }
    }
  }

  Future scan() async {
    try {
      String barcode = "";

      if (lOrder.length > 0) {
        bool bHaveData = false;
        for (int i = 0; i < lOrder.length; i++) {
          String sBarcode = lOrder[i].getBarcode;
          if (sBarcode == barcode) {
            bHaveData = true;
          }
        }
        if (!bHaveData) {
          ModelNotify md = ModelNotify();
          md.setBarcode = barcode;
          md.setCount = "1";
          md.setName = sPerId;
          lOrder.add(md);
        } else {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text("รหัสบาร์โค้ดซ้ำ.."),
                  actions: <Widget>[
                    FlatButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                        label: Text(
                          "ปิด",
                          style: TextStyle(color: Colors.grey),
                        ))
                  ],
                );
              });
        }
      } else {
        ModelNotify md = ModelNotify();
        md.setBarcode = barcode;
        md.setCount = "1";
        md.setName = sPerId;
        lOrder.add(md);
      }
      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.sBarcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.sBarcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() =>
      this.sBarcode =
      'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.sBarcode = 'Unknown error: $e');
    }
  }
}

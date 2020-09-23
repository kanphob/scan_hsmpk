import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/database.dart';
import 'package:scan_hsmpk/funtion/txtbox.dart';
import 'package:scan_hsmpk/menu/sidebar.dart';
import 'package:scan_hsmpk/model/modelProduct.dart';
import 'package:scan_hsmpk/util/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputOrderScreen extends StatefulWidget {
  @override
  _InputOrderScreenState createState() => _InputOrderScreenState();
}

class _InputOrderScreenState extends State<InputOrderScreen> {
  bool submitOrder = false;
  TextEditingController amountTxtController = TextEditingController();
  String sPerId = ' ';
  String sBarcode = "";
  List<ModelProduct> lOrder = [];
  ModelProduct modelProduct = ModelProduct();
  Firestore firebaseStore = Firestore.instance;
  DataRepository repository = DataRepository();


  _getData() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final String sId = myPrefs.getString('sPerID');
    sPerId = sId;
    setState(() {
    });
  }


  @override
  void initState() {
    _getData();
    super.initState();
  }

  _saveData() async {
    for (int i = 0; i < lOrder.length; i++) {
        await repository.addProduct(lOrder[i]);
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
                  // Container(
                  //   margin: submitOrder
                  //       ? EdgeInsets.only(top: 20, bottom: 20)
                  //       : EdgeInsets.only(top: 300, bottom: 20),
                  //   child: inputUnitOrder(),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade500,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange.shade600),
                    ),
                    child: FlatButton.icon(
                        onPressed: () {
                          _saveData();
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          "บันทึก",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 5, bottom: 5, left: 20, right: 20),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Util.mainWhite)),
                    child: showData(),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: plusOrder(),
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
              onTap: () {
                print(lOrder.length);
              },
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.user),
                span(width: 10),
                Text(
                  sPerId,
                  style: Util.txtStyleNormal,
                ),
              ],
            ),
          ),
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
            span(width: 50),
            Expanded(
                flex: 3,
                child: Text(
                  'จำนวน Order',
                  style: Util.txtStyleNormal,
                )),
            Expanded(
              flex: 3,
              child: TxtBox(
                ctrl: amountTxtController,
                textAlign: TextAlign.end,
              ),
            ),
            span(width: 20),
            Expanded(
                flex: 2,
                child: Text(
                  'ชิ้น',
                  style: Util.txtStyleNormal,
                )),
            span(width: 50),
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
        color: Util.mainBlue,
        borderRadius: BorderRadius.circular(5),

      ),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: Util.padding5,
            leading: Text('No.',style: Util.txtStyleField,),
            title: Text('Barcode',style: Util.txtStyleField,),
          ),
          Divider(
            height: 0,
            color: Util.mainOrange,
          ),
          SizedBox(height: 10,),
          ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: lOrder.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    _listOrder(lOrder[index],index),
                    Container(
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(height: 0, color: Util.mainOrange,),
                    ),
                  ],);
              }),
          ListTile(
            trailing: Text('จำนวนทั้งหมด '+ lOrder.length.toString() + ' ชิ้น.',
              style: Util.txtStyleField,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listOrder(ModelProduct md,int index) {
    return Container(
      decoration: BoxDecoration(
          color: Util.mainWhite
      ),
      child: ListTile(
        leading: Text((index+1).toString(),
          style: Util.txtStyleRecord,
        ),
        title: Text(md.getsBarcode,
          style: Util.txtStyleRecord,
        ),
      ),
    );
  }

  Widget plusOrder() {
    return FloatingActionButton(
      child: FaIcon(FontAwesomeIcons.plus),
      onPressed: () {
        scan();
      },
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

  Widget span({
    double width,
    double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  Future scan() async {
    try {
      String barcode = "";
      barcode = await BarcodeScanner.scan();
      if (lOrder.length > 0) {
        bool bHaveData = false;
        for (int i = 0; i < lOrder.length; i++) {
          String sBarcode = lOrder[i].getsBarcode;
          if (sBarcode == barcode) {
            bHaveData = true;
          }
        }
        if (!bHaveData) {
          ModelProduct md = ModelProduct();
          md.setsBarcode = barcode;
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
        ModelProduct md = ModelProduct();
        md.setsBarcode = barcode;
        lOrder.add(md);
      }
      setState(() {

      });
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

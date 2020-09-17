import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scan_hsmpk/funtion/txtbox.dart';
import 'package:scan_hsmpk/menu/sidebar.dart';
import 'package:scan_hsmpk/model/modelProduct.dart';
import 'package:scan_hsmpk/util/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';


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



  _getData() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final String sId = myPrefs.getString('sPerID');
    sPerId = sId;
  }

  _processAddProduct()async{
    if (sBarcode != null && sBarcode != '') {
      String bar = sBarcode;
      int iRet = 0;
      lOrder.clear();
      // List<Map> lm = a
    }
  }

  @override
  void initState() {
    _getData();
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
                    Container(
                      margin: submitOrder ? EdgeInsets.only(top: 20,bottom: 20) : EdgeInsets.only(top: 300,bottom: 20),
                      child: inputUnitOrder(),
                    ),
                    submitOrder ? Container(
                      margin: EdgeInsets.only(top: 5,bottom: 5,left: 20,right: 20),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Util.mainWhite)
                      ),
                      child: showData(),
                    ) : Container(),
                  ],
                ),
              ),
            ),
            floatingActionButton: submitOrder ? plusOrder() : Container(),
          ),
        ),
    );
  }

  Widget appBar(){
    return AppBar(
      automaticallyImplyLeading: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: Text('Scan-HSMPK',style: TextStyle(fontFamily: 'Millionaire',fontSize: 25),),
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.user),
                  span(width: 10),
                  Text(sPerId,style: Util.txtStyleNormal,),
                ],
              ),
          ),
        ],
      ),
    );
  }

  Widget inputUnitOrder(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center
          ,
          children: <Widget>[
            span(width: 50),
            Expanded(
              flex: 3,
                child: Text('จำนวน Order',
                style: Util.txtStyleNormal,
                )
            ),
            Expanded(
              flex: 3,
                child: TxtBox(ctrl: amountTxtController,textAlign: TextAlign.end,),
            ),
            span(width: 20),
            Expanded(
              flex: 2,
                child: Text('ชิ้น',
                style: Util.txtStyleNormal,
                )
            ),
            span(width: 50),
          ],
        ),
        submitOrder ? Container() : Row(
          children: <Widget>[
            span(width: 50),
            Expanded(
              child: RaisedButton(
                  child: Text('ยืนยัน',style: Util.txtStyleNormal,),
                  onPressed: (){
                    submitOrder = true;
                    setState(() {});

                  }
              ),
            ),
            span(width: 50),
          ],
        ),
      ],
    );
  }

  Widget showData(){
    return DataTable(
      dividerThickness: 2,
        columns: [
          DataColumn(
              label: Text('Barcode'),
            numeric: false,
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                  Text(sBarcode),
              ),
            ],
          ),
        ],
    );
  }

  Widget _listOrder(){
    // return new ListView.builder(
    //     itemCount: lOrder.length,
    //    itemBuilder: (context, index) {
    //      return Text(lOrder[]);
    //    },
    // );
  }

  Widget plusOrder(){
    return FloatingActionButton(
      child: FaIcon(FontAwesomeIcons.plus),
        onPressed: (){
            scan();
          },
        );
  }
  
  Widget willPop(){
    return AlertDialog(
      title: Text('คุณต้องการออกจากแอบพลิเคชั่น'),
      actions: <Widget>[
        RaisedButton(
            child: Text('ใช่'),
            onPressed: (){
              SystemNavigator.pop();
            },
        ),
        RaisedButton(
          child: Text('ไม่'),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
  
  Widget span({
   double width,
    double height,
    }){
    return SizedBox(
      width: width,
      height: height,
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.sBarcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.sBarcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.sBarcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.sBarcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.sBarcode = 'Unknown error: $e');
    }
  }

}

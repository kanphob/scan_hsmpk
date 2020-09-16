import 'package:flutter/material.dart';
import 'package:scan_hsmpk/funtion/txtbox.dart';

import 'Product/addproduct.dart';

class InputOrderScreen extends StatefulWidget {
  @override
  _InputOrderScreenState createState() => _InputOrderScreenState();
}

class _InputOrderScreenState extends State<InputOrderScreen> {
  final Color mainWhite = Color(0xffF8F9FB);
  TextStyle normalTextStyle = TextStyle(color: Color(0xffF8F9FB),fontSize: 18);
  bool submitOrder = false;
  TextEditingController amountTxtController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
              ],
            ),
          ),
        ),
        floatingActionButton: submitOrder ? plusOrder() : Container(),
      ),
    );
  }
  Widget appBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Scan-HSMPK'),
    );
  }
  Widget inputUnitOrder(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            span(width: 50),
            Expanded(
              flex: 3,
                child: Text('จำนวน Order',
                style: normalTextStyle,
                )
            ),
            Expanded(
              flex: 3,
                child: TxtBox(ctrl: amountTxtController,),
            ),
            span(width: 20),
            Expanded(
              flex: 2,
                child: Text('ชิ้น',
                style: normalTextStyle,
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
                  child: Text('ยืนยัน'),
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
  Widget listOrder(){
    return Column();
  }
  Widget plusOrder(){
    return FloatingActionButton(
        onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(),));
          },
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
}

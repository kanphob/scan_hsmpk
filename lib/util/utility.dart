import 'package:flutter/material.dart';

class Util {
  static var  txtStyleNormal = TextStyle(color: mainWhite,fontSize: 18);
  static var  txtStyleSidebar = TextStyle(color: mainWhite,);
  static var  txtStyleField = TextStyle(color: mainBlue,fontSize: 18,fontWeight: FontWeight.w600);
  static var  txtStyleRecord = TextStyle(color: mainBlue,fontSize: 16,);
  static var  txtStyleHeaderDialog = TextStyle(color: mainOrange,fontSize: 20,fontWeight: FontWeight.w600);
  static var  txtStyleHeaderDialog2 = TextStyle(color: mainWhite,fontSize: 20,fontWeight: FontWeight.w600);
  static var  txtStyleHint = TextStyle(color: mainGray,fontSize: 16,);
  static var  txtStyleExit = TextStyle(color: mainBlue,fontSize: 18,);

  static var  halfOrange = Color(0xffFFBF3D);
  static var  mainOrange = Color(0xffFF8D01);
  static var  mainWhite = Color(0xffF8F9FB);
  static var  mainBlue = Color(0xff200440);
  static var  mainGreen = Color(0xff59D185);
  static var  mainRed = Color(0xffE3001A);
  static var  mainGray = Color(0xff363543);

  static var  padding5 = EdgeInsets.all(5);

  static var  w50 = SizedBox(width: 50,);
  static var  h50 = SizedBox(height: 50,);

  static var  sBanner = "Scan-HSMPK Message";

  static var shapeR1 = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
}
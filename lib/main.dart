import 'package:flutter/material.dart';
import 'package:scan_hsmpk/screen/start_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color halfOrange = Color(0xffFFBF3D);
 final Color mainOrange = Color(0xffFF8D01);
 final Color mainWhite = Color(0xffF8F9FB);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan_HSMPK',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: mainOrange,
        ),
        // primarySwatch: halfOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Millionaire',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: mainWhite,width: 2,),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: mainOrange,width: 2,),
          ),
          fillColor: halfOrange,
          filled: true,
        ),
        textTheme: TextTheme(),
        buttonTheme: ButtonThemeData(
          buttonColor: mainOrange,
          splashColor: halfOrange,
        ),
      ),
      home: StartScreen(),
    );
  }
}


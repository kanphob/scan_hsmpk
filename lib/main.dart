import 'package:flutter/material.dart';
import 'package:scan_hsmpk/screen/start_screen.dart';
import 'package:scan_hsmpk/util/utility.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LineSDK.instance.setup("1654959842").then((_) {
    print("LineSDK Prepared");
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'scan_hsmpk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Util.mainOrange,
        ),
        // fontFamily: 'Millionaire',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Util.mainWhite,width: 2,),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Util.mainOrange,width: 2,),
          ),
          fillColor: Util.halfOrange,
          filled: true,
        ),
        textTheme: TextTheme(
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Util.mainOrange,
          splashColor: Util.halfOrange,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Util.mainOrange,
          elevation: 5,
        ),

      ),
      home: StartScreen(),
    );
  }
}


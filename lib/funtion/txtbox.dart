import 'package:flutter/material.dart';
class TxtBox extends StatelessWidget {
  final double width;
  final double height;
  final TextEditingController ctrl;
  final Function() onTap;
  final String hintText;
  final int maxLines;
  final FocusNode focusNode;

  TxtBox({
    Key key,
    this.width,
    this.height = 35,
    this.ctrl,
    this.onTap,
    this.hintText,
    this.maxLines = 1,
    this.focusNode,
  }) : super(key: key);

  final Color mainWhite = Color(0xffFFBF3D);
  final Color mainOrange = Color(0xffFF8D01);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height == 0 ? null : height,
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        // style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1)),
        // cursorColor: Color.fromRGBO(221, 221, 221, 1),
        decoration: InputDecoration(
          hintText: hintText,
        ),
        textAlign: TextAlign.end,
        focusNode: focusNode,
        cursorColor: mainOrange,
        onTap: onTap == null ? () {} : onTap,
      ),
    );
  }
}

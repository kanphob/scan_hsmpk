import 'package:flutter/material.dart';
import 'package:scan_hsmpk/util/utility.dart';
class TxtBox extends StatelessWidget {

  final double width;
  final double height;
  final TextEditingController ctrl;
  final Function() onTap;
  final String hintText;
  final int maxLines;
  final FocusNode focusNode;
  final TextAlign textAlign;
  TxtBox({
    Key key,
    this.width,
    this.height,
    this.ctrl,
    this.onTap,
    this.hintText,
    this.maxLines = 1,
    this.focusNode,
    this.textAlign = TextAlign.justify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height == 0 ? null : height,
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: Util.txtStyleNormal,
        // cursorColor: Color.fromRGBO(221, 221, 221, 1),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          hintText: hintText,
          hintStyle: TextStyle(color: Util.mainWhite),
        ),
        textAlign: textAlign,
        focusNode: focusNode,
        cursorColor: Util.mainOrange,
        onTap: onTap == null ? () {} : onTap,
      ),
    );
  }
}

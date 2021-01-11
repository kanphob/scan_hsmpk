import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final String errorTxt;
  final TextInputType kbType;
  final bool bReadOnly;
  final bool bAutoFocus;
  final List<TextInputFormatter> inputFormatter;
  final Function onChange;

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
    this.errorTxt,
    this.kbType,
    this.bReadOnly = false,
    this.bAutoFocus = false,
    this.inputFormatter,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height == 0 ? null : height,
      child: TextField(
        readOnly: bReadOnly,
        controller: ctrl,
        maxLines: maxLines,
        style: Util.txtStyleNormal,
        inputFormatters: inputFormatter,
        // cursorColor: Color.fromRGBO(221, 221, 221, 1),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          hintText: hintText,
          hintStyle: TextStyle(color: Util.mainWhite),
          errorText: errorTxt,

        ),
        textAlign: textAlign,
        focusNode: focusNode,
        cursorColor: Util.mainOrange,
        onTap: onTap == null ? () {} : onTap,
        keyboardType: kbType,
        autofocus: bAutoFocus,
        onChanged: onChange,
      ),
    );
  }
}

import 'package:flutter/material.dart';
class ModelPersonal{

  String _sPerID;

  String get sGetPerId => _sPerID;
  set sSetPerID(String value) {
    _sPerID = value;
  }
  ModelPersonal(
      this._sPerID,
      );
}
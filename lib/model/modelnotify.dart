import 'package:cloud_firestore/cloud_firestore.dart';

class ModelNotify {
  String _sBarcode;
  String _sCount;
  String _sTotalItem;
  String _sName;
  String _sDate;
  String _sTime;
  String _sFullDateTime;
  String _sIndex;
  String _sBranch;
  DocumentReference sDocumentReference;

  String get getBarcode => _sBarcode;

  Map<String, dynamic> toJson() => _modelProductToJson(this);

  Map<String, dynamic> _modelProductToJson(ModelNotify instance) =>
      <String, dynamic>{
        'barcode': instance._sBarcode,
        'count': instance._sCount,
        'total': instance._sTotalItem,
        'name': instance._sName,
        'date': instance._sDate,
        'time': instance._sTime,
        'fulldate': instance._sFullDateTime,
        'branch': instance._sBranch,
        'index': instance._sIndex,
        'document': instance.sDocumentReference,
      };

  String get sIndex => _sIndex;

  set sIndex(String value) {
    _sIndex = value;
  }

  String get sFullDateTime => _sFullDateTime;

  set sFullDateTime(String value) {
    _sFullDateTime = value;
  }

  set setBarcode(String value) {
    _sBarcode = value;
  }

  String get getBranch => _sBranch;

  set setBranch(String value) {
    _sBranch = value;
  }

  DocumentReference get getDocRef => sDocumentReference;

  set setDocRef(DocumentReference value) {
    sDocumentReference = value;
  }

  String get getCount => _sCount;

  set setCount(String value) {
    _sCount = value;
  }

  String get getTime => _sTime;

  set setTime(String value) {
    _sTime = value;
  }

  String get getDate => _sDate;

  set setDate(String value) {
    _sDate = value;
  }

  String get getName => _sName;

  set setName(String value) {
    _sName = value;
  }

  String get getTotalItem => _sTotalItem;

  set setTotalItem(String value) {
    _sTotalItem = value;
  }


}
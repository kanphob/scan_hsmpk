class ModelNotify{
  String _sBarcode;
  String _sCount;
  String _sTotalItem;
  String _sName;
  String _sDate;
  String _sTime;

  String get getBarcode => _sBarcode;

  set setBarcode(String value) {
    _sBarcode = value;
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
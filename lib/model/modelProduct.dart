import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModelProduct {
  String _sBarcode;
  DocumentReference reference;

  String get getsBarcode => _sBarcode;

  set setsBarcode(String value) {
    _sBarcode = value;
  }

  Map<String, dynamic> toJson() => _modelProductToJson(this);

  Map<String, dynamic> _modelProductToJson(ModelProduct instance) =>
      <String, dynamic>{
        'barcode': instance._sBarcode,
      };
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(101, 'สมุทรปราการ'),
      Company(102, 'พญาไทย'),
    ];
  }
}

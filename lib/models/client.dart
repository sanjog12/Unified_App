import 'package:flutter/foundation.dart';

class Client {
  String _name;
  String _constitution;
  String _company;
  String _natureOfBusiness;
  String _email;
  String _phone;
  String _key;

  Client(this._name, this._constitution, this._company, this._natureOfBusiness,
      this._email, this._phone, this._key);
  
  set key(String value){
    _key = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set email(String value) {
    _email = value;
  }

  set natureOfBusiness(String value) {
    _natureOfBusiness = value;
  }

  set company(String value) {
    _company = value;
  }

  set constitution(String value) {
    _constitution = value;
  }

  set name(String value) {
    _name = value;
  }

  String get name => _name;
  
  String get key => _key;

  String get constitution => _constitution;

  String get company => _company;

  String get natureOfBusiness => _natureOfBusiness;

  String get email => _email;

  String get phone => _phone;
}

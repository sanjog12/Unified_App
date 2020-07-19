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

  String get name => _name;
  
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
  
  String get key => _key;

  String get constitution => _constitution;

  String get company => _company;

  String get natureOfBusiness => _natureOfBusiness;

  String get email => _email;

  String get phone => _phone;

// Couldn't get the Reflection class working for flutter, so i resorted to this dumb idea
//  Client setDynamicProperty(property, value) {
//    switch (property) {
//      case "name":
//        this.name = value;
//        return this;
//      case "constitution":
//        this.constitution = value;
//        return this;
//      case "company":
//        this.company = value;
//        return this;
//      case "natureOfBusiness":
//        this.natureOfBusiness = value;
//        return this;
//      case "email":
//        this.email = value;
//        return this;
//      case "phone":
//        this.phone = value;
//        return this;
//      default:
//        return this;
//    }
//  }
//
//  static List<dynamic> clientListToMap(List<Client> clientList) {
//    List returnList = [];
//    clientList.map((Client client) {
//      returnList.add({
//        "name": client.name,
//        "company": client.company,
//        "natureOfBusiness": client.natureOfBusiness,
//        "email": client.email,
//        "phone": client.phone,
//        "constitution": client.constitution,
//      });
//      return null;
//    }).toList();
//    return returnList;
//  }
}

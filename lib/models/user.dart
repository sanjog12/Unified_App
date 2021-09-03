import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  final String email;
  final String name;
  final String constitution;
  final String companyName;
  final String natureOfBusiness;
  final String mobileNumber;
  final bool isVerified;

  User(
      {this.email,
      this.name,
      this.constitution,
      this.natureOfBusiness,
      this.mobileNumber,
      this.companyName,
      this.isVerified});
}

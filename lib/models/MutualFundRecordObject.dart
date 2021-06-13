import 'package:flutter/cupertino.dart';
import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/MutualFundObject.dart';

class MutualFundRecordObject {
  MutualFundObject mutualFundObject;
  MutualFundDetailObject mutualFundDetailObject;
  String id,amount, type, frequency, sipFrequency;

  MutualFundRecordObject({
    this.id,
    this.sipFrequency,
    this.mutualFundObject,
    this.mutualFundDetailObject,
    this.amount,
    this.type,
    this.frequency,
  });
}

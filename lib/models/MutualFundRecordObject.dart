import 'package:unified_reminder/models/MutualFundDetailObject.dart';
import 'package:unified_reminder/models/MutualFundObject.dart';

class MutualFundRecordObject {
  MutualFundObject mutualFundObject;
  MutualFundDetailObject mutualFundDetailObject;
  String amount, type, frequency;

  MutualFundRecordObject({
    this.mutualFundObject,
    this.mutualFundDetailObject,
    this.amount,
    this.type,
    this.frequency,
  });
}

import 'package:flutter/material.dart';

class ClientOptedCompliances{
	final String clientName;
	final bool incomeTax , tds , epf , gst , ppf , mutualFund , roc , fixedDeposit , lic , esi;

  ClientOptedCompliances({this.clientName ,this.incomeTax, this.tds, this.epf, this.gst, this.ppf, this.mutualFund, this.roc, this.fixedDeposit, this.lic, this.esi});
}

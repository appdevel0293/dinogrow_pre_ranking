import 'package:flutter/material.dart';

class DisplayData {
  DisplayData(
      {this.chainLogo,
      this.chainName,
      this.balance,
      this.address,
      this.truncAddress});
  Image? chainLogo;
  String? chainName;
  String? balance;
  String? address;
  String? truncAddress;
}

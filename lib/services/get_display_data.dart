import 'package:dinogrow/Models/connectDataClass.dart';
import 'package:dinogrow/Models/displayDataClass.dart';
import 'package:dinogrow/services/get_balance.dart';
import 'package:flutter/material.dart';

Future<DisplayData> getDisplayData(ConnectData connectData) async {
  DisplayData displayData = DisplayData();
  switch (connectData!.selectedChain) {
    case Chain.bsc:
      displayData.chainLogo = Image.asset(
        "assets/binance.png",
      );
      displayData.chainName = "Binance";
      displayData.address = connectData.credEvm!.address.toString();
      displayData.balance = await balanceEvm(connectData);

    case Chain.polygon:
      displayData.chainLogo = Image.asset(
        "assets/polygon.png",
      );
      displayData.chainName = "Polygon";
      displayData.address = connectData.credEvm!.address.toString();
      displayData.balance = await balanceEvm(connectData);

    case Chain.solana:
      displayData.chainLogo = Image.asset(
        "assets/solana.png",
      );
      displayData.chainName = "Solana";
      displayData.address = connectData.credSolana!.address.toString();
      displayData.balance = await balanceSolana(connectData);
    case null:
      return displayData;
  }
  displayData.truncAddress = truncateString(displayData.address!);
  return displayData;
}

String truncateString(String input) {
  String first = input.substring(0, 3);
  String last = input.substring(input.length - 3);
  return '$first...$last';
}

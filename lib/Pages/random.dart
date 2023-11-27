import 'dart:developer';

import 'package:dinogrow/Models/connectDataClass.dart';
import 'package:dinogrow/Models/displayDataClass.dart';
import 'package:dinogrow/services/connect_data.dart';
import 'package:dinogrow/services/get_display_data.dart';
import 'package:dinogrow/services/save_score.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SelectNumber extends StatefulWidget {
  const SelectNumber({super.key});
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<SelectNumber> {
  int randomNumber = 0;
  bool isFrozen = false;
  ConnectData connectData = ConnectData();
  DisplayData displayData = DisplayData();

  @override
  void initState() {
    super.initState();

    startRandomNumberGenerator();
  }

  void startRandomNumberGenerator() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!isFrozen) {
        setState(() {
          randomNumber = Random().nextInt(1000);
        });
      }
    });
  }

  void freezeNumber() {
    setState(() {
      isFrozen = true;
    });
  }

  void display_result(String result) {
    String truncResult = truncateString(result);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: displayData.chainLogo,
              ),
              Text("Transaction Completed with result"),
            ],
          ),
          content: Row(
            children: [
              Text(" $truncResult"),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: result));
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                GoRouter.of(context).go("/home");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a number!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go("/home");
        },
        backgroundColor: Colors.white.withOpacity(0.3),
        child: const Icon(
          Icons.arrow_back,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (!isFrozen) {
            freezeNumber();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Random Number: $randomNumber',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              if (isFrozen)
                ElevatedButton(
                  onPressed: () async {
                    connectData = await getconnectdata();
                    displayData = await getDisplayData(connectData);
                    final result =
                        await saveScore(connectData, BigInt.from(randomNumber));

                    display_result(result);
                  },
                  child: Text('Send Score'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String truncateString(String input) {
  String first = input.substring(0, 3);
  String last = input.substring(input.length - 3);
  return '$first...$last';
}

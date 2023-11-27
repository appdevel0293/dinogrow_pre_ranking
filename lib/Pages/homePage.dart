import 'package:dinogrow/Models/connectDataClass.dart';
import 'package:dinogrow/Models/displayDataClass.dart';
import 'package:dinogrow/services/connect_data.dart';
import 'package:dinogrow/services/get_display_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = const FlutterSecureStorage();

  ConnectData connectData = ConnectData();
  DisplayData displayData = DisplayData();

  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go("/selectChain");
        },
        backgroundColor: Colors.white.withOpacity(0.3),
        child: const Icon(
          Icons.arrow_back,
        ),
      ),
      appBar: AppBar(
        title: Text("Connected to ${displayData.chainName} "),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text(displayData.truncAddress ?? ''),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: displayData.address ?? ''));
                },
              ),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: displayData.chainLogo,
              ),
              Text(
                displayData.balance ?? 'Loading...',
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go("/random");
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                  20,
                ))),
            child: const Text(
              'Play',
              style: TextStyle(fontSize: 17),
            ),
          )
        ],
      ),
    );
  }

  _readData() async {
    connectData = await getconnectdata();
    displayData = await getDisplayData(connectData);
    setState(() {});
  }
}

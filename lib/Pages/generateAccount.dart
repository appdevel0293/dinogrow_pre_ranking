import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class GenerateAccountScreen extends StatefulWidget {
  const GenerateAccountScreen({super.key});

  @override
  State<GenerateAccountScreen> createState() => _GenerateAccountScreenState();
}

class _GenerateAccountScreenState extends State<GenerateAccountScreen> {
  final storage = const FlutterSecureStorage();
  String _mnemonic = "";
  Icon iconButton = const Icon(Icons.copy);
  bool _copied = false;
  @override
  void initState() {
    super.initState();
    _generateMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent.shade700,
        title: const Text("Seed Phrase"),
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              _mnemonic,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _mnemonic));
                  setState(() {
                    iconButton = const Icon(Icons.check);
                  });
                },
                icon: iconButton,
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _copied,
                onChanged: (value) {
                  setState(() {
                    _copied = value!;
                  });
                },
              ),
              const Text(
                "I have stored the recovery phrase securely",
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: _copied
                    ? Colors.purple.shade600
                    : Colors.tealAccent.shade700,
                minimumSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                  20,
                ))),
            onPressed: _copied
                ? () async {
                    await storage.write(key: 'mnemonic', value: _mnemonic).then(
                        (value) => GoRouter.of(context).go("/passwordSetup/"));
                  }
                : () {
                    GoRouter.of(context).go("/");
                  },
            child: Text(
              _copied ? 'Continue' : 'Go Back',
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateMnemonic() async {
    String mnemonic = bip39.generateMnemonic();

    setState(() {
      _mnemonic = mnemonic;
    });
  }
}

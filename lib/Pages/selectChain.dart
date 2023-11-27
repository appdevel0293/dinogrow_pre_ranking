import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class SelectChain extends StatefulWidget {
  const SelectChain({super.key});

  @override
  State<SelectChain> createState() => _SelectChainState();
}

class _SelectChainState extends State<SelectChain> {
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Chain"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go("/");
        },
        backgroundColor: Colors.white.withOpacity(0.3),
        child: const Icon(
          Icons.arrow_back,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _writeChainAndNavigate(context, "polygon"),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: Image.asset(
                        "assets/polygon.png",
                      ),
                    ),
                    const Text("Polygon"),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () => _writeChainAndNavigate(context, "bsc"),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: Image.asset(
                        "assets/binance.png",
                      ),
                    ),
                    const Text("Binance Smart Chain"),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () => _writeChainAndNavigate(context, "solana"),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: Image.asset(
                        "assets/solana.png",
                      ),
                    ),
                    const Text("Solana"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _writeChainAndNavigate(BuildContext context, chain) async {
    await storage
        .write(key: 'chain', value: chain)
        .then((value) => GoRouter.of(context).go("/home"));
  }
}

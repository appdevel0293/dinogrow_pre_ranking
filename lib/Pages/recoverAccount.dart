import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:bip39/bip39.dart' as bip39;

class InputPhraseScreen extends StatefulWidget {
  const InputPhraseScreen({super.key});

  @override
  State<InputPhraseScreen> createState() => _InputPhraseScreenState();
}

class _InputPhraseScreenState extends State<InputPhraseScreen> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _words = List<String>.filled(12, '');
  bool validationFailed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go("/");
        },
        backgroundColor: Colors.white.withOpacity(0.3),
        child: const Icon(
          Icons.arrow_back,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Please enter your recovery phrase',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            Center(
              child: Form(
                key: _formKey,
                child: SizedBox(
                    width: 300,
                    height: 400,
                    child: SingleChildScrollView(
                      child: GridView.count(
                        padding: const EdgeInsets.all(3),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 3,
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children: List.generate(12, (index) {
                          return SizedBox(
                            height: 50,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintText: '${index + 1}',
                              ),
                              onSaved: (value) {
                                _words[index] = value!;
                              },
                            ),
                          );
                        }),
                      ),
                    )),
              ),
            ),
            Text(validationFailed ? 'Invalid keyphrase' : '',
                style: TextStyle(color: Colors.red)),
            Spacer(),
            SizedBox(
              width: 200,
              child: TextButton(
                onPressed: () {
                  _onSubmit(context);
                },
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String mnemonic = _words.join(' ');
      final t = bip39.validateMnemonic(mnemonic);
      if (t) {
        await storage
            .write(key: 'mnemonic', value: mnemonic)
            .then((value) => GoRouter.of(context).go("/passwordSetup/"));
      } else {
        setState(() {
          validationFailed = true;
        });
      }
    }
  }
}

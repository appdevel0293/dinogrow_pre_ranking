// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  bool validationFailed = false;
  String? password;
  String? key;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _checkForSavedLogin().then((credentialsFound) {
      if (!credentialsFound) {
        GoRouter.of(context).go("/setup");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Center(
            child: Image.asset(
              'assets/logo.png',
              width: 200,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      validator: (value) {
                        if (value != password) {
                          setState(() {
                            validationFailed = true;
                          });
                          return;
                        }
                        GoRouter.of(context).go("/selectChain");
                        // Validation
                      }),
                  const SizedBox(height: 8),
                  Text(validationFailed ? 'Invalid Password' : '',
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(220, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                          20,
                        ))),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(220, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                            20,
                          ))),
                      onPressed: () {
                        onDifferentAccountPressed(context);
                      },
                      child: const Text(
                        'Use different Account',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  onDifferentAccountPressed(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'Access to current account will be lost if seed phrase is lost.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go("/setup");
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  Future<bool> _checkForSavedLogin() async {
    key = await storage.read(key: 'mnemonic');
    password = await storage.read(key: 'password');
    if (key == null || password == null) {
      return false;
    } else {
      return true;
    }
  }
}

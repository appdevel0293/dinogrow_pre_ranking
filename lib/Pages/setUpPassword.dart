import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class SetUpPasswordScreen extends StatefulWidget {
  const SetUpPasswordScreen({super.key});

  @override
  State<SetUpPasswordScreen> createState() => _SetUpPasswordScreenState();
}

class _SetUpPasswordScreenState extends State<SetUpPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Password'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  }),
              const SizedBox(height: 16),
              TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  }),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                      20,
                    ))),
                onPressed: _submit,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 17),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        return;
      }

      await storage.write(key: 'password', value: passwordController.text);

      GoRouter.of(context).go("/");
    }
  }
}

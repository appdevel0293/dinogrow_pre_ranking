import 'package:dinogrow/Pages/Login.dart';
import 'package:dinogrow/Pages/falling_boxes.dart';
import 'package:dinogrow/Pages/homePage.dart';
import 'package:dinogrow/Pages/recoverAccount.dart';
import 'package:dinogrow/Pages/selectChain.dart';
import 'package:dinogrow/Pages/setUpAccount.dart';
import 'package:dinogrow/Pages/setUpPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

final GoRouter _router = GoRouter(routes: <GoRoute>[
  GoRoute(
      path: '/',
      builder: (context, state) {
        return const LoginPage();
      }),
  GoRoute(
      path: '/setup',
      builder: (context, state) {
        return const SetUpScreen();
      }),
  GoRoute(
      path: '/inputPhrase',
      builder: (context, state) {
        return const InputPhraseScreen();
      }),
  GoRoute(
      path: '/generatePhrase',
      builder: (context, state) {
        return const InputPhraseScreen();
      }),
  GoRoute(
      path: '/passwordSetup',
      builder: (context, state) {
        return const SetUpPasswordScreen();
      }),
  GoRoute(
      path: '/selectChain',
      builder: (context, state) {
        return const SelectChain();
      }),
  GoRoute(
      path: '/home',
      builder: (context, state) {
        return const MyHomePage();
      }),
  GoRoute(
      path: '/random',
      builder: (context, state) {
        return const GameWidgetFallingBoxes();
      }),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.dark().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[500],
        )),
        primaryColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[850],
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

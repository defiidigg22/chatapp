// main.dart
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login.dart';
import 'sign_up.dart';
import 'chatapp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/chat': (context) => ChatApp(),
      },
    );
  }
}

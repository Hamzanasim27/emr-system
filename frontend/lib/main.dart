import 'package:flutter/material.dart';

import 'core/api/api_client.dart';
import '/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiClient.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: LoginScreen(),
    );
  }
}
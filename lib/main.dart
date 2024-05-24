import 'dart:io';

import 'package:ders_rotam/pages/http_overrides.dart';
import 'package:ders_rotam/pages/web_page.dart';
import 'package:ders_rotam/public/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
      primarySwatch: Colors.red,
        useMaterial3: false,
      ),
      home: const WebPage(),
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,

    );
  }
}





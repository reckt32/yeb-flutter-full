import 'package:cog_proh/a2.dart';
import 'package:cog_proh/a3.dart';
import 'package:cog_proh/login/l8.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'a1.dart';
import 'a11.dart';
import 'package:cog_proh/otherCode/aad1.dart';
import 'package:cog_proh/otherCode/aadi2.dart';
import 'package:cog_proh/otherCode/aadi3.dart';
import 'gd_screen.dart';
import 'announcements_screen/announcements_screen.dart';
import 'package:provider/provider.dart';
import 'package:cog_proh/utils.dart';
import 'req_ext_gd.dart';
import 'login/l8.dart';


void main() {
  runApp(
    // AppState to manage the stages of completion.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Announcements(),
      home: LoginPage(),
      //home: FeedbackScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:hedeyety/pages/AuthPage.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: AuthPage(),
      appBar: AppBar(
        title: Text("Hedeyety"),
        centerTitle: true,
      ),
    ),
  ));
}

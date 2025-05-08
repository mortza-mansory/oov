import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oov/bindings/bingings.dart';
import 'package:oov/screen/HomeScreen.dart';
import 'package:oov/utils/theme.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VpnApp',
      theme: AppTheme.theme, 
      home: HomeScreen(),
      initialBinding: MyBindings(),
    );
  }
}
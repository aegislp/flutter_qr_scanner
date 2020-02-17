import 'package:flutter/material.dart';
import 'package:qrscaner/pages/home_page.dart';
import 'package:qrscaner/pages/map_page.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QrScaner',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'map': (BuildContext context) => MapPage()
      },
      theme: ThemeData(
        primaryColor: Colors.deepOrange
      ),
    );
  }
}











import 'package:flutter/material.dart';
import './login-page.dart';
import './pages/register-page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    MyHomePage.tag: (context) => MyHomePage(),
    RegisterPage.tag: (context) => RegisterPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do List',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MyHomePage(),
    );
  }
}

/** 
 * 
      title: 'To do List',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MyHomePage(title: ''),
      register: RegisterPage(),

      initialRoute: '/',
      routes: {
      '/': (context) => MyHomePage(),
      '/register': (context) => RegisterPage(),
    }, 

 * **/
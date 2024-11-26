import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import './login-page.dart';
import './pages/register-page.dart';
import './pages/recoveryPassword-page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? userId;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    // Aqui, você pode buscar o userId da sessão, armazenamento local, etc.
    // Por enquanto, vamos definir um valor fictício para teste.

    // Simulando a obtenção do userId
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Defina userId como null ou um valor real para testes
      userId = null; // Ou algum valor de teste como '12345'
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do List',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: userId == null ? MyHomePage() : InicialMain(userId: userId!),
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
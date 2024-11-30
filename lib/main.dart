import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import './login-page.dart';
import './pages/register-page.dart';
import './pages/recoveryPassword-page.dart';

// para notificação
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? userId;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    checkUserLoggedIn();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
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
      theme: AppTheme.lightTheme, // Tema claro
      darkTheme: AppTheme.darkTheme, // Tema escuro
      themeMode: ThemeMode.system, // Alterna com base no sistema
      home: userId == null ? MyHomePage() : InicialMain(userId: userId!),
    );
  }
}

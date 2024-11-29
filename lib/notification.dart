import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationTestApp extends StatefulWidget {
  @override
  _NotificationTestAppState createState() => _NotificationTestAppState();
}

class _NotificationTestAppState extends State<NotificationTestApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    requestNotificationPermission();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> showNotification() async {
    const String title = 'Olá, Mundo!';
    const String body = 'Esta é uma notificação de exemplo.';

    await flutterLocalNotificationsPlugin.show(
      1, // ID único da notificação
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel_id',
          'Test Notifications',
          channelDescription: 'Canal de Notificações de Teste',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notificação enviada: $title')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Notificações'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: showNotification, // Chama a notificação
          child: const Text('Enviar Notificação'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationTestApp(),
  ));
}
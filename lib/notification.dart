import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class NotificationTestApp extends StatefulWidget {
  @override
  _NotificationTestAppState createState() => _NotificationTestAppState();
}

class _NotificationTestAppState extends State<NotificationTestApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    requestNotificationPermission();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> scheduleNotification(DateTime scheduledTime) async {
    const String title = 'Lembrete: Hora de Dormir!';
    const String body = 'Está na hora de descansar e recarregar as energias.';

    final difference = scheduledTime.difference(DateTime.now()).inSeconds;

    if (difference > 0) {
      await Future.delayed(Duration(seconds: difference), () async {
        await flutterLocalNotificationsPlugin.show(
          1, // ID único da notificação
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'sleep_reminder_channel',
              'Sleep Reminder Notifications',
              channelDescription: 'Canal para lembretes de hora de dormir',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Notificação agendada para: ${DateFormat('dd/MM/yyyy HH:mm').format(scheduledTime)}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione um horário no futuro.')),
      );
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Notificação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedDateTime == null
                  ? 'Nenhuma data e hora selecionada'
                  : 'Data e hora selecionada: ${DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime!)}',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => pickDateTime(context),
              child: const Text('Selecionar Data e Hora'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedDateTime == null
                  ? null
                  : () => scheduleNotification(selectedDateTime!),
              child: const Text('Agendar Notificação'),
            ),
          ],
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

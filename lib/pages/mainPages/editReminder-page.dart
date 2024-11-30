import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Importar para formatação de datas

DateTime parseDate(String dateString) {
  try {
    DateFormat format = DateFormat("dd/MM/yyyy HH:mm");
    return format.parse(dateString);
  } catch (e) {
    throw FormatException("Erro ao interpretar a data: $e");
  }
}

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static Future<Map<String, dynamic>> createReminder({
    required String userId,
    required String titulo,
    required String descricao,
    required String horario,
  }) async {
    final url = Uri.parse('$baseUrl/lembretes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'titulo': titulo,
        'descricao': descricao,
        'horario': horario,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao criar lembrete: ${response.body}');
    }
  }

  static Future<void> updateReminder({
    required String reminderId,
    required String titulo,
    required String descricao,
    required String horario,
  }) async {
    final url = Uri.parse('$baseUrl/lembretes/$reminderId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'titulo': titulo,
        'descricao': descricao,
        'horario': horario,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar lembrete: ${response.body}');
    }
  }
}

class CreateEditReminderScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic>? reminder;

  const CreateEditReminderScreen({Key? key, required this.userId, this.reminder})
      : super(key: key);

  @override
  _CreateEditReminderScreenState createState() =>
      _CreateEditReminderScreenState();
}

class _CreateEditReminderScreenState extends State<CreateEditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late String _titulo;
  late String _descricao;
  late DateTime _dataLimite;
  late TimeOfDay _horaLimite;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _initializeReminderData();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _initializeReminderData() {
    if (widget.reminder != null) {
      _titulo = widget.reminder!['titulo'] ?? '';
      _descricao = widget.reminder!['descricao'] ?? '';
      try {
        _dataLimite = widget.reminder!['horario'] != null
            ? parseDate(widget.reminder!['horario'])
            : DateTime.now();

        if (_dataLimite.isBefore(DateTime.now())) {
          _dataLimite = DateTime.now();
        }
      } catch (e) {
        _dataLimite = DateTime.now();
      }
      _horaLimite = TimeOfDay.fromDateTime(_dataLimite);
    } else {
      _titulo = '';
      _descricao = '';
      _dataLimite = DateTime.now();
      _horaLimite = TimeOfDay.now();
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime initialDate =
        _dataLimite.isBefore(DateTime.now()) ? DateTime.now() : _dataLimite;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _horaLimite,
      );

      if (time != null) {
        setState(() {
          _dataLimite = date;
          _horaLimite = time;
        });
      }
    }
  }

  Future<void> _saveReminder() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final horario = DateTime(
        _dataLimite.year,
        _dataLimite.month,
        _dataLimite.day,
        _horaLimite.hour,
        _horaLimite.minute,
      );

      final formattedHorario = DateFormat("dd/MM/yyyy HH:mm").format(horario);

      try {
        if (widget.reminder == null) {
          await ApiService.createReminder(
            userId: widget.userId,
            titulo: _titulo,
            descricao: _descricao,
            horario: formattedHorario,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Novo lembrete criado com sucesso!')),
          );
        } else {
          await ApiService.updateReminder(
            reminderId: widget.reminder!['id'],
            titulo: _titulo,
            descricao: _descricao,
            horario: formattedHorario,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lembrete atualizado com sucesso!')),
          );
        }

        await _scheduleNotification(horario);

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar lembrete! Tente novamente.')),
        );
      }
    }
  }

  Future<void> _scheduleNotification(DateTime horario) async {
    final difference = horario.difference(DateTime.now()).inSeconds;

    if (difference > 0) {
      Future.delayed(Duration(seconds: difference), () async {
        await flutterLocalNotificationsPlugin.show(
          1,
          'Lembrete: $_titulo',
          _descricao,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'reminder_channel',
              'Lembretes',
              channelDescription: 'Canal para lembretes agendados',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um horário no futuro.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.reminder == null ? 'Novo Lembrete' : 'Editar Lembrete',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _titulo,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _titulo = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _descricao,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descricao = value!;
                },
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _selectDateTime,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${_dataLimite.day.toString().padLeft(2, '0')}/'
                  '${_dataLimite.month.toString().padLeft(2, '0')}/'
                  '${_dataLimite.year} '
                  '${_horaLimite.hour.toString().padLeft(2, '0')}:' 
                  '${_horaLimite.minute.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 16),
            
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _saveReminder,
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
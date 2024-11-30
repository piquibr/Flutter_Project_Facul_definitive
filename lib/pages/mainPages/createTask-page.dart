import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static Future<Map<String, dynamic>> createTask({
    required String userId,
    required String titulo,
    required String descricao,
    required String horario,
    required String status,
    required String categoria,
  }) async {
    final url = Uri.parse('$baseUrl/tarefas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'titulo': titulo,
        'descricao': descricao,
        'horario': horario,
        'status': status,
        'categoria': categoria,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao criar tarefa: ${response.body}');
    }
  }
}

class Createtask extends StatelessWidget {
  final String userId;

  const Createtask({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreatetaskScreen(userId: userId);
  }
}

class CreatetaskScreen extends StatefulWidget {
  final String userId;

  const CreatetaskScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _CreatetaskState createState() => _CreatetaskState();
}

class _CreatetaskState extends State<CreatetaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _descricao = '';
  DateTime _dataLimite = DateTime.now();
  TimeOfDay _horaLimite = TimeOfDay.now();
  String _status = 'Começar';
  String _categoria = 'Pessoal';
  List<String> _categorias = ['Pessoal', 'Trabalho', 'Estudo'];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    requestExactAlarmPermission();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid && (await Permission.scheduleExactAlarm.isDenied)) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final horario = DateTime(
        _dataLimite.year,
        _dataLimite.month,
        _dataLimite.day,
        _horaLimite.hour,
        _horaLimite.minute,
      );

      final formattedHorario = DateFormat('dd/MM/yyyy HH:mm').format(horario);

      try {
        await ApiService.createTask(
          userId: widget.userId,
          titulo: _titulo,
          descricao: _descricao,
          horario: formattedHorario,
          status: _status,
          categoria: _categoria,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa criada com sucesso!')),
        );

        await _scheduleNotification(horario);

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar tarefa!')),
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
              'Tarefas',
              channelDescription: 'Notificações de tarefas agendadas',
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

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dataLimite,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Insira um título' : null,
                onSaved: (value) => _titulo = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 5,
                onSaved: (value) => _descricao = value!,
              ),
              const SizedBox(height: 16.0),
              TextButton.icon(
                onPressed: _selectDateTime,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${_dataLimite.day}/${_dataLimite.month}/${_dataLimite.year} ${_horaLimite.format(context)}',
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Começar', 'Andamento', 'Concluída']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: _categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _categoria = value!),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: _saveTask,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
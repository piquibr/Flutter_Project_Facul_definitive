import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  static Future<void> updateTask({
    required String taskId,
    required String titulo,
    required String descricao,
    required String horario,
    required String status,
    required String categoria,
  }) async {
    final url = Uri.parse('$baseUrl/tarefas/$taskId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'titulo': titulo,
        'descricao': descricao,
        'horario': horario,
        'status': status,
        'categoria': categoria,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar tarefa: ${response.body}');
    }
  }
}

class EditTask extends StatelessWidget {
  final Map<String, dynamic>? task;
  final String userId;

  const EditTask({Key? key, this.task, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: task == null ? 'Nova Tarefa' : 'Editar Tarefa',
      home: CreateEditTaskScreen(task: task, userId: userId),
    );
  }
}

class CreateEditTaskScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic>? task;

  const CreateEditTaskScreen({Key? key, required this.userId, this.task})
      : super(key: key);

  @override
  _CreateEditTaskScreenState createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late String _titulo;
  late String _descricao;
  late DateTime _dataLimite;
  late TimeOfDay _horaLimite;
  late String _status;
  late String _categoria;

  final List<String> _categorias = ['Pessoal', 'Trabalho', 'Estudo'];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _initializeTaskData();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _initializeTaskData() {
    if (widget.task != null) {
      _titulo = widget.task!['titulo'] ?? '';
      _descricao = widget.task!['descricao'] ?? '';
      _categoria = _categorias.contains(widget.task!['categoria'])
          ? widget.task!['categoria']
          : _categorias.first;
      _status =
          ['Começar', 'Andamento', 'Concluída'].contains(widget.task!['status'])
              ? widget.task!['status']
              : 'Começar';
      _dataLimite = widget.task!['horario'] != null
          ? parseDate(widget.task!['horario'])
          : DateTime.now();
      _horaLimite = TimeOfDay.fromDateTime(_dataLimite);
    } else {
      _titulo = '';
      _descricao = '';
      _status = 'Começar';
      _categoria = _categorias.first;
      _dataLimite = DateTime.now();
      _horaLimite = TimeOfDay.now();
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

      final formattedHorario = DateFormat("dd/MM/yyyy HH:mm").format(horario);

      try {
        if (widget.task == null) {
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
        } else {
          await ApiService.updateTask(
            taskId: widget.task!['id'],
            titulo: _titulo,
            descricao: _descricao,
            horario: formattedHorario,
            status: _status,
            categoria: _categoria,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa atualizada com sucesso!')),
          );
        }

        await _scheduleNotification(horario);

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao salvar tarefa! Tente novamente.')),
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
              'task_channel',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _titulo,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Insira o título' : null,
                  onSaved: (value) => _titulo = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _descricao,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 5,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Insira a descrição'
                      : null,
                  onSaved: (value) => _descricao = value!,
                ),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Torna os filhos com largura total
                  children: [
                    ElevatedButton(
                      onPressed: _saveTask,
                      child: Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

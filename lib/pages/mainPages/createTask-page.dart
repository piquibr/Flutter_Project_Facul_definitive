import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; 
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz; 
import 'package:intl/intl.dart'; // Importar para formatação de datas
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // Criar tarefa
  static Future<Map<String, dynamic>> createTask({
    required String userId,
    required String titulo,
    required String descricao,
    required String horario,
    required String status,
    required String categoria,
  }) async {
    print('Enviando solicitação para criar tarefa...');
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

    print('Resposta recebida: ${response.statusCode}');
    if (response.statusCode == 201) {
      print('Tarefa criada com sucesso.');
      return json.decode(response.body);
    } else {
      print('Erro ao criar tarefa: ${response.body}');
      throw Exception('Erro ao criar tarefa: ${response.body}');
    }
  }
}

class Createtask extends StatelessWidget {
  final String userId; // Recebe o userId como argumento

  const Createtask({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova Tarefa',
      home: CreatetaskScreen(userId: userId), // Passa o userId para a tela
    );
  }
}

class CreatetaskScreen extends StatefulWidget {
  final String userId; // Recebe o userId como argumento

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
  late String _userId; // Para armazenar o userId localmente
  String _status = 'Começar';
  String _categoria = 'Pessoal';
  List<String> _categorias = ['Pessoal', 'Trabalho', 'Estudo'];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _userId = widget.userId; // Inicializa o userId a partir do widget recebido
    initializeNotifications();
    requestExactAlarmPermission();
  }

  void initializeNotifications() async {
    print('Inicializando notificações...');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
    print('Notificações inicializadas com sucesso.');
  }

  Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid && (await Permission.scheduleExactAlarm.isDenied)) {
      print('Solicitando permissão para agendar alarmes exatos...');
      await Permission.scheduleExactAlarm.request();
      if (await Permission.scheduleExactAlarm.isGranted) {
        print('Permissão para agendar alarmes exatos concedida.');
      } else {
        print('Permissão para agendar alarmes exatos negada.');
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

      final formattedHorario = DateFormat('dd/MM/yyyy HH:mm').format(horario);
      print('Tentando salvar tarefa com título: $_titulo');

      try {
        await ApiService.createTask(
          userId: _userId,
          titulo: _titulo,
          descricao: _descricao,
          horario: formattedHorario,
          status: _status,
          categoria: _categoria,
        );
        print('Tarefa salva com sucesso');

        // Agendar a notificação
        print('Agendando notificação para a tarefa: $_titulo na data $horario');
        await scheduleNotification(
          'Tarefa Vencendo: $_titulo',
          'Sua tarefa "$_titulo" está marcada para ${_horaLimite.format(context)}!',
          horario,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tarefa criada com sucesso!')),
        );

        Navigator.pop(context, true); // Retorna um indicador de sucesso
      } catch (e) {
        print('Erro ao salvar tarefa: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar tarefa!')),
        );
      }
    }
  }

  Future<void> scheduleNotification(String title, String body, DateTime scheduledDate) async {
    print('Agendando notificação: $title para $scheduledDate');
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID da notificação (pode ser único para cada tarefa)
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Para notificar no horário específico
    );
    print('Notificação agendada com sucesso para $scheduledDate');
  }

  Future<void> _selectDateTime() async {
    print('Abrindo seletor de data e hora...');
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
        print('Data e hora selecionadas: $_dataLimite $_horaLimite');
      }
    }
  }

  void _addCategoria() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String novaCategoria = '';
        return AlertDialog(
          title: Text('Adicionar Nova Categoria'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Digite o nome da categoria'),
            onChanged: (value) {
              novaCategoria = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                if (novaCategoria.isNotEmpty) {
                  setState(() {
                    _categorias.add(novaCategoria);
                    _categoria = novaCategoria; // Seleciona a nova categoria
                  });
                  print('Nova categoria adicionada: $novaCategoria');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Tarefa'),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            print('Voltando para a tela anterior...');
            Navigator.pop(context); // Volta à tela anterior
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _titulo = value!;
                  print('Título da tarefa salvo: $_titulo');
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 5,
                onSaved: (value) {
                  _descricao = value!;
                  print('Descrição da tarefa salva: $_descricao');
                },
              ),
              SizedBox(height: 16.0),
              TextButton.icon(
                onPressed: _selectDateTime,
                icon: Icon(Icons.calendar_today),
                label: Text(
                    '${_dataLimite.day}/${_dataLimite.month}/${_dataLimite.year} ${_horaLimite.format(context)}'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(labelText: 'Status'),
                items:
                    ['Começar', 'Andamento', 'Concluída'].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                    print('Status da tarefa alterado para: $_status');
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _categoria,
                      decoration: InputDecoration(labelText: 'Categoria'),
                      items: _categorias.map((String categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria,
                          child: Text(categoria),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _categoria = newValue!;
                          print('Categoria da tarefa alterada para: $_categoria');
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addCategoria,
                    tooltip: 'Adicionar Nova Categoria',
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              SaveTaskButton(onPressed: _saveTask),
            ],
          ),
        ),
      ),
    );
  }
}

class SaveTaskButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveTaskButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        ),
        onPressed: () {
          print('Botão de salvar tarefa pressionado');
          onPressed();
        },
        child: const Text(
          'Salvar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
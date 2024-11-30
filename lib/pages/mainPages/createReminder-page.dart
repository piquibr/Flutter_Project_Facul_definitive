import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // Criar lembrete
  static Future<Map<String, dynamic>> createReminder({
    required String userId,
    required String titulo,
    required String descricao,
    required String horario,
  }) async {
    final url = Uri.parse('$baseUrl/lembretes');
    try {
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
    } catch (e) {
      print('Erro ao conectar à API: $e');
      rethrow;
    }
  }
}

class CreateReminderScreen extends StatefulWidget {
  final String userId;

  const CreateReminderScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _CreateReminderScreenState createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String _titulo = '';
  String _descricao = '';
  DateTime _dataLimite = DateTime.now();
  TimeOfDay _horaLimite = TimeOfDay.now();
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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

      final formattedHorario = DateFormat('dd/MM/yyyy HH:mm').format(horario);

      try {
        // Criar lembrete na API
        await ApiService.createReminder(
          userId: widget.userId,
          titulo: _titulo,
          descricao: _descricao,
          horario: formattedHorario,
        );

        // Agendar notificação
        await _scheduleNotification(horario);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lembrete criado com sucesso!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar lembrete!')),
        );
      }
    }
  }

  Future<void> _scheduleNotification(DateTime horario) async {
    final difference = horario.difference(DateTime.now()).inSeconds;

    if (difference > 0) {
      Future.delayed(Duration(seconds: difference), () async {
        await flutterLocalNotificationsPlugin.show(
          1, // ID único da notificação
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
        title: const Text('Novo Lembrete'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                hint: 'Título',
                onSaved: (value) => _titulo = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, insira um título' : null,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                hint: 'Descrição',
                onSaved: (value) => _descricao = value!,
                maxLines: 5,
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
              SaveReminderButton(
                onPressed: _saveReminder,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color.fromARGB(40, 0, 0, 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
          ),
          validator: validator,
          onSaved: onSaved,
          maxLines: maxLines,
        ),
      ),
    );
  }
}

class SaveReminderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveReminderButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Salvar'),
      ),
    );
  }
}

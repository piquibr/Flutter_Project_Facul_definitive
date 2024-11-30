import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
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
  static const String baseUrl = 'http://localhost:8080/api';

  // Criar lembrete
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

  // Atualizar lembrete
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

  // Obter detalhes da tarefa
  static Future<Map<String, dynamic>> getReminderDetails(
      String reminderId) async {
    final url = Uri.parse('$baseUrl/lembrete/$reminderId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao obter detalhes da lembrete: ${response.body}');
    }
  }
}

class EditReminder extends StatelessWidget {
  final Map<String, dynamic>? reminder; // Adicionado para receber a lembrete
  final String userId;

  const EditReminder({Key? key, this.reminder, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          reminder == reminder.toString() ? 'Novo Lembrete' : 'Editar Lembrete',
      home: CreateEditReminderScreen(reminder: reminder, userId: userId),
    );
  }
}

class CreateEditReminderScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic>? reminder;

  const CreateEditReminderScreen(
      {Key? key, required this.userId, this.reminder})
      : super(key: key);

  @override
  _CreateEditReminderScreenState createState() =>
      _CreateEditReminderScreenState();
}

class _CreateEditReminderScreenState extends State<CreateEditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _titulo;
  late String _descricao;
  late DateTime _dataLimite;
  late TimeOfDay _horaLimite;

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
  void initState() {
    super.initState();
    _initializeReminderData();
  }

  void _initializeReminderData() {
    if (widget.reminder != null) {
      _titulo = widget.reminder!['titulo'] ?? '';
      _descricao = widget.reminder!['descricao'] ?? '';

      _dataLimite = widget.reminder!['horario'] != null
          ? parseDate(widget.reminder!['horario'])
          : DateTime.now();
      _horaLimite = TimeOfDay.fromDateTime(_dataLimite);
    } else {
      _titulo = '';
      _descricao = '';
      _dataLimite = DateTime.now();
      _horaLimite = TimeOfDay.now();
    }

    // Debug prints para verificar os dados recebidos
    print('User ID recebido: ${widget.userId}');
    print('Lembrete recebida: ${widget.reminder}');
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
          print('Novo lembrete criado com sucesso');
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
          print('Lembrete atualizada com sucesso');
        }

        Navigator.pop(context, true); // Retorna um indicador de sucesso
      } catch (e) {
        print('Erro ao salvar lembrete: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar lembrete! Tente novamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.reminder == null ? 'Novo Lembrete' : 'Editar Lembrete',
            style: TextStyle(color: Colors.white)),
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
                decoration: InputDecoration(labelText: 'Título'),
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
              SizedBox(height: 16),
              TextFormField(
                initialValue: _descricao,
                decoration: InputDecoration(labelText: 'Descrição'),
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
              SizedBox(height: 16),
              TextButton.icon(
                onPressed: _selectDateTime,
                icon: Icon(Icons.calendar_today),
                label: Text(
                    '${_dataLimite.day}/${_dataLimite.month}/${_dataLimite.year} ${_horaLimite.format(context)}'),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Torna os filhos com largura total
                children: [
                  ElevatedButton(
                    onPressed: _saveReminder,
                    child: Text('Salvar'),
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

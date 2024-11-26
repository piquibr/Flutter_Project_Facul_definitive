import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Biblioteca para formatação de data e hora

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // Criar lembrete
  static Future<Map<String, dynamic>> createReminder({
    required String userId,
    required String titulo,
    required String descricao,
    required String dataHora,
  }) async {
    final url = Uri.parse('$baseUrl/lembretes');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'titulo': titulo,
        'descricao': descricao,
        'dataHora': dataHora,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao criar lembrete: ${response.body}');
    }
  }
}

class CreateReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novo Lembrete',
      home: CreateReminderScreen(),
    );
  }
}

class CreateReminderScreen extends StatefulWidget {
  @override
  _CreateReminderState createState() => _CreateReminderState();
}

class _CreateReminderState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _descricao = '';
  DateTime _dataLimite = DateTime.now();
  TimeOfDay _horaLimite = TimeOfDay.now();
  final String _userId = 'BWOXEy1N5nnn886D8ziv'; // ID do usuário

  Future<void> _saveReminder() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final dataHora = DateTime(
        _dataLimite.year,
        _dataLimite.month,
        _dataLimite.day,
        _horaLimite.hour,
        _horaLimite.minute,
      );

      // Formatar a data e hora conforme esperado pela API: "dd/MM/yyyy HH:mm"
      final formattedDataHora = DateFormat('dd/MM/yyyy HH:mm').format(dataHora);

      try {
        final response = await ApiService.createReminder(
          userId: _userId,
          titulo: _titulo,
          descricao: _descricao,
          dataHora: formattedDataHora,
        );
        print('Lembrete salvo com sucesso: ${response['id']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lembrete criado com sucesso!')),
        );
      } catch (e) {
        print('Erro ao salvar lembrete: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar lembrete!')),
        );
      }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Novo Lembrete', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color.fromARGB(40, 0, 0, 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Título',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _titulo = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color.fromARGB(40, 0, 0, 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Descrição',
                    ),
                    maxLines: 5,
                    onSaved: (value) {
                      _descricao = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton.icon(
                onPressed: _selectDateTime,
                icon: Icon(Icons.calendar_today),
                label: Text(
                    '${_dataLimite.day}/${_dataLimite.month}/${_dataLimite.year} ${_horaLimite.format(context)}'),
              ),
              SizedBox(height: 16.0),
              SaveTaskButton(
                onPressed: _saveReminder,
              )
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
        onPressed: onPressed,
        child: const Text(
          'Salvar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

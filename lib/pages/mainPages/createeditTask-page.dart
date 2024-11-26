import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Importar para formatação de datas

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Criar tarefa
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

  // Atualizar tarefa
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

  // Obter detalhes da tarefa
  static Future<Map<String, dynamic>> getTaskDetails(String taskId) async {
    final url = Uri.parse('$baseUrl/tarefas/$taskId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao obter detalhes da tarefa: ${response.body}');
    }
  }
}

class CreateEditTask extends StatelessWidget {
  final String? taskId;

  const CreateEditTask({Key? key, this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: taskId == null ? 'Nova Tarefa' : 'Editar Tarefa',
      home: CreateEditTaskScreen(taskId: taskId),
    );
  }
}

class CreateEditTaskScreen extends StatefulWidget {
  final String? taskId;

  const CreateEditTaskScreen({Key? key, this.taskId}) : super(key: key);

  @override
  _CreateEditTaskScreen createState() => _CreateEditTaskScreen();
}

class _CreateEditTaskScreen extends State<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _descricao = '';
  DateTime _dataLimite = DateTime.now();
  TimeOfDay _horaLimite = TimeOfDay.now();
  final String _userId = 'BWOXEy1N5nnn886D8ziv'; // Exemplo de ID do usuário
  String _status = 'Começar';
  String _categoria = 'Pessoal';
  List<String> _categorias = ['Pessoal', 'Trabalho', 'Estudo'];

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _fetchTaskDetails(widget.taskId!);
    }
  }

  Future<void> _fetchTaskDetails(String taskId) async {
    try {
      final taskDetails = await ApiService.getTaskDetails(taskId);
      setState(() {
        _titulo = taskDetails['titulo'];
        _descricao = taskDetails['descricao'];
        final horario = DateTime.parse(taskDetails['horario']);
        _dataLimite = DateTime(horario.year, horario.month, horario.day);
        _horaLimite = TimeOfDay(hour: horario.hour, minute: horario.minute);
        _status = taskDetails['status'];
        _categoria = taskDetails['categoria'];
      });
    } catch (e) {
      print('Erro ao obter detalhes da tarefa: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter detalhes da tarefa!')),
      );
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Converte a data e hora selecionada para o formato ISO-8601 compatível com a API
      final horario = DateTime(
        _dataLimite.year,
        _dataLimite.month,
        _dataLimite.day,
        _horaLimite.hour,
        _horaLimite.minute,
      );

      final formattedHorario =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(horario);

      try {
        if (widget.taskId == null) {
          // Criar nova tarefa
          final response = await ApiService.createTask(
            userId: _userId,
            titulo: _titulo,
            descricao: _descricao,
            horario: formattedHorario,
            status: _status,
            categoria: _categoria,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Tarefa criada com sucesso! ID: ${response['id']}')),
          );
        } else {
          // Editar tarefa existente
          await ApiService.updateTask(
            taskId: widget.taskId!,
            titulo: _titulo,
            descricao: _descricao,
            horario: formattedHorario,
            status: _status,
            categoria: _categoria,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tarefa atualizada com sucesso!')),
          );
        }
        Navigator.pop(context); // Volta para a tela anterior
      } catch (e) {
        print('Erro ao salvar tarefa: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar tarefa! Tente novamente.')),
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
      appBar: AppBar(
        title: Text(widget.taskId == null ? 'Nova Tarefa' : 'Editar Tarefa'),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                initialValue: _titulo,
                decoration: InputDecoration(labelText: 'Título'),
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
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _descricao,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 5,
                onSaved: (value) {
                  _descricao = value!;
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
                items: ['Começar', 'Andamento', 'Concluída']
                    .map((String status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: InputDecoration(labelText: 'Categoria'),
                items: _categorias
                    .map((String categoria) => DropdownMenuItem<String>(
                          value: categoria,
                          child: Text(categoria),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _categoria = newValue!;
                  });
                },
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
        onPressed: onPressed,
        child: const Text(
          'Salvar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

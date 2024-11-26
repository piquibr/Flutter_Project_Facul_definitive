import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Importar para formatação de datas

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

  @override
  void initState() {
    super.initState();
    _userId = widget.userId; // Inicializa o userId a partir do widget recebido
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
        userId: _userId,
        titulo: _titulo,
        descricao: _descricao,
        horario: formattedHorario,
        status: _status,
        categoria: _categoria,
      );
      print('Tarefa salva com sucesso');

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
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
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
        onPressed: onPressed,
        child: const Text(
          'Salvar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
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

class EditTask extends StatelessWidget {
  final Map<String, dynamic>? task; // Adicionado para receber a tarefa
  final String userId;

  const EditTask({Key? key, this.task, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: task == task.toString() ? 'Nova Tarefa' : 'Editar Tarefa',
      home: CreateEditTaskScreen(task: task, userId: userId),
    );
  }
}

class CreateEditTaskScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic>? task; // Tarefa opcional

  const CreateEditTaskScreen({Key? key, required this.userId, this.task}) : super(key: key);

  @override
  _CreateEditTaskScreenState createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
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
    _initializeTaskData();
  }

  void _initializeTaskData() {
  if (widget.task != null) {
    _titulo = widget.task!['titulo'] ?? '';
    _descricao = widget.task!['descricao'] ?? '';

    // Validação do campo 'categoria'
    _categoria = _categorias.contains(widget.task!['categoria'])
        ? widget.task!['categoria']
        : _categorias.first; // Define um valor padrão se inválido

    // Outros campos
    _status = ['Começar', 'Andamento', 'Concluída'].contains(widget.task!['status'])
        ? widget.task!['status']
        : 'Começar';
    _dataLimite = widget.task!['horario'] != null
        ? parseDate(widget.task!['horario'])
        : DateTime.now();
    _horaLimite = TimeOfDay.fromDateTime(_dataLimite);
  } else {
    _titulo = '';
    _descricao = '';
    _status = 'Começar'; // Valor padrão
    _categoria = _categorias.first; // Primeiro valor como padrão
    _dataLimite = DateTime.now();
    _horaLimite = TimeOfDay.now();
  }

    // Debug prints para verificar os dados recebidos
    print('User ID recebido: ${widget.userId}');
    print('Tarefa recebida: ${widget.task}');
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
        print('Nova tarefa criada com sucesso');
      } else {
        await ApiService.updateTask(
          taskId: widget.task!['id'],
          titulo: _titulo,
          descricao: _descricao,
          horario: formattedHorario,
          status: _status,
          categoria: _categoria,
        );
        print('Tarefa atualizada com sucesso');
      }

      Navigator.pop(context, true); // Retorna um indicador de sucesso
    } catch (e) {
      print('Erro ao salvar tarefa: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar tarefa! Tente novamente.')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
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
              DropdownButtonFormField<String>(
                value: _status.isNotEmpty && ['Começar', 'Andamento', 'Concluída'].contains(_status)
                    ? _status
                    : 'Começar', // Define um valor padrão válido
                decoration: InputDecoration(labelText: 'Status'),
                items: ['Começar', 'Andamento', 'Concluída']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoria.isNotEmpty && _categorias.contains(_categoria)
                    ? _categoria
                    : _categorias.first, // Define o primeiro valor como padrão
                decoration: InputDecoration(labelText: 'Categoria'),
                items: _categorias
                    .map((categoria) => DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoria = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          'horario': horario, // Alterado de dataHora para horario
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

class CreateReminder extends StatelessWidget {
  final String userId; // Recebe o userId como argumento
  const CreateReminder({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novo Lembrete',
      home: CreateReminderScreen(userId: userId),
    );
  }
}

class CreateReminderScreen extends StatefulWidget {
  final String userId; // Recebe o userId como argumento
  const CreateReminderScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _CreateReminderState createState() => _CreateReminderState();
}

class _CreateReminderState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _descricao = '';
  DateTime _dataLimite = DateTime.now();
  TimeOfDay _horaLimite = TimeOfDay.now();
  late String _userId; // Para armazenar o userId localmente

  @override
  void initState() {
    super.initState();
    _userId = widget.userId; // Inicializa o userId a partir do widget recebido
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

      // Exibe indicador de carregamento

      /** 
      
            showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      */

      try {
        await ApiService.createReminder(
          userId: widget.userId,
          titulo: _titulo,
          descricao: _descricao,
          horario: formattedHorario,
        );
        print('Lembrete salvo com sucesso');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lembrete criado com sucesso!')),
      );

      Navigator.pop(context, true); // Retorna um indicador de sucesso
    } catch (e) {
      print('Erro ao salvar Lembrete: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar Lembrete!')),
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
        title: Text('Novo Lembrete'),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Volta à tela anterior
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
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
              SizedBox(height: 16.0),
              _buildTextField(
                hint: 'Descrição',
                onSaved: (value) => _descricao = value!,
                maxLines: 5,
              ),
              SizedBox(height: 16.0),
              TextButton.icon(
                onPressed: _selectDateTime,
                icon: Icon(Icons.calendar_today),
                label: Text(
                    '${_dataLimite.day}/${_dataLimite.month}/${_dataLimite.year} ${_horaLimite.format(context)}'),
              ),
              SizedBox(height: 16.0),
              SaveReminderButton(
                onPressed: _saveReminder,
              )
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
        border: Border.all(color: Colors.grey),
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

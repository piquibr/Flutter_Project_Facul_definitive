import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      _categoria = _categorias.contains(widget.task!['categoria']) ? widget.task!['categoria'] : _categorias.first;
      _status = ['Começar', 'Andamento', 'Concluída'].contains(widget.task!['status']) ? widget.task!['status'] : 'Começar';
      _dataLimite = widget.task!['horario'] != null ? DateFormat("dd/MM/yyyy HH:mm").parse(widget.task!['horario']) : DateTime.now();
      _horaLimite = TimeOfDay.fromDateTime(_dataLimite);
    } else {
      _titulo = '';
      _descricao = '';
      _status = 'Começar';
      _categoria = _categorias.first;
      _dataLimite = DateTime.now();
      _horaLimite = TimeOfDay.now();
    }

    print('User ID recebido: ${widget.userId}');
    print('Tarefa recebida: ${widget.task}');
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
          print('Nova tarefa criada com sucesso');
        } else {
          print('Tarefa atualizada com sucesso');
        }

        Navigator.pop(context, true); // Retorna um indicador de sucesso
      } catch (e) {
        print('Erro ao salvar tarefa: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar tarefa! Tente novamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ajusta a interface ao teclado
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _titulo,
                  decoration: const InputDecoration(labelText: 'Título'),
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
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _descricao,
                  decoration: const InputDecoration(labelText: 'Descrição'),
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
                TextButton.icon(
                  onPressed: _selectDateTime,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    '${_dataLimite.day}/${_dataLimite.month}/${_dataLimite.year} ${_horaLimite.format(context)}',
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
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _categoria,
                  decoration: const InputDecoration(labelText: 'Categoria'),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveTask,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

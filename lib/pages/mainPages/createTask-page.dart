import 'package:flutter/material.dart';

class Createtask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova Tarefa',
      home: CreatetaskScreen(),
    );
  }
}

class CreatetaskScreen extends StatefulWidget {
  @override
  _CreatetaskState createState() => _CreatetaskState();
}

class _CreatetaskState extends State<CreatetaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _descricao = '';
  String _categoria = '';
  DateTime _dataLimite = DateTime.now();
  TimeOfDay _horaLimite = TimeOfDay.now();
  bool _concluida = false;
  final ValueNotifier<String> _selectedStatus = ValueNotifier<String>('Começar');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Tarefa'),
        backgroundColor: const Color.fromARGB(255, 255, 145, 0),
      ),
      resizeToAvoidBottomInset: true, // Permite que o layout se ajuste ao teclado
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
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
              AdicionarCategoriaButton(),

              SizedBox(height: 16.0),
              TempoLimiteButton(),

              SizedBox(height: 16.0),
              StatusSelector(selectedStatus: _selectedStatus),
              
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print('Título: $_titulo');
                    print('Descrição: $_descricao');
                    print('Categoria: $_categoria');
                    print('Status: ${_selectedStatus.value}');
                    print('Data Limite: $_dataLimite');
                    print('Hora Limite: $_horaLimite');
                    print('Concluída: $_concluida');
                    // Adicione a lógica para salvar a tarefa aqui
                  }
                },
                child: Text('Salvar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdicionarCategoriaButton extends StatelessWidget {
  const AdicionarCategoriaButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Botão Adicionar Categoria pressionado!');
      },
      child: Row(
        children: [
          Icon(Icons.add),
          SizedBox(width: 8),
          Text('Adicionar categoria'),
        ],
      ),
    );
  }
}

class StatusSelector extends StatelessWidget {
  final ValueNotifier<String> selectedStatus;

  const StatusSelector({Key? key, required this.selectedStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ValueListenableBuilder<String>(
          valueListenable: selectedStatus,
          builder: (context, value, child) {
            return SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'Começar',
                  label: Text('Começar'),
                ),
                ButtonSegment<String>(
                  value: 'Andamento',
                  label: Text('Andamento'),
                ),
                ButtonSegment<String>(
                  value: 'Concluído',
                  label: Text('Concluído'),
                ),
              ],
              selected: {value},
              onSelectionChanged: (Set<String> newSelection) {
                selectedStatus.value = newSelection.first;
              },
            );
          },
        ),
      ],
    );
  }
}


class TempoLimiteButton extends StatelessWidget {
  const TempoLimiteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today),
              const SizedBox(width: 8.0),
              Text('dd/mm/aa'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.access_time),
              const SizedBox(width: 8.0),
              Text('00:00'),
            ],
          ),
        ],
      ),
    );
  }
}
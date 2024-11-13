import 'package:flutter/material.dart';

class CreateReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova Tarefa',
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
  String _categoria = '';
  DateTime _dataLimite = DateTime.now();
  TimeOfDay _horaLimite = TimeOfDay.now();
  bool _concluida = false;
  final ValueNotifier<String> _selectedStatus = ValueNotifier<String>('Começar');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Cor de fundo do Scaffold
      appBar: AppBar(
        title: Text('Novo Lembrete', style: TextStyle(color: Colors.white)), // Título em branco
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        iconTheme: IconThemeData(color: Colors.white), // Ícone de voltar em branco
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
                  color: const Color.fromARGB(40, 0, 0, 0), // Fundo cinza claro
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
                  color: const Color.fromARGB(40, 0, 0, 0), // Fundo cinza claro
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
              TempoLimiteButton(),
              SizedBox(height: 16.0),
              SaveTaskButton(
                onPressed: () {
                  // Ação ao pressionar o botão, por exemplo, salvar uma tarefa
                },
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
          backgroundColor: const Color.fromARGB(255, 255, 102, 14), // Cor do botão
        ),
        onPressed: onPressed,
        child: const Text('Salvar',
        style: TextStyle(color: Colors.white),
        ),
      ),
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
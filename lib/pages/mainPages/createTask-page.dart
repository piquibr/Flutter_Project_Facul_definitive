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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Tarefa'),
        backgroundColor: const Color.fromARGB(255, 255, 145, 0),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              CheckboxListTile(
                title: Text('Concluída'),
                value: _concluida,
                onChanged: (bool? value) {
                  setState(() {
                    _concluida = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Aqui você pode adicionar a lógica para salvar a tarefa
                    // Exemplo: enviar os dados para um banco de dados
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
        // Implemente a ação ao clicar no botão
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
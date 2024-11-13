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
      backgroundColor: Colors.white, // Cor de fundo do Scaffold
      appBar: AppBar(
        title: Text('Nova Tarefa', style: TextStyle(color: Colors.white)), // Título em branco
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
              AdicionarCategoriaButton(),
              SizedBox(height: 16.0),
              TempoLimiteButton(),
              SizedBox(height: 16.0),
              StatusSelector(selectedStatus: _selectedStatus),
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



class AdicionarCategoriaButton extends StatelessWidget {
  const AdicionarCategoriaButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Cor de fundo branca
      ),
      onPressed: () {
        print('Botão Adicionar Categoria pressionado!');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ajusta o tamanho do botão ao conteúdo
        children: [
          const Icon(Icons.add, color: Colors.black),
          const SizedBox(width: 8),
          const Text(
            'Adicionar categoria',
            style: TextStyle(color: Colors.black), // Cor do texto em preto
          ),
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
            return SizedBox(
              width: 400, // Largura fixa para manter o tamanho dos botões
              child: SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(
                    value: 'Começar',
                    label: Text(
                      'Começar',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  ButtonSegment<String>(
                    value: 'Andamento',
                    label: Text(
                      'Andamento',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  ButtonSegment<String>(
                    value: 'Concluído',
                    label: Text(
                      'Concluído',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
                selected: {value},
                onSelectionChanged: (Set<String> newSelection) {
                  selectedStatus.value = newSelection.first;
                },
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/login-page.dart';

class InicialMain extends StatelessWidget {
  static String tag = 'inicialMain_page';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: InicialMainPage(),
    );
  }
}

class InicialMainPage extends StatefulWidget {
  @override
  _InicialMainPageState createState() => _InicialMainPageState();
}

class _InicialMainPageState extends State<InicialMainPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedType;
  String? selectedCategory;

    Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: Icon(Icons.density_medium_sharp, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_high),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(10, 255, 101, 14),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),

            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.filter_alt, color: Colors.orange),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Filtrar Notas'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                  'Data Início: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'Selecionar'}'),
                              trailing: Icon(Icons.calendar_today),
                              onTap: () => _selectDate(context, true),
                            ),
                            ListTile(
                              title: Text(
                                  'Data Fim: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'Selecionar'}'),
                              trailing: Icon(Icons.calendar_today),
                              onTap: () => _selectDate(context, false),
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: 'Tipo'),
                              value: selectedType,
                              items: ['Lembrete', 'Tarefa'].map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedType = newValue;
                                });
                              },
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: 'Categoria'),
                              value: selectedCategory,
                              items: ['Trabalho', 'Estudo', 'Pessoal'].map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCategory = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Aplicar'),
                            onPressed: () {
                              // Lógica para aplicar filtros
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),


            SizedBox(height: 12.0),
            Expanded(
              child: ListView(
                children: [
                  LembreteItem(
                    title: 'Lembrete',
                    description: 'Supporting line text lorem ipsum dolor sit amet, consectetur.',
                    date: 'dd/mm/aa',
                    time: '00:00',
                    status: 'Em andamento',
                  ),
                  TarefaItem(
                    title: 'Título tarefa',
                    description: 'Descrição',
                    date: 'dd/mm/aa',
                    time: '00:00',
                    status: 'Concluído',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.note_add),
                      title: Text('Criar Lembretes'),
                      onTap: () {
                        Navigator.pop(context);
                        // Lógica para criar lembrete
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.task_alt),
                      title: Text('Criar Tarefas'),
                      onTap: () {
                        Navigator.pop(context);
                        // Lógica para criar tarefa
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      
    );
  }
}

class LembreteItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final String status;

  LembreteItem({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> selectedStatus = ValueNotifier(status);

    return Card(
      color: const Color.fromARGB(10, 255, 101, 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '$date - $time',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(color: Colors.white),
            ),

            SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') {
                    // Ação de edição
                  } else if (value == 'delete') {
                    // Ação de exclusão
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Editar'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Deletar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe TarefaItem é semelhante a LembreteItem
// Suas propriedades e widgets podem ser mantidos sem alterações
class TarefaItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final String status;

  TarefaItem({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> selectedStatus = ValueNotifier(status);

    return Card(
      color: const Color.fromARGB(10, 255, 101, 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '$date - $time',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(color: Colors.white),
            ),



            SizedBox(height: 8),
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
            SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Selecionar Categoria'),
                        content: Text('Aqui você pode escolher uma categoria.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Selecionar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Categoria'),
              ),
            ),

            SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') {
                    // Ação de edição
                  } else if (value == 'delete') {
                    // Ação de exclusão
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Editar'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Deletar'),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
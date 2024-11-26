import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/config-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/createReminder-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/createTask-page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InicialMain extends StatelessWidget {
  static String tag = 'inicialMain_page';
  final String userId;
  const InicialMain({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: InicialMainPage(userId: userId),
    );
  }
}

class InicialMainPage extends StatefulWidget {
  final String userId;
  const InicialMainPage({required this.userId});

  @override
  _InicialMainPageState createState() => _InicialMainPageState();
}

class _InicialMainPageState extends State<InicialMainPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedType;
  String? selectedCategory;
  String? searchText;
  List reminders = [];
  List tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      print('Buscando lembretes para userId: ${widget.userId}');
      // Buscar lembretes
      final remindersResponse = await http.get(
        Uri.parse('http://192.168.56.1:8080/api/lembretes/${widget.userId}'),
      );

      if (remindersResponse.statusCode == 200) {
        setState(() {
          reminders = jsonDecode(remindersResponse.body);
        });
        print('Lembretes buscados com sucesso: $reminders');
      } else {
        print(
            'Falha ao buscar lembretes. Código: ${remindersResponse.statusCode}');
      }

      print('Buscando tarefas para userId: ${widget.userId}');
      // Buscar tarefas
      final tasksResponse = await http.get(
        Uri.parse('http://192.168.56.1:8080/api/tarefas/${widget.userId}'),
      );

      if (tasksResponse.statusCode == 200) {
        setState(() {
          tasks = jsonDecode(tasksResponse.body);
        });
        print('Tarefas buscadas com sucesso: $tasks');
      } else {
        print('Falha ao buscar tarefas. Código: ${tasksResponse.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar dados: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      print('Deletando lembrete com ID: $reminderId');
      final userId = widget.userId;
      final response = await http.delete(Uri.parse(
          'http://192.168.56.1:8080/api/lembretes/$userId/$reminderId'));
      if (response.statusCode == 200) {
        setState(() {
          reminders.removeWhere((reminder) => reminder['id'] == reminderId);
        });
        print('Lembrete deletado com sucesso');
      } else {
        print('Falha ao deletar lembrete. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao deletar lembrete: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      print('Deletando tarefa com ID: $taskId');
      final response = await http.delete(
        Uri.parse('http://192.168.56.1:8080/api/tarefas/$taskId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          tasks.removeWhere((task) => task['id'] == taskId);
        });
        print('Tarefa deletada com sucesso');
      } else {
        print('Falha ao deletar tarefa. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao deletar tarefa: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void applyFilters() {
    print('Aplicando filtros...');
    // Implementação de filtros, incluindo lembretes e tarefas.
    List filteredReminders = reminders.where((reminder) {
      final matchesStartDate = startDate == null ||
          DateTime.parse(reminder['dataHora']).isAfter(startDate!);
      final matchesEndDate = endDate == null ||
          DateTime.parse(reminder['dataHora']).isBefore(endDate!);
      final matchesSearchText = searchText == null ||
          reminder['titulo'].toLowerCase().contains(searchText!.toLowerCase());

      return matchesStartDate && matchesEndDate && matchesSearchText;
    }).toList();

    List filteredTasks = tasks.where((task) {
      final matchesStartDate = startDate == null ||
          DateTime.parse(task['horario']).isAfter(startDate!);
      final matchesEndDate =
          endDate == null || DateTime.parse(task['horario']).isBefore(endDate!);
      final matchesSearchText = searchText == null ||
          task['titulo'].toLowerCase().contains(searchText!.toLowerCase());

      return matchesStartDate && matchesEndDate && matchesSearchText;
    }).toList();

    setState(() {
      reminders = List.from(filteredReminders);
      tasks = List.from(filteredTasks);
    });
    print('Filtros aplicados. Lembretes: $reminders, Tarefas: $tasks');
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
              MaterialPageRoute(builder: (context) => ConfigScreen()),
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
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
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
                              applyFilters();
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
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: reminders.length + tasks.length,
                      itemBuilder: (context, index) {
                        if (index < reminders.length) {
                          final reminder = reminders[index];
                          return _buildReminderCard(reminder);
                        } else {
                          final task = tasks[index - reminders.length];
                          return _buildTaskCard(task);
                        }
                      },
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateReminderScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.task_alt),
                      title: Text('Criar Tarefas'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatetaskScreen()),
                        );
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

  Widget _buildReminderCard(reminder) {
    return Card(
      color: const Color.fromARGB(230, 255, 235, 224),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Lembretes: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: reminder['titulo'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '${reminder['dataHora']}',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              reminder['descricao'],
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) {
                  if (value == 'edit') {
                    // Ação de edição para lembrete
                  } else if (value == 'delete') {
                    deleteReminder(reminder['id']);
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

  Widget _buildTaskCard(task) {
    return Card(
      color: const Color.fromARGB(230, 249, 142, 84),
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
                  "Tarefas:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    task['titulo'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Text(
                  '${task['horario']}',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              task['descricao'],
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${task['status']}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  'Categoria: ${task['categoria']}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Ação de edição para tarefa
                    } else if (value == 'delete') {
                      deleteTask(task['id']);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

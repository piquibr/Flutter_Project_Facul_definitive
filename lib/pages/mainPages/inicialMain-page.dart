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
  String? searchText;
  List reminders = [];
  List tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchReminders();
    fetchTasks();
  }

  Future<void> fetchReminders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = 'BWOXEy1N5nnn886D8ziv';
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/lembretes/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          reminders = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load reminders');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching reminders: $e');
    }
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = 'BWOXEy1N5nnn886D8ziv';
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/tarefas/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          tasks = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching tasks: $e');
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      final response = await http.delete(Uri.parse(
          'http://localhost:8080/api/lembretes/BWOXEy1N5nnn886D8ziv/$reminderId'));
      if (response.statusCode == 200) {
        setState(() {
          reminders.removeWhere((reminder) => reminder['id'] == reminderId);
        });
      } else {
        throw Exception('Failed to delete reminder');
      }
    } catch (e) {
      print('Error deleting reminder: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await http
          .delete(Uri.parse('http://localhost:8080/api/tarefas/$taskId'));
      if (response.statusCode == 200) {
        setState(() {
          tasks.removeWhere((task) => task['id'] == taskId);
        });
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      print(e);
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
              children: [
                Expanded(
                  child: Text(
                    reminder['titulo'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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
                Expanded(
                  child: Text(
                    task['titulo'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
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

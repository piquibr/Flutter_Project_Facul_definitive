import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/config-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/createReminder-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/createTask-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/editReminder-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/editTask-page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light, // Define o tema inicial como claro
      home: InicialMainPage(userId: userId),
    );
  }
}

class InicialMainPage extends StatefulWidget {
  final String userId;

  const InicialMainPage({required this.userId, Key? key}) : super(key: key);
  @override
  _InicialMainPageState createState() => _InicialMainPageState();
}

class _InicialMainPageState extends State<InicialMainPage> {
  late String userId = widget.userId;

  DateTime? startDate;
  DateTime? endDate;
  String? searchText;
  List reminders = [];
  List filteredRemindersDisplay = [];
  List tasks = [];
  List filteredTasksDisplay = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    fetchReminders();
    fetchTasks();
  }

  Future<void> fetchReminders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/lembretes/$userId'));

      if (response.statusCode == 200) {
        setState(() {
          reminders = json.decode(response.body);
          filteredRemindersDisplay = List.from(reminders);
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
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/tarefas/$userId'));

      if (response.statusCode == 200) {
        setState(() {
          tasks = json.decode(response.body);
          filteredTasksDisplay = List.from(tasks);
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
      final url = Uri.parse('http://10.0.2.2:8080/api/lembretes/$userId/$reminderId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          reminders.removeWhere((reminder) => reminder['id'] == reminderId);
        });
        print('Lembrete excluído com sucesso');
      } else {
        throw Exception('Erro ao excluir lembrete: ${response.body}');
      }
    } catch (e) {
      print('Erro ao excluir lembrete: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/api/tarefas/$userId/$taskId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          tasks.removeWhere((task) => task['id'] == taskId);
        });
        print('Tarefa excluída com sucesso');
      } else {
        throw Exception('Erro ao excluir tarefa: ${response.body}');
      }
    } catch (e) {
      print('Erro ao excluir tarefa: $e');
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
    final List filteredReminders = reminders.where((reminder) {
      final matchesStartDate = startDate == null || DateFormat('dd/MM/yyyy HH:mm').parse(reminder['horario']).isAfter(startDate!) || DateFormat('dd/MM/yyyy HH:mm').parse(reminder['horario']).isAtSameMomentAs(startDate!);
      final matchesEndDate = endDate == null || DateFormat('dd/MM/yyyy HH:mm').parse(reminder['horario']).isBefore(endDate!.add(Duration(days: 1)));
      final matchesSearchText = searchText == null ||
          reminder['titulo'].toLowerCase().contains(searchText!.toLowerCase()) ||
          reminder['descricao'].toLowerCase().contains(searchText!.toLowerCase());

      return matchesStartDate && matchesEndDate && matchesSearchText;
    }).toList();

    final List filteredTasks = tasks.where((task) {
      final matchesStartDate = startDate == null || DateFormat('dd/MM/yyyy HH:mm').parse(task['horario']).isAfter(startDate!) || DateFormat('dd/MM/yyyy HH:mm').parse(task['horario']).isAtSameMomentAs(startDate!);
      final matchesEndDate = endDate == null || DateFormat('dd/MM/yyyy HH:mm').parse(task['horario']).isBefore(endDate!.add(Duration(days: 1)));
      final matchesSearchText = searchText == null ||
          task['titulo'].toLowerCase().contains(searchText!.toLowerCase()) ||
          task['descricao'].toLowerCase().contains(searchText!.toLowerCase());

      return matchesStartDate && matchesEndDate && matchesSearchText;
    }).toList();

    setState(() {
      filteredRemindersDisplay = List.from(filteredReminders);
      filteredTasksDisplay = List.from(filteredTasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: const Icon(Icons.density_medium_sharp, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfigScreen(userId: userId)),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_high),
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
                color: const Color.fromARGB(10, 255, 101, 14),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                    applyFilters();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_alt, color: Colors.orange),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Filtrar Notas'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(
                                    'Data Início: ${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'Selecionar'}'),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(context, true),
                              ),
                              ListTile(
                                title: Text(
                                    'Data Fim: ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : 'Selecionar'}'),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(context, false),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Aplicar'),
                              onPressed: () {
                                applyFilters();
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Limpar Config. Filtro'),
                              onPressed: () {
                                setState(() {
                                  startDate = null;
                                  endDate = null;
                                  searchText = null;
                                  filteredRemindersDisplay = List.from(reminders);
                                  filteredTasksDisplay = List.from(tasks);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredRemindersDisplay.length + filteredTasksDisplay.length,
                      itemBuilder: (context, index) {
                        if (index < filteredRemindersDisplay.length) {
                          final reminder = filteredRemindersDisplay[index];
                          return _buildReminderCard(reminder);
                        } else {
                          final task = filteredTasksDisplay[index - filteredRemindersDisplay.length];
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
                      leading: const Icon(Icons.note_add),
                      title: const Text('Criar Lembretes'),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateReminderScreen(userId: userId),
                          ),
                        );
                        Navigator.pop(context);

                        if (result == true) {
                          fetchReminders();
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.task_alt),
                      title: const Text('Criar Tarefas'),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatetaskScreen(userId: userId),
                          ),
                        );
                        Navigator.pop(context);

                        if (result == true) {
                          fetchTasks();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReminderCard(reminder) {
    return Card(
      color: const Color.fromARGB(230, 255, 212, 189),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  reminder['horario'],
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              reminder['descricao'],
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEditReminderScreen(reminder: reminder, userId: userId),
                        ),
                      );

                      if (updated == true) {
                        fetchReminders();
                      }
                    } else if (value == 'delete') {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirmar Exclusão'),
                            content: const Text('Tem certeza de que deseja excluir este lembrete?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete == true) {
                        try {
                          await deleteReminder(reminder['id'].toString());
                          fetchReminders();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lembrete excluído com sucesso!')),
                          );
                        } catch (e) {
                          print('Erro ao excluir Lembrete: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erro ao excluir o lembrete!')),
                          );
                        }
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) => [
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  task['horario'],
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              task['descricao'],
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${task['status']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'Categoria: ${task['categoria']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEditTaskScreen(
                            userId: userId,
                            task: task,
                          ),
                        ),
                      );

                      if (updated == true) {
                        fetchTasks();
                      }
                    } else if (value == 'delete') {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirmar Exclusão'),
                            content: const Text('Tem certeza de que deseja excluir esta tarefa?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete == true) {
                        try {
                          await deleteTask(task['id'].toString());
                          fetchTasks();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tarefa excluída com sucesso!')),
                          );
                        } catch (e) {
                          print('Erro ao excluir tarefa: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erro ao excluir a tarefa!')),
                          );
                        }
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) => [
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
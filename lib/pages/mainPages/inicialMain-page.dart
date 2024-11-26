import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/config-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/createReminder-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/createTask-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/editTask-page.dart';
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

  const InicialMainPage({required this.userId, Key? key}) : super(key: key);
  @override
  _InicialMainPageState createState() => _InicialMainPageState();
}

class _InicialMainPageState extends State<InicialMainPage> {
  late String userId = widget.userId
      .toString(); // Agora será inicializado com o valor passado pelo widget

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
    userId =
        widget.userId.toString(); // Inicializa o userId com o valor recebido
    fetchReminders();
    fetchTasks();
  }

  Future<void> fetchReminders() async {
    setState(() {
      isLoading = true;
    });

    print("Fetching reminders for userId: $userId"); // Adicionado debug
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/api/lembretes/$userId'));
      print(
          "Response status for reminders: ${response.statusCode}"); // Status do HTTP
      print(
          "Response body for reminders: ${response.body}"); // Corpo da resposta

      if (response.statusCode == 200) {
        setState(() {
          reminders = json.decode(response.body);
          isLoading = false;
        });
        print(
            "Reminders loaded successfully: $reminders"); // Confirmação do carregamento
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
      print('Error fetching reminders: $e'); // Exibe erros
    }
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    print("Fetching tasks for userId: $userId"); // Debug
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/api/tarefas/$userId'));
      print(
          "Response status for tasks: ${response.statusCode}"); // Debug do status
      print("Response body for tasks: ${response.body}"); // Debug do corpo

      if (response.statusCode == 200) {
        setState(() {
          tasks = json.decode(response.body);
          isLoading = false;
        });
        print("Tasks loaded successfully: $tasks"); // Confirmação de sucesso
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
      print('Error fetching tasks: $e'); // Debug de erros
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      final response = await http.delete(
          Uri.parse('http://10.0.2.2:8080/api/lembretes/$userId/$reminderId'));
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
      final response = await http.delete(
          Uri.parse('http://10.0.2.2:8080/api/tarefas/$userId/$taskId'));
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

  Future<void> _navigateToEditTask(Map<String, dynamic> task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditTaskScreen(
          userId: userId,
          task: task,
        ),
      ),
    );

    if (result == true) {
      // Recarregar os dados
      fetchTasks();
    }
  }

  Future<void> _navigateToCreateTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Createtask(userId: userId), // Passe o userId
      ),
    );

    if (result == true) {
      // Recarregar as tarefas após criar uma nova
      fetchTasks();
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
                            builder: (context) => CreateReminderScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.task_alt),
                      title: Text('Criar Tarefas'),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreatetaskScreen(userId: userId),
                          ),
                        );

                        // Fecha o modal bottom sheet
                        Navigator.pop(context);

                        if (result == true) {
                          // Recarrega a lista de tarefas após criar uma nova
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
                  onSelected: (value) async {
                    if (value == 'edit') {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEditTaskScreen(
                            userId: userId, // Passa o userId
                            task: task, // Passa a tarefa a ser editada
                          ),
                        ),
                      );

                      if (updated == true) {
                        // Recarregar as tarefas após a edição bem-sucedida
                        fetchTasks();
                      }
                    } else if (value == 'delete') {
                      deleteTask(task['id']);
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

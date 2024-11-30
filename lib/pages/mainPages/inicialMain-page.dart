import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/config-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/createReminder-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/createTask-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/editReminder-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/editTask-page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class InicialMain extends StatefulWidget {
  final String userId;

  const InicialMain({required this.userId, Key? key}) : super(key: key);

  @override
  _InicialMainState createState() => _InicialMainState();
}

class _InicialMainState extends State<InicialMain> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode, // Alterna o tema com base no estado
      home: InicialMainPage(
        userId: widget.userId,
        toggleTheme: toggleTheme, // Passa a função de alternância para a página
      ),
    );
  }
}

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? containerBackgroundColor;
  final Color? inputFillColor;
  final Color? floatingActionButtonColor;
  final Color? cardBackgroundColor;
  final Color? cardBackgroundTaskColor;

  const CustomColors({
    this.containerBackgroundColor,
    this.inputFillColor,
    this.floatingActionButtonColor,
    this.cardBackgroundColor,
    this.cardBackgroundTaskColor,
  });

  @override
  CustomColors copyWith({
    Color? containerBackgroundColor,
    Color? inputFillColor,
    Color? floatingActionButtonColor,
    Color? cardBackgroundColor,
    Color? cardBackgroundTaskColor,
  }) {
    return CustomColors(
      containerBackgroundColor:
          containerBackgroundColor ?? this.containerBackgroundColor,
      inputFillColor: inputFillColor ?? this.inputFillColor,
      floatingActionButtonColor:
          floatingActionButtonColor ?? this.floatingActionButtonColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      cardBackgroundTaskColor:
          cardBackgroundTaskColor ?? this.cardBackgroundTaskColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      containerBackgroundColor: Color.lerp(
          containerBackgroundColor, other.containerBackgroundColor, t),
      inputFillColor: Color.lerp(inputFillColor, other.inputFillColor, t),
      floatingActionButtonColor: Color.lerp(
          floatingActionButtonColor, other.floatingActionButtonColor, t),
      cardBackgroundColor:
          Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t),
      cardBackgroundTaskColor:
          Color.lerp(cardBackgroundTaskColor, other.cardBackgroundTaskColor, t),
    );
  }
}

class CustomButtonStyles extends ThemeExtension<CustomButtonStyles> {
  final ButtonStyle? dialogButtonStyle;

  const CustomButtonStyles({this.dialogButtonStyle});

  @override
  CustomButtonStyles copyWith({ButtonStyle? dialogButtonStyle}) {
    return CustomButtonStyles(
      dialogButtonStyle: dialogButtonStyle ?? this.dialogButtonStyle,
    );
  }

  @override
  CustomButtonStyles lerp(ThemeExtension<CustomButtonStyles>? other, double t) {
    if (other is! CustomButtonStyles) return this;
    return CustomButtonStyles(
      dialogButtonStyle:
          ButtonStyle.lerp(dialogButtonStyle, other.dialogButtonStyle, t),
    );
  }
}

class AppTheme {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 255, 102, 14),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black, // Cor padrão dos ícones no tema claro
      size: 24.0,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 245, 245, 245), // Fundo do diálogo
      titleTextStyle: TextStyle(
        color: Colors.black, // Cor do título no tema claro
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black, // Cor do conteúdo no tema claro
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 255, 102, 14), // Cor do botão salvar
        foregroundColor: Colors.white, // Cor do texto no botão salvar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black, // Letra preta no botão "Selecionar Data"
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        containerBackgroundColor: const Color.fromARGB(10, 255, 101, 14),
        inputFillColor:
            const Color.fromARGB(9, 255, 245, 239), // Cor do campo de entrada
        floatingActionButtonColor: const Color.fromARGB(255, 255, 102, 14), // Cor do FAB no tema claro
        cardBackgroundColor: const Color.fromARGB(230, 255, 212, 189), // Cor do Card no tema claro
        cardBackgroundTaskColor: const Color.fromARGB(255, 222, 171, 142), // Cor do TaskCard no tema claro
      ),
      CustomButtonStyles(
        dialogButtonStyle: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 102, 14),
          foregroundColor: Colors.white, // Cor do texto
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    ],
  );

  static final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromARGB(255, 59, 58, 58),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 33, 33, 33),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white, // Cor padrão dos ícones no tema escuro
      size: 24.0,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 48, 48, 48), // Fundo do diálogo
      titleTextStyle: TextStyle(
        color: Colors.white, // Cor do título no tema escuro
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white, // Cor do conteúdo no tema escuro
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 255, 102, 14), // Cor do botão salvar
        foregroundColor: Colors.white, // Cor do texto no botão salvar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // Letra branca no tema escuro
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        containerBackgroundColor: const Color.fromARGB(255, 255, 4, 4),
        inputFillColor:
            const Color.fromARGB(255, 223, 223, 223), // Cor do campo de entrada
        floatingActionButtonColor: const Color.fromARGB(
            255, 255, 102, 14), // Cor do FAB no tema escuro
        cardBackgroundColor: const Color.fromARGB(255, 95, 92, 90), // Cor do Card no tema escuro
        cardBackgroundTaskColor: const Color.fromARGB(255, 43, 42, 42), // Cor do TaskCard no tema escuro
      ),
      CustomButtonStyles(
        dialogButtonStyle: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 102, 14),
          foregroundColor: Colors.white, // Cor do texto
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    ],
  );
}

class InicialMainPage extends StatefulWidget {
  final String userId;
  final VoidCallback toggleTheme;

  const InicialMainPage({
    required this.userId,
    required this.toggleTheme,
    Key? key,
  }) : super(key: key);

  @override
  _InicialMainPageState createState() => _InicialMainPageState();
}

class _InicialMainPageState extends State<InicialMainPage> {
  late String userId = widget.userId;
  bool isLoading = false;

  DateTime? startDate;
  DateTime? endDate;
  String? searchText;
  List reminders = [];
  List filteredRemindersDisplay = [];
  List tasks = [];
  List filteredTasksDisplay = [];

  @override
  void initState() {
    super.initState();
    fetchReminders();
    fetchTasks();
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      final url =
          Uri.parse('http://10.0.2.2:8080/api/lembretes/$userId/$reminderId');
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
      final url =
          Uri.parse('http://10.0.2.2:8080/api/tarefas/$userId/$taskId');
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

  Future<void> fetchReminders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/api/lembretes/$userId'));

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
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/api/tarefas/$userId'));

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
      final matchesStartDate = startDate == null ||
          DateFormat('dd/MM/yyyy HH:mm')
              .parse(reminder['horario'])
              .isAfter(startDate!) ||
          DateFormat('dd/MM/yyyy HH:mm')
              .parse(reminder['horario'])
              .isAtSameMomentAs(startDate!);
      final matchesEndDate = endDate == null ||
          DateFormat('dd/MM/yyyy HH:mm')
              .parse(reminder['horario'])
              .isBefore(endDate!.add(Duration(days: 1)));
      final matchesSearchText = searchText == null ||
          reminder['titulo']
              .toLowerCase()
              .contains(searchText!.toLowerCase()) ||
          reminder['descricao']
              .toLowerCase()
              .contains(searchText!.toLowerCase());

      return matchesStartDate && matchesEndDate && matchesSearchText;
    }).toList();

    final List filteredTasks = tasks.where((task) {
      final matchesStartDate = startDate == null ||
          DateFormat('dd/MM/yyyy HH:mm')
              .parse(task['horario'])
              .isAfter(startDate!) ||
          DateFormat('dd/MM/yyyy HH:mm')
              .parse(task['horario'])
              .isAtSameMomentAs(startDate!);
      final matchesEndDate = endDate == null ||
          DateFormat('dd/MM/yyyy HH:mm')
              .parse(task['horario'])
              .isBefore(endDate!.add(Duration(days: 1)));
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
        title: const Text('Notas'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.density_medium_sharp),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConfigScreen(userId: userId)),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: widget.toggleTheme, // Alterna o tema
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .extension<CustomColors>()
                    ?.containerBackgroundColor,
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
                  fillColor: Theme.of(context)
                      .extension<CustomColors>()
                      ?.inputFillColor, // Cor do campo de entrada
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
                                  filteredRemindersDisplay =
                                      List.from(reminders);
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
                      itemCount: filteredRemindersDisplay.length +
                          filteredTasksDisplay.length,
                      itemBuilder: (context, index) {
                        if (index < filteredRemindersDisplay.length) {
                          final reminder = filteredRemindersDisplay[index];
                          return _buildReminderCard(reminder);
                        } else {
                          final task = filteredTasksDisplay[
                              index - filteredRemindersDisplay.length];
                          return _buildTaskCard(task);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context)
            .extension<CustomColors>()
            ?.floatingActionButtonColor,
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
                            builder: (context) =>
                                CreateReminderScreen(userId: userId),
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
                            builder: (context) =>
                                CreatetaskScreen(userId: userId),
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
      color: Theme.of(context).extension<CustomColors>()?.cardBackgroundColor,
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  reminder['horario'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              reminder['descricao'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEditReminderScreen(
                              reminder: reminder, userId: userId),
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
                            content: const Text(
                                'Tem certeza de que deseja excluir este lembrete?'),
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
                            const SnackBar(
                                content:
                                    Text('Lembrete excluído com sucesso!')),
                          );
                        } catch (e) {
                          print('Erro ao excluir Lembrete: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Erro ao excluir o lembrete!')),
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
      color:
          Theme.of(context).extension<CustomColors>()?.cardBackgroundTaskColor,
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  task['horario'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              task['descricao'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${task['status']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                Text(
                  'Categoria: ${task['categoria']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateEditTaskScreen(userId: userId, task: task),
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
                            content: const Text(
                                'Tem certeza de que deseja excluir esta tarefa?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                style: Theme.of(context)
                                    .extension<CustomButtonStyles>()
                                    ?.dialogButtonStyle,
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: Theme.of(context)
                                    .extension<CustomButtonStyles>()
                                    ?.dialogButtonStyle,
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
                            const SnackBar(
                                content: Text('Tarefa excluída com sucesso!')),
                          );
                        } catch (e) {
                          print('Erro ao excluir tarefa: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Erro ao excluir a tarefa!')),
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

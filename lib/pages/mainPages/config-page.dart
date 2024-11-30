import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/login-page.dart';
import 'package:flutter_project_todo_list/notification.dart';
import 'package:flutter_project_todo_list/pages/mainPages/help-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import 'package:flutter_project_todo_list/pages/recoveryPassword-page.dart';
import 'package:flutter_project_todo_list/pages/updatePassword-page.dart';

class Config extends StatelessWidget {
  final String userId;

  const Config({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigScreen(userId: userId);
  }
}

class ConfigScreen extends StatefulWidget {
  final String userId;

  const ConfigScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  late String _userId;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId; // Inicializa o userId recebido
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    // Aqui você pode adicionar lógica adicional para persistir o estado
    // de modo claro/escuro, como salvar em preferências do usuário.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Retorna à página anterior
          },
        ),
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Alterar senha'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdatePassword(userId: _userId),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            trailing: Switch(
              value: true, // Valor atual da configuração de notificações
              onChanged: (value) {
                // Lógica para ativar/desativar notificações
              },
              activeTrackColor: Colors.orange,
              activeColor: Colors.white,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajuda'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationTestApp(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

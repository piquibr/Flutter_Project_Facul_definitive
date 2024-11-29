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
    return MaterialApp(
      title: 'Configurações',
      home: ConfigScreen(userId: userId),
    );
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

  @override
  void initState() {
    super.initState();
    _userId = widget.userId; // Inicializa o userId recebido
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Retorna à página anterior
          },
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
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
              activeTrackColor: const Color.fromARGB(255, 255, 102, 14),
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
                  builder: (context) => //HelpPage(title: 'Ajuda')
                  NotificationTestApp()
                  ,
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
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: true, // Valor atual do modo claro/escuro
              onChanged: (value) {
                // Lógica para alternar entre modo claro/escuro
              },
              activeTrackColor: const Color.fromARGB(255, 255, 102, 14),
              activeColor: Colors.white,
            ),
            const SizedBox(width: 8.0),
            const Text(
              'Modo Claro',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 102, 14),
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
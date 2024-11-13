import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/login-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/help-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import 'package:flutter_project_todo_list/pages/recoveryPassword-page.dart';
import 'package:flutter_project_todo_list/pages/updatePassword-page.dart';

class Config extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova Tarefa',
      home: ConfigScreen(),
    );
  }
}

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Alterar senha'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificações'),
            trailing: Switch(
              value: true, // Substitua pelo valor atual
              onChanged: (value) {
                // Implemente a lógica para alternar notificações
              },
              activeTrackColor: const Color.fromARGB(255, 255, 102, 14),
              activeColor: Colors.white,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ajuda'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage(title: 'Ajuda')),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: true, // Substitua pelo valor atual
              onChanged: (value) {
                // Implemente a lógica para alternar o modo claro/escuro
              },
              activeTrackColor: const Color.fromARGB(255, 255, 102, 14),
              activeColor: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              'Modo Claro',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 102, 14),
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
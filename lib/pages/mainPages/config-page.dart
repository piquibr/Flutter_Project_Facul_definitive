import 'package:flutter/material.dart';

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
        backgroundColor: Colors.orange,
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
          ),
          Divider(), // Barra de divisão entre os itens
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificações'),
            trailing: Switch(
              value: true, // Substitua pelo valor atual
              onChanged: (value) {
                // Implemente a lógica para alternar notificações
              },
              activeTrackColor: Colors.orange,
              activeColor: Colors.white,
            ),
          ),
          Divider(), // Barra de divisão entre os itens
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ajuda'),
          ),
          Divider(), // Barra de divisão entre os itens
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
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
              activeTrackColor: Colors.orange,
              activeColor: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              'Modo Claro',
              style: TextStyle(
                color: Colors.orange,
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

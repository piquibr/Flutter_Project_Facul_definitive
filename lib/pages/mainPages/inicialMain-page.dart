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
      home: Inicialmain(),
    );
  }
}

class Inicialmain extends StatefulWidget {
  @override
  _InicialMainState createState() => _InicialMainState();
}

class _InicialMainState extends State<Inicialmain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas', style: TextStyle(color: Colors.white)),
        centerTitle: true, // Centraliza o título
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
                color: Color.fromARGB(
                    10, 255, 101, 14), // Cor de fundo especificada
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none, // Remove a borda padrão
                  ),
                  filled: true,
                  fillColor: Colors
                      .transparent, // Mantém a cor de fundo definida pelo Container
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return NoteItem(
                    title: index == 0 ? 'Lembrete' : 'Título tarefa',
                    description: index == 0
                        ? 'Supporting line text lorem ipsum dolor sit amet, consectetur.'
                        : 'Descrição',
                    date: 'dd/mm/aa',
                    time: '00:00',
                    status: index == 0 ? 'Em andamento' : 'Concluído',
                  );
                  
                },

              ),
              
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final String status;

  NoteItem({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(date),
            Text(time),
          ],
          
        ),
        leading: CircleAvatar(
          child: Text(status.substring(0, 1)),
        ),
      ),
    );
  }
}


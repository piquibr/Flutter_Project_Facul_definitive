import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajuda',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HelpPage(title: 'Ajuda'),
    );
  }
}

class HelpPage extends StatefulWidget {
  HelpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
          'Ajuda',
          style: TextStyle(color: Colors.white),
        ),
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.question_mark, color: Colors.grey),
              title: Text('Como funcionam as Tarefas?'),
            ),
            ListTile(
              leading: Icon(Icons.question_mark, color: Colors.grey),
              title: Text('Como funcionam os Lembretes?'),
            ),
            ListTile(
              leading: Icon(Icons.question_mark, color: Colors.grey),
              title: Text('Como funcionam as Notificações?'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sugestões?', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.0),
                  TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Digite sua sugestão...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  
                  

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
                      ),
                      onPressed: () {
                        // Implement your suggestion submission logic here
                      },
                      child: Text(
                        'Enviar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )

                 

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
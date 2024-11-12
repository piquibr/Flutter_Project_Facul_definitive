import 'package:flutter/material.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implement your back button logic here
          },
        ),
        title: Text(widget.title),
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
                  ElevatedButton(
                    onPressed: () {
                        // Implement your suggestion submission logic here
                      },
                    child: Text('Enviar Sugestão'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
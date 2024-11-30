import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final TextEditingController _suggestionController = TextEditingController();
  bool _isLoading = false;

  void _showExplanation(String title, String explanation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(explanation),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendSuggestion() async {
    final suggestion = _suggestionController.text;

    if (suggestion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha sua sugestão.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/api/sendSuggestion"),
        headers: {"Content-Type": "application/json"},
        body: '{"suggestion": "$suggestion"}',
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sugestão enviada com sucesso!")),
        );
        _suggestionController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao enviar sugestão.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro de conexão ao enviar sugestão.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
              onTap: () {
                _showExplanation(
                  'Como funcionam as Tarefas?',
                  'As tarefas permitem que você organize seu trabalho diário. Você pode criar, editar e concluir tarefas, além de categorizá-las.',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.question_mark, color: Colors.grey),
              title: Text('Como funcionam os Lembretes?'),
              onTap: () {
                _showExplanation(
                  'Como funcionam os Lembretes?',
                  'Os lembretes são usados para notificá-lo de algo importante no horário que você configurar.',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.question_mark, color: Colors.grey),
              title: Text('Como funcionam as Notificações?'),
              onTap: () {
                _showExplanation(
                  'Como funcionam as Notificações?',
                  'As notificações aparecem no seu dispositivo para lembrar você de tarefas ou lembretes importantes.',
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sugestões?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _suggestionController,
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
                      onPressed: _isLoading ? null : _sendSuggestion,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Enviar',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
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
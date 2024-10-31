import 'package:flutter/material.dart';
import '../login-page.dart';

class Feedbackregister extends StatelessWidget {
  static String tag = 'feedback_register_page';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FeedbackregisterScreen(),
    );
  }
}

class FeedbackregisterScreen extends StatefulWidget {
  @override
  _FeedbackregisterState createState() => _FeedbackregisterState();
}

class _FeedbackregisterState extends State<FeedbackregisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
      ),
      body: Center( // O SingleChildScrollView não é mais necessário
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100), // Adicionando um espaçamento maior para centralizar melhor
            Icon(
              Icons.perm_identity_outlined,
              size: 100,
            ),
            SizedBox(height: 20), // Adicionando um espaçamento entre o ícone e o texto
            Text(
              'Cadastro realizado com sucesso',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 102, 14),
              ),
            ),
            SizedBox(height: 50), // Adicionando um espaçamento maior para o botão
            _CadastradoButton(), 
          ],
        ),
      ),
    );
  }
}

class _CadastradoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 20),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
      ),
      onPressed: () {
        //TODO: Implementar a lógica de cadastro
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      },
      child: Text(
        'Voltar a tela de login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
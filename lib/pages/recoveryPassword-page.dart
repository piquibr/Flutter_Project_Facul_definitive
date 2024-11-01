import 'package:flutter/material.dart';
import '../login-page.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Recoverypassword extends StatelessWidget {
  static String tag = 'recovery_password_page';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repurerar Senha',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: RecoverypasswordScreen(),
    );
  }
}

class RecoverypasswordScreen extends StatefulWidget {
  @override
  _RecoverypasswordState createState() => _RecoverypasswordState();
}

class _RecoverypasswordState extends State<RecoverypasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Esqueci a Minha Senha',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Icon(
              Icons.lock_open_outlined,
              size: 100,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: AutoSizeText(
                'Insira seu email para confirmação. Você irá receber um código para alteração da senha.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                maxLines: 2, // Limita o número de linhas do texto ),
            ),
            
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: _EmailInput(),
            ),
            SizedBox(height: 50),
            _CadastradoButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Email/Telefone',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira seu email ou telefone';
          }
          return null;
        },
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
        'Confirmar',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
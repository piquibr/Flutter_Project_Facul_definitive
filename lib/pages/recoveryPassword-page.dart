import 'package:flutter/material.dart';
import '../login-page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Recoverypassword extends StatelessWidget {
  static String tag = 'recovery_password_page';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recuperar Senha',
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
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendRecoveryEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu e-mail.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Debug: Imprime o e-mail digitado pelo usuário
      print('DEBUG: Tentando enviar email para: $email');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/sendTemporaryPassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      // Debug: Exibe o status e a resposta do servidor
      print('DEBUG: Resposta da API: ${response.statusCode}');
      print('DEBUG: Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail de recuperação enviado com sucesso!'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erro ao enviar o e-mail: ${errorResponse["error"] ?? "Erro desconhecido"}'),
          ),
        );
        print('DEBUG: Erro ao enviar e-mail: ${errorResponse["error"]}');
      }
    } catch (error) {
      print('DEBUG: Erro ao enviar o e-mail: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao conectar ao servidor.')),
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
      resizeToAvoidBottomInset: true, // Previne overflow ao abrir o teclado
      appBar: AppBar(
        title: const Text(
          'Esqueci a Minha Senha',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Icon(
                Icons.lock_open_outlined,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: AutoSizeText(
                  'Insira seu email para confirmação. Você irá receber uma senha temporária para redefinir sua senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _EmailInput(controller: _emailController),
              ),
              const SizedBox(height: 50),
              _CadastradoButton(
                onPressed: _sendRecoveryEmail,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const _EmailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira seu e-mail.';
          }
          return null;
        },
      ),
    );
  }
}

class _CadastradoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _CadastradoButton({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text(
              'Confirmar',
              style: TextStyle(color: Colors.white),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pages/recoveryPassword-page.dart';

class UpdatePassword extends StatelessWidget {
  static String tag = 'update_password_page';

  final String userId;

  const UpdatePassword({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recuperar Senha',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: UpdatePasswordScreen(userId: userId),
    );
  }
}

class UpdatePasswordScreen extends StatefulWidget {
  final String userId;

  const UpdatePasswordScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _senhaAntigaController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId; // Inicializa o userId recebido
  }

  @override
  void dispose() {
    _senhaAntigaController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _alterarSenha() async {
    final url = Uri.parse("http://10.0.2.2:8080/api/updatePassword");

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": _userId,
          "senhaAtual": _senhaAntigaController.text,
          "novaSenha": _novaSenhaController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Senha alterada com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicialMainPage(userId: _userId),
          ),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: ${errorResponse['error']}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao conectar ao servidor.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InicialMainPage(userId: _userId),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.lock_open, size: 80),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _senhaAntigaController,
                  decoration: const InputDecoration(labelText: 'Senha antiga'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha antiga.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _novaSenhaController,
                  decoration: const InputDecoration(labelText: 'Nova senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua nova senha.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmarSenhaController,
                  decoration:
                      const InputDecoration(labelText: 'Confirmar senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha.';
                    }
                    if (value != _novaSenhaController.text) {
                      return 'As senhas nÃ£o coincidem.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ForgotPasswordButton(userId: _userId),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: const Color.fromARGB(255, 255, 102, 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _alterarSenha();
                    }
                  },
                  child: const Text('Alterar Senha',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  final String userId;

  const ForgotPasswordButton({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recoverypassword(),
          ),
        );
      },
      child: const Text(
        'Esqueceu a sua senha?',
        style: TextStyle(color: Colors.orange),
      ),
    );
  }
}
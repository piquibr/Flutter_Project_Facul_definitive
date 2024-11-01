import 'package:flutter/material.dart';
import '../login-page.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UpdatePassword extends StatelessWidget {
  static String tag = 'update_password_page';
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recuperar Senha',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: UpdatePasswordScreen(),
    );
  }
}

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _senhaAntigaController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _senhaAntigaController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alterar Senha',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
      ),
      body: Padding(
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
                decoration: const InputDecoration(
                  labelText: 'Senha antiga',
                ),
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
                decoration: const InputDecoration(
                  labelText: 'Nova senha',
                ),
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
                decoration: const InputDecoration(
                  labelText: 'Confirmar senha',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha.';
                  }
                  if (value != _novaSenhaController.text) {
                    return 'As senhas não coincidem.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Implementar lógica de alteração de senha
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Senha alterada com sucesso!'),
                      ),
                    );
                  }
                },
                child: const Text('Alterar Senha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

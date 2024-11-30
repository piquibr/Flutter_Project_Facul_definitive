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
    return UpdatePasswordScreen(userId: userId);
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
            builder: (context) => InicialMain(userId: _userId),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
      ),
      backgroundColor:
          theme.scaffoldBackgroundColor, // Altera a cor do fundo dinamicamente
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Icon(Icons.lock_open, size: 80, color: theme.iconTheme.color),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _senhaAntigaController,
                  label: 'Senha antiga',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha antiga.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _novaSenhaController,
                  label: 'Nova senha',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua nova senha.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _confirmarSenhaController,
                  label: 'Confirmar senha',
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
                const SizedBox(height: 16),
                ForgotPasswordButton(userId: _userId),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: theme.elevatedButtonTheme.style,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _alterarSenha();
                    }
                  },
                  child: const Text('Alterar Senha'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelStyle: theme.textTheme.bodyMedium,
      ),
      validator: validator,
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  final String userId;

  const ForgotPasswordButton({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recoverypassword(),
          ),
        );
      },
      style: theme.textButtonTheme.style,
      child: Text(
        'Esqueceu a sua senha?',
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }
}

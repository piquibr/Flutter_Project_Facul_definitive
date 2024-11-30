import 'dart:developer';
import 'package:flutter_project_todo_list/notification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import 'package:flutter_project_todo_list/pages/updatePassword-page.dart';
import 'pages/register-page.dart';
import 'pages/recoveryPassword-page.dart';

class MyHomePage extends StatefulWidget {
  static String tag = 'my_home_page';
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoWidget(),
                const SizedBox(height: 20),
                EmailInput(controller: _emailController),
                const SizedBox(height: 10),
                PasswordInput(controller: _passwordController),
                const SizedBox(height: 20),
                LoginButton(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formKey: _formKey,
                ),
                const SizedBox(height: 20),
                ForgotPasswordButton(),
                const SizedBox(height: 10),
                CreateAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('lib/assets/iconLogin.png', height: 100);
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.black, // Cor do texto inserido
        ),
        cursorColor: Colors.black, // Cor da barra do cursor
        decoration: const InputDecoration(
          labelText: 'Email/Telefone',
          labelStyle: TextStyle(
            color: Colors.black, // Cor do texto da label
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
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

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;

  const PasswordInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        cursorColor: Colors.black, // Cor da barra do cursor
        style: const TextStyle(
          color: Colors.black, // Cor do texto inserido
        ),
        decoration: const InputDecoration(
          labelText: 'Senha',
          labelStyle: TextStyle(
            color: Colors.black, // Cor do texto da label
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira sua senha';
          }
          return null;
        },
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const LoginButton({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  Future<void> _login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final senha = passwordController.text.trim();

    try {
      print('Attempting login with email: $email');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/login'), // Ajuste para o IP correto
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data == null || data['id'] == null) {
          print('Erro: userId não encontrado na resposta da API.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Erro ao obter ID do usuário. Tente novamente.')),
          );
          return;
        }

        final token = data['token']; // Supondo que a API retorna um token
        final userId =
            data['id'].toString(); // Garantindo que o userId é uma String

        print('Login successful. Token: $token, User ID: $userId');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InicialMain(userId: userId)),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Erro desconhecido';
        print('Login failed. Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $error')),
        );
      }
    } catch (e) {
      log("Erro durante o login: $e");
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar à API')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _login(context),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
      ),
      child: const Text('Entrar', style: TextStyle(color: Colors.white)),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Recoverypassword()),
        );
      },
      child: const Text(
        'Esqueceu a sua senha?',
        style: TextStyle(color: Colors.orange),
      ),
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      },
      child: const Text(
        'Crie sua conta aqui!',
        style: TextStyle(color: Colors.orange),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import 'package:flutter_project_todo_list/pages/updatePassword-page.dart';
import 'pages/register-page.dart';
import 'pages/recoveryPassword-page.dart';

class MyHomePage extends StatefulWidget {
  static String tag = 'MyHomePage(title: title)';
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView( // Permite rolar a tela quando o teclado abre
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoWidget(),
                const SizedBox(height: 20),
                EmailInput(),
                const SizedBox(height: 10),
                PasswordInput(),
                const SizedBox(height: 20),
                LoginButton(onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implementar login
                  }
                }),
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
    return Image.asset('./lib/assets/iconLogin.png', height: 100);
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email/Telefone',
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

class PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: 'Senha',
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
  final VoidCallback onPressed;

  const LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //onPressed: onPressed
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InicialMain()),
        );
      },
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
          // context, MaterialPageRoute(builder: (context) => Recoverypassword()));
          MaterialPageRoute(builder: (context) => UpdatePassword()),
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

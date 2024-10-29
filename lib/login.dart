import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoWidget(),
                SizedBox(height: 20),
                EmailInput(),
                SizedBox(height: 10),
                PasswordInput(),
                SizedBox(height: 20),
                LoginButton(onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implementar login
                  }
                }),
                SizedBox(height: 20),
                ForgotPasswordButton(),
                SizedBox(height: 10),
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
        color: Colors.grey[200], // Fundo cinza claro
        borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas (opcional)
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Email/Telefone',
          border: InputBorder.none, // Remove o contorno padrão
          contentPadding: EdgeInsets.symmetric(horizontal: 10), // Padding interno
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Cor de fundo cinza claro
        borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas (opcional)
      ),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Senha',
          suffixIcon: Icon(Icons.visibility_off),
          border: InputBorder.none, // Remove o contorno padrão
          contentPadding: EdgeInsets.symmetric(horizontal: 10), // Padding interno
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

  LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 20),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
      ),
      child: Text('Entrar', style: TextStyle(color: Colors.white)),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
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
      onPressed: () {},
      child: Text(
        'Crie sua conta aqui!',
        style: TextStyle(color: Colors.orange),
      ),
    );
  }
}

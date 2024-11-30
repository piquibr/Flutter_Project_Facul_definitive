import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/pages/feedbackRegister-page.dart';
import '../login-page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/feedbackRegister-page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> _cadastrarUsuario(BuildContext context, String email, String senha,
    String telefone, String nome) async {
  const String apiUrl = "http://10.0.2.2:8080/api/addUser";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "senha": senha,
        "telefone": telefone,
        "nome": nome,
      }),
    );

    if (response.statusCode == 201) {
      // Exibe uma mensagem de sucesso
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Sucesso"),
            content: const Text("Cadastro realizado com sucesso!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Exibe uma mensagem de erro retornada pela API
      final errorResponse = jsonDecode(response.body);
      final errorMessage = errorResponse['error'] ?? "Erro desconhecido";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar: $errorMessage")),
      );
    }
  } catch (error) {
    // Exibe mensagem de erro genérico
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao conectar à API: $error")),
    );
  }
}

class RegisterPage extends StatelessWidget {
  static String tag = 'register_page';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: CadastroScreen(),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  bool _obscureText =
      true; // Defina como `true` para ocultar a senha por padrão

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
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.perm_identity_outlined,
                size: 100,
              ),
              SizedBox(height: 20),

              // _InputTextField(label: 'email', icon: Icons.email),
              _InputTextField(
                label: 'email',
                icon: Icons.email,
                isPassword: false,
                obscureText: false,
                toggleVisibility: null,
                controller: _emailController, // Adicionado
              ),

              SizedBox(height: 10),
              _InputTextField(
                label: 'senha',
                icon: Icons.lock,
                isPassword: true,
                obscureText: _obscureText,
                toggleVisibility: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                controller: _senhaController, // Adicionado
              ),
              SizedBox(height: 10),

              // _InputTextField(label: 'telefone', icon: Icons.phone),
              _InputTextField(
                label: 'telefone',
                icon: Icons.phone,
                isPassword: false,
                obscureText: false,
                toggleVisibility: null,
                controller: _telefoneController, // Adicionado
              ),
              SizedBox(height: 10),

              //_InputTextField(label: 'nome', icon: Icons.person),
              _InputTextField(
                label: 'nome',
                icon: Icons.person,
                isPassword: false,
                obscureText: false,
                toggleVisibility: null,
                controller: _nomeController, // Adicionado
              ),

              SizedBox(height: 20),

              _CadastroButton(
                onPressed: () {
                  _cadastrarUsuario(
                    context,
                    _emailController.text.trim(),
                    _senhaController.text.trim(),
                    _telefoneController.text.trim(),
                    _nomeController.text.trim(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? toggleVisibility;

  final TextEditingController? controller;

  _InputTextField({
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleVisibility,
    this.controller,
  });

  /** 
  _InputTextField({
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleVisibility,
  });

  */

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350, // Largura fixa
      height: 45,
      decoration: BoxDecoration(
        color: const Color.fromARGB(40, 0, 0, 0), // Fundo cinza claro
        borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
      ),
      child: TextFormField(
          obscureText: obscureText, // Usa o valor correto para obscureText
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: toggleVisibility,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
              borderSide: BorderSide.none, // Remove a borda padrão
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 10, vertical: 15), // Padding interno
          ),
          controller: controller),
    );
  }
}

class _CadastroButton extends StatelessWidget {
  final VoidCallback onPressed;

  _CadastroButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 20),
        backgroundColor: const Color.fromARGB(255, 255, 102, 14),
      ),
      onPressed: onPressed, // Use a função passada
      child: Text('Cadastrar', style: TextStyle(color: Colors.white)),
    );
  }
}




/** 

class _CadastroButton extends StatelessWidget {
  final VoidCallback onPressed;

  _CadastroButton({required this.onPressed});
  
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
              context, MaterialPageRoute(builder: (context) => Feedbackregister()));

      },
      child: Text('Cadastrar', style: TextStyle(color: Colors.white)),
    );
  }
}

**/
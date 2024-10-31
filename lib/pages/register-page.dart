import 'package:flutter/material.dart';
import '../login-page.dart';

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
              _InputTextField(label: 'email', icon: Icons.email),
              SizedBox(height: 10),
              _InputTextField(
                label: 'senha',
                icon: Icons.lock,
                isPassword: true,
                obscureText: _obscureText,
                toggleVisibility: () {
                  setState(() {
                    _obscureText = !_obscureText; // Alterna a visibilidade
                  });
                },
              ),
              SizedBox(height: 10),
              _InputTextField(label: 'telefone', icon: Icons.phone),
              SizedBox(height: 10),
              _InputTextField(label: 'nome', icon: Icons.person),
              SizedBox(height: 20),
              _CadastroButton(),
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

  _InputTextField({
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleVisibility,
  });

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
      ),
    );
  }
}

class _CadastroButton extends StatelessWidget {
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
        
      },
      child: Text('Cadastrar', style: TextStyle(color: Colors.white)),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _performLogin() async {
    // Construir el cuerpo de la solicitud en formato JSON.
    Map<String, dynamic> requestBody = {
      'email': _usernameController.text,
      'password': _passwordController.text,
    };

    // Realizar la solicitud HTTP POST.
    final response = await http.post(
      Uri.parse('https://datafire-production.up.railway.app/Api/v1/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    // Verificar si la solicitud fue exitosa (código de estado 200).
    if (response.statusCode == 200) {
      // Analizar la respuesta JSON para obtener el token.
      Map<String, dynamic> responseData = json.decode(response.body);
      String token = responseData['token'];

      // Guardar el token en SharedPreferences.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Navegar a la siguiente pantalla después de iniciar sesión.
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Muestra un mensaje de error en caso de credenciales incorrectas.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credenciales incorrectas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _performLogin,
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

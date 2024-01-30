import 'package:datafire/src/view/users/alta_users(admin).dart';
import 'package:flutter/material.dart';

class UserVerificationView extends StatefulWidget {
  const UserVerificationView({Key? key}) : super(key: key);

  @override
  _UserVerificationViewState createState() => _UserVerificationViewState();
}

class _UserVerificationViewState extends State<UserVerificationView> {
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificación de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingrese su contraseña para acceder a UsersView:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Verificar la contraseña aquí
                String enteredPassword = _passwordController.text;
                if (enteredPassword == 'ultron') {
                  // Contraseña correcta, navegar a UsersView
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => UsersView()),
                  );
                } else {
                  // Contraseña incorrecta, mostrar mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Contraseña incorrecta, intente nuevamente'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Verificar'),
            ),
          ],
        ),
      ),
    );
  }
}

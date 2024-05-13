import 'package:datafire/src/view/users/alta_users(admin).dart';
import 'package:datafire/src/widgets/card.dart';
import 'package:flutter/material.dart';

class UserVerificationView extends StatefulWidget {
  const UserVerificationView({Key? key}) : super(key: key);

  @override
  _UserVerificationViewState createState() => _UserVerificationViewState();
}

class _UserVerificationViewState extends State<UserVerificationView> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alta y baja Usuarios',
          style: TextStyle(
            fontFamily: 'GoogleSans',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: const EdgeInsets.only(top: 110, left: 20),
          padding: const EdgeInsets.all(10),
          decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
          width: size.width < 800 ? size.width * 0.89 : size.width * 0.89,
          height: size.height < 800 ? size.height * 0.45 : 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ingrese la contraseña para administrar los usuarios:',
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Verificar la contraseña aquí
                  String enteredPassword = _passwordController.text;
                  if (enteredPassword == 'ultron') {
                    // Contraseña correcta, navegar a UsersView
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const UsersView()),
                    );
                  } else {
                    // Contraseña incorrecta, mostrar mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Contraseña incorrecta, intente nuevamente',
                          style: TextStyle(
                            fontFamily: 'GoogleSans',
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Verificar',
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

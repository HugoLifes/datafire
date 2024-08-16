import 'package:datafire/src/view/users/alta_users(admin).dart';
import 'package:datafire/src/widgets/appBar.dart';
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDatafire(
            title: "Alta Usuarios",
            description:
                "Aquí podras dar acceso a mas usuarios para administrar"),
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.5,
          height: size.height * 0.5,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                    style: const TextStyle(fontFamily: 'GoogleSans'),
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
        ),
      ),
    );
  }
}

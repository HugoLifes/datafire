import 'package:datafire/src/view/users/alta_users(admin).dart';
import 'package:datafire/src/widgets/card.dart';
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
        var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Alta y baja Usuarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.only(top: 110, left: 20),
          padding: EdgeInsets.all(10),
           decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
                         width: size.width < 800 ? size.width * 0.89 : size.width * 0.89,
              height: size.height < 800 ? size.height * 0.45 : 350,
           
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ingrese la contraseña para administrar los usuarios:',
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
      ),
    );
  }
}
